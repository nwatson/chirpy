/*
###############################################################################
# Chirpy! v0.3, a quote management system                                     #
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
# css_graph.js                                                                #
# Turns graph data into CSS-based graphs                                      #
###############################################################################
*/

function checkForGraphs () {
	checkForBarCharts();
}

function checkForBarCharts () {
	var dls = document.getElementsByTagName("dl");
	for (var i = dls.length - 1; i >= 0; i--) {
		var dl = dls[i];
		if (!hasClassName(dl, "bar-chart-data")) continue;
		var chartData = extractBarChartData(dl);
		var chart = createBarChart(chartData);
		chart.id = dl.id;
		dl.parentNode.replaceChild(chart, dl);
	}
}

function extractBarChartData (dl) {
	var name;
	var pairs = new Array();
	for (var i = 0; i < dl.childNodes.length; i++) {
		var child = dl.childNodes[i];
		var eln = child.nodeName.toLowerCase();
		switch (eln) {
			case "dt":
				name = child.firstChild.nodeValue;
				break;
			case "dd":
				var value = parseInt(child.firstChild.nodeValue);
				pairs.push(new Array(name, value));
				break;
		}
	}
	return pairs;
}

function createBarChart (chartData) {
	var div = document.createElement("div");
	div.className = "bar-chart";
	var graph = document.createElement("div");
	graph.className = "bar-chart-graph";
	var labels = document.createElement("div");
	labels.className = "bar-chart-labels";
	var values = document.createElement("div");
	values.className = "bar-chart-values";
	div.appendChild(graph);
	div.appendChild(labels);
	div.appendChild(values);
	var max = 0;
	for (var i = 0; i < chartData.length; i++) {
		var value = chartData[i][1];
		if (value > max) {
			max = value;
		}
	}
	var top = document.createElement("div");
	top.className = "bar-chart-maximum";
	top.appendChild(document.createTextNode(max));
	var bottom = document.createElement("div");
	bottom.className = "bar-chart-minimum";
	bottom.appendChild(document.createTextNode("0"));
	values.appendChild(top);
	values.appendChild(bottom);
	var barWidth = 100 / chartData.length;
	var samples = 7;
	var sample = (chartData.length > samples);
	var sampleInterval, labelWidth;
	if (sample) {
		if (chartData.length < samples * 2) {
			samples = Math.floor(chartData.length / 2);
		}
		sampleInterval = chartData.length / samples;
		labelWidth = 100 / samples;
		var first = chartData[0];
		labels.appendChild(createBarChartLabel(first[0], getBarChartTooltipText(first[0], first[1]), 0, labelWidth + "%", "left"));
		var last = chartData[chartData.length - 1];
		labels.appendChild(createBarChartLabel(last[0], getBarChartTooltipText(last[0], last[1]), (100 - labelWidth) + "%", labelWidth + "%", "right"));
	}
	else {
		labelWidth = barWidth;
	}
	var labelCount = 0;
	for (var i = 0; i < chartData.length; i++) {
		var text = chartData[i][0];
		var value = chartData[i][1];
		var bar = document.createElement("div");
		bar.className = "bar-chart-bar";
		bar.style.height = Math.round(100 * value / max) + "%";
		var innerBar = document.createElement("div");
		innerBar.className = "bar-chart-inner-bar";
		bar.appendChild(innerBar);
		var column = document.createElement("div");
		column.className = "bar-chart-column";
		column.style.left = i * barWidth + "%";
		column.style.width = barWidth + "%";
		column.title = getBarChartTooltipText(text, value);
		column.appendChild(bar);
		graph.appendChild(column);
		if (!sample || Math.round((labelCount + 0.5) * sampleInterval) == i) {
			if (sample && (++labelCount == 1 || labelCount == samples)) continue;
			var left = ((i + 0.5) * barWidth - labelWidth / 2) + "%";
			var label = createBarChartLabel(text, column.title, left, labelWidth + "%", "center");
			labels.appendChild(label);
		}
	}
	return div;
}

function createBarChartLabel (text, title, position, width, align) {
	var label = document.createElement("div");
	label.className = "bar-chart-label";
	label.style.left = position;
	label.style.width = width;
	var innerLabel = document.createElement("div");
	innerLabel.className = "bar-chart-inner-label";
	innerLabel.appendChild(document.createTextNode(text));
	innerLabel.title = title;
	innerLabel.style.textAlign = align;
	label.appendChild(innerLabel);
	return label;
}

function getBarChartTooltipText (text, value) {
	return text + " " + String.fromCharCode(0x2192) + " " + value;
}

function hasClassName (element, className) {
	return element.className.match(new RegExp("\\b" + className + "\\b"));
}

function addOnloadFunction (f) {
	if (window.onload != null) {
		var old = window.onload;
		window.onload = function (e) {
			old(e);
			f();
		};
	}
	else {
		window.onload = f;
	}
}

addOnloadFunction(checkForGraphs);