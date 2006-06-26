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
# graph.js                                                                    #
# Turns graph data into nice graphs                                           #
###############################################################################
*/

var graphConfig = new Array();
graphConfig["bar_chart_values"] = 5;
graphConfig["ogive_values"] = 5;
graphConfig["ogive_chart_width"] = 660;
graphConfig["ogive_chart_height"] = 360;
graphConfig["ogive_chart_color"] = "#DCDCDC";

function checkForGraphs () {
	var dls = document.getElementsByTagName("dl");
	for (var i = dls.length - 1; i >= 0; i--) {
		var dl = dls[i];
		if (hasClassName(dl, "bar-chart-data")) {
			var chartData = extractChartData(dl);
			var samples = extractChartLabelCount(dl);
			var chart = createBarChart(chartData, samples);
			chart.id = dl.id;
			dl.parentNode.replaceChild(chart, dl);
		}
		else if (hasClassName(dl, "ogive-data")) {
			var chartData = extractChartData(dl);
			var samples = extractChartLabelCount(dl);
			var chart = createOgive(chartData, samples);
			chart.id = dl.id;
			dl.parentNode.replaceChild(chart, dl);
		}
	}
}

function extractChartData (dl) {
	var name, label;
	var data = new Array();
	for (var i = 0; i < dl.childNodes.length; i++) {
		var child = dl.childNodes[i];
		var eln = child.nodeName.toLowerCase();
		switch (eln) {
			case "dt":
				name = child.firstChild.nodeValue;
				label = (child.title ? child.title : null);
				break;
			case "dd":
				var value = parseInt(child.firstChild.nodeValue);
				data.push(new Array(name, value, label));
				break;
		}
	}
	return data;
}

function extractChartLabelCount (dl) {
	var classNames = dl.className.split(/\s+/);
	var prefix = "label-count-";
	for (var i = 0; i < classNames.length; i++) {
		var className = classNames[i];
		if (className.indexOf(prefix) == 0) {
			return parseInt(className.substring(prefix.length));
		}
	}
	return 0;
}

function createBarChart (chartData, samples) {
	var div = document.createElement("div");
	div.className = "bar-chart";
	var graph = document.createElement("div");
	graph.className = "bar-chart-graph";
	div.appendChild(graph);
	var max = 0;
	for (var i = 0; i < chartData.length; i++) {
		var value = chartData[i][1];
		if (value > max) {
			max = value;
		}
	}
	createChartPane(div, graph, chartData, samples, graphConfig["bar_chart_values"], 0, max);
	var barWidth = 100 / chartData.length;
	for (var i = 0; i < chartData.length; i++) {
		var data = chartData[i];
		var text = data[0];
		var value = data[1];
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
		column.title = getBarChartTooltipText(data);
		column.appendChild(bar);
		graph.appendChild(column);
	}
	return div;
}

function getBarChartTooltipText (data) {
	return data[0] + " " + String.fromCharCode(0x2192) + " " + data[1];
}

function createOgive (chartData, samples) {
	var cnv = document.createElement("canvas");
	if (!cnv.getContext) {
		// Somewhat ugly fallback, mostly for IE.
		// TODO: Use excanvas instead.
		var total = 0;
		for (var i = 0; i < chartData.length; i++) {
			var old = chartData[i][1];
			chartData[i][1] += total;
			total += old;
		}
		return createBarChart(chartData, samples);
	}
	var div = document.createElement("div");
	div.className = "ogive";
	var graph = document.createElement("div");
	graph.className = "ogive-graph";
	cnv.width = graphConfig["ogive_chart_width"];
	cnv.height = graphConfig["ogive_chart_height"];
	drawOgive(cnv, chartData);
	var total = 0;
	for (var i = 0; i < chartData.length; i++) {
		total += chartData[i][1];
	}
	createChartPane(div, graph, chartData, samples, graphConfig["ogive_values"], 0, total);
	graph.appendChild(cnv);
	div.appendChild(graph);
	return div;
}

function drawOgive (canvas, chartData) {
	var ctx = canvas.getContext("2d");
	var total = 0;
	for (var i = 0; i < chartData.length; i++) {
		total += chartData[i][1];
	}
	var graphWidth = graphConfig["ogive_chart_width"];
	var graphHeight = graphConfig["ogive_chart_height"];
	var x0 = 0;
	var y0 = graphHeight;
	ctx.beginPath();
	ctx.moveTo(x0, y0);
	var runningTotal = 0;
	for (var i = 0; i < chartData.length; i++) {
		var name = chartData[i][0];
		var value = chartData[i][1];
		var label = chartData[i][2];
		runningTotal += value;
		var x = Math.round(x0 + (i / (chartData.length - 1)) * graphWidth);
		var y = Math.round(y0 - (runningTotal / total) * graphHeight);
		ctx.lineTo(x, y);
	}
	ctx.lineTo(graphWidth, graphHeight);
	ctx.closePath();
	ctx.fillStyle = graphConfig["ogive_chart_color"];
	ctx.fill();
}

function createChartPane (div, graph, chartData, samples, values, min, max) {
	for (var i = 0; i < values; i++) {
		var line = document.createElement("div");
		line.className = "chart-line";
		line.style.top = (100 / values) * i + "%";
		graph.appendChild(line);
	}
	div.appendChild(createChartValues(0, max, values));
	div.appendChild(createChartLabels(chartData, samples));
}

function createChartValues (min, max, count) {
	var values = document.createElement("div");
	values.className = "chart-values";
	var top = createChartValue(max);
	top.style.top = "0";
	var bottom = createChartValue(min);
	bottom.style.bottom = "0";
	bottom.style.marginBottom = "0";
	values.appendChild(top);
	var step = (max - min) / count;
	for (var i = 1; i < count; i++) {
		var val = Math.round(step * i);
		var v = createChartValue(val);
		v.style.bottom = 100 * i / count + "%";
		values.appendChild(v);
	}
	values.appendChild(bottom);
	return values;
}

function createChartValue (value) {
	var v = document.createElement("div");
	v.className = "chart-value";
	v.appendChild(document.createTextNode(value));
	return v;
}

function createChartLabels (chartData, samples) {
	var labels = document.createElement("div");
	labels.className = "chart-labels";
	var sample = (samples > 0 && chartData.length > samples);
	var barWidth = 100 / chartData.length;
	var sampleInterval, labelWidth;
	if (sample) {
		if (chartData.length < samples * 2) {
			samples = Math.ceil(chartData.length / 2);
		}
		sampleInterval = chartData.length / samples;
		labelWidth = 100 / samples;
		var firstLabel = createChartLabel(
			chartData[0], 0, labelWidth + "%",
			"left");
		labels.appendChild(firstLabel);
		var lastLabel = createChartLabel(
			chartData[chartData.length - 1],
			(100 - labelWidth) + "%", labelWidth + "%",
			"right");
		labels.appendChild(lastLabel);
	}
	else {
		labelWidth = barWidth;
	}
	var labelCount = 0;
	for (var i = 0; i < chartData.length; i++) {
		var data = chartData[i];
		if (!sample || Math.floor((labelCount + 0.5) * sampleInterval) == i) {
			if (sample && (++labelCount == 1 || labelCount == samples)) continue;
			var left = ((i + 0.5) * barWidth - labelWidth / 2) + "%";
			var label = createChartLabel(data, left, labelWidth + "%", "center");
			labels.appendChild(label);
		}
	}
	return labels;
}

function createChartLabel (data, position, width, align) {
	var label = document.createElement("div");
	label.className = "chart-label";
	label.style.left = position;
	label.style.width = width;
	var innerLabel = document.createElement("div");
	innerLabel.className = "chart-inner-label";
	var text = (data[2] != null ? data[2] : data[0]);
	innerLabel.appendChild(document.createTextNode(text));
	innerLabel.style.textAlign = align;
	label.appendChild(innerLabel);
	return label;
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