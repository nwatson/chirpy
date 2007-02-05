/*
###############################################################################
# Chirpy!, a quote management system                                          #
# Copyright (C) 2005-2007 Tim De Pauw <ceetee@users.sourceforge.net>          #
###############################################################################
# This program is free software; you can redistribute it and/or modify it     #
# under the terms of the GNU General Public License as published by the Free  #
# Software Foundation; either version 2 of the License, or (at your option)   #
# any later version.                                                          #
#                                                                             #
# This program is distributed in the hope that it will be useful, but WITHOUT #
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or       #
# FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for   #
# more details.                                                               #
#                                                                             #
# You should have received a copy of the GNU General Public License along     #
# with this program; if not, write to the Free Software Foundation, Inc., 51  #
# Franklin St, Fifth Floor, Boston, MA  02110-1301  USA                       #
###############################################################################

###############################################################################
# tag_cloud.js                                                                #
# Allows user interaction with the tag cloud                                  #
###############################################################################
# $Id::                                                                     $ #
###############################################################################
*/

var tagCloudUpdateTime = 5;

var tagUseRE = new RegExp("\\bused-(\\d+)\\b");
var tagUseMinimum = 1;
var tagCloudSliderLabelText;
var tagNodes;

function initializeTagCloudSlider (labelPrefix) {
	var cloud = document.getElementById("tag-cloud");
	tagNodes = new Array();
	var maxUseCount = 0;
	for (var i = 0; i < cloud.childNodes.length; i++) {
		var child = cloud.childNodes[i];
		if (child.nodeName && child.nodeName.toUpperCase() == "LI") {
			var matches = child.className.match(tagUseRE);
			var cnt = parseInt(matches[1]);
			if (!tagNodes[cnt]) tagNodes[cnt] = new Array();
			tagNodes[cnt].push(child);
			if (cnt > maxUseCount) maxUseCount = cnt;
		}
	}
	var newMaxUseCount = Math.floor(maxUseCount / 4);
	if (newMaxUseCount > 1) maxUseCount = newMaxUseCount;
	var val = readCookie("tag_use");
	if (!val || val <= 0 || val > maxUseCount) val = 1;
	var container = document.createElement("div");
	container.id = "tag-cloud-slider-container";
	var sl = document.createElement("div");
	sl.id = "tag-cloud-slider";
	var form = document.createElement("form");
	form.action = "#";
	var input = document.createElement("input");
	input.id = input.name = "tag-cloud-slider-input";
	var label = document.createElement("div");
	label.id = "tag-usage-minimum";
	label.appendChild(document.createTextNode(labelPrefix + " "));
	tagCloudSliderLabelText = document.createTextNode(val);
	label.appendChild(tagCloudSliderLabelText);
	form.appendChild(input);
	sl.appendChild(form);
	container.appendChild(label);
	container.appendChild(sl);
	var placeholder = document.getElementById("tag-cloud-slider-placeholder");
	placeholder.parentNode.replaceChild(container, placeholder);
	var slider = new Slider(sl, input);
	slider.setMinimum(1);
	slider.setMaximum(maxUseCount);
	slider.setBlockIncrement(1);
	slider.setValue(val);
	slider.onchange = function () { setTagUseMinimum(slider.getValue()); };
	setTagUseMinimum(val);
}

function setTagUseMinimum (min) {
	if (tagUseMinimum == min) return;
	tagCloudSliderLabelText.nodeValue = min;
	createCookie("tag_use", min);
	if (min > tagUseMinimum)
		setTagNodesVisible(tagUseMinimum, min - 1, false);
	else
		setTagNodesVisible(min, tagUseMinimum - 1, true);
	tagUseMinimum = min;
}

function setTagNodesVisible (first, last, visible) {
	var disp = (visible ? "" : "none");
	for (var i = first; i <= last; i++) {
		var nodes = tagNodes[i];
		if (!nodes) continue;
		for (var j = 0; j < nodes.length; j++)
			nodes[j].style.display = disp;
	}
}

function readCookie (name) {
	var nameEq = name + "=";
	var ca = document.cookie.split(/; */);
	for (var i = 0; i < ca.length; i++) {
		var c = ca[i];
		if (c.indexOf(nameEq) == 0)
			return c.substring(nameEq.length, c.length);
	}
	return null;
}

function createCookie (name, value) {
	var date = new Date();
	date.setYear(1900 + date.getYear() + 1);
	document.cookie = name + "=" + value + "; expires=" + date.toGMTString()
		+ "; path=" + cookiePath + "; domain=" + cookieDomain;
}