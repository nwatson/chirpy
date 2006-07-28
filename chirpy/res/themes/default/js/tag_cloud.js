/*
###############################################################################
# Chirpy!, a quote management system                                          #
# Copyright (C) 2005-2006 Tim De Pauw <ceetee@users.sourceforge.net>          #
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
*/

var tagCloudUpdateTime = 5;

var tagUseRE = new RegExp("\\bused-(\\d+)\\b");
var tagCloudSliderLabelText;
var tagNodes;

function initializeTagCloudSlider (labelPrefix) {
	var cloud = document.getElementById("tag-cloud");
	tagNodes = new Array();
	var maxUseCount = 0;
	for (var i = 0; i < cloud.childNodes.length; i++) {
		var child = cloud.childNodes[i];
		if (child.nodeName && child.nodeName.toUpperCase() == "LI") {
			tagNodes.push(child);
			var matches = child.className.match(tagUseRE);
			var cnt = parseInt(matches[1]);
			child.useCount = cnt;
			if (cnt > maxUseCount) {
				maxUseCount = cnt;
			}
		}
	}
	maxUseCount = Math.floor(maxUseCount / 4);
	if (maxUseCount == 0) maxUseCount = 1;
	var label = document.createElement("div");
	label.id = "tag-usage-minimum";
	label.appendChild(document.createTextNode(labelPrefix + " "));
	tagCloudSliderLabelText = document.createTextNode("1");
	label.appendChild(tagCloudSliderLabelText);
	var slc = document.getElementById("tag-cloud-slider-container");
	slc.insertBefore(label, slc.firstChild);
	var slider = new Slider(document.getElementById("tag-cloud-slider"),
		document.getElementById("tag-cloud-slider-input"));
	slider.setMinimum(1);
	slider.setMaximum(maxUseCount);
	var val = readCookie("tag_use");
	if (!val || val <= 0 || val > maxUseCount) val = 1;
	else setTagUseMinimum(val);
	slider.setValue(val);
	slider.onchange = function () { setTagUseMinimum(slider.getValue()); };
}

function setTagUseMinimum (min) {
	tagCloudSliderLabelText.nodeValue = min;
	createCookie("tag_use", min);
	for (var i = 0; i < tagNodes.length; i++) {
		var node = tagNodes[i];
		node.style.display = (node.useCount < min ? "none" : "");
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