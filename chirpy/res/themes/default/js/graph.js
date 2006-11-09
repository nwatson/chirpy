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
# $Id::                                                                     $ #
###############################################################################
*/

var graphConfig = new Array();
graphConfig["bar_chart_values"] = 5;
graphConfig["pie_chart_radius"] = 175;
graphConfig["pie_chart_extrusion"] = 5;
graphConfig["pie_chart_colors"] = new Array(
	"#DCDCDC", "#CCCCCC", "#BCBCBC", "#ACACAC"
);
graphConfig["pie_chart_border_width"] = 1;
graphConfig["pie_chart_border_color"] = "#ACACAC";
graphConfig["pie_chart_random_rotation"] = false;
graphConfig["ogive_values"] = 5;
graphConfig["ogive_chart_width"] = 660;
graphConfig["ogive_chart_height"] = 360;
graphConfig["ogive_chart_color"] = "#DCDCDC";
graphConfig["ogive_average_color"] = "#BCBCBC";
graphConfig["decimal_point_is_comma"] = false;
graphConfig["average_decimal_count"] = 2;

function checkForGraphs () {
	var dls = document.getElementsByTagName("dl");
	for (var i = dls.length - 1; i >= 0; i--) {
		var dl = dls[i];
		var func;
		if (hasClassName(dl, "bar-chart-data")) {
			func = createBarChart;
		}
		else if (hasClassName(dl, "pie-chart-data")) {
			func = createPieChart;
		}
		else if (hasClassName(dl, "ogive-data")) {
			func = createOgive;
		}
		if (func) {
			var chartData = extractChartData(dl);
			var samples = extractChartLabelCount(dl);
			var node = func(dl, chartData, samples);
			node.id = dl.id;
		}
	}
}

function createBarChart (sourceNode, chartData, samples) {
	var div = document.createElement("div");
	div.className = "chart bar-chart";
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
	createChartPane(div, graph, chartData, samples,
		graphConfig["bar_chart_values"], 0, max);
	var barWidth = 100 / chartData.length;
	var total = 0;
	for (var i = 0; i < chartData.length; i++) {
		var data = chartData[i];
		var text = data[0];
		var value = data[1];
		var column = document.createElement("div");
		column.className = "bar-chart-column";
		column.style.left = i * barWidth + "%";
		column.style.width = barWidth + "%";
		column.title = data[0] + " "
			+ String.fromCharCode(0x2192) + " " + data[1];
		if (value > 0) {
			var bar = document.createElement("div");
			bar.className = "bar-chart-bar";
			bar.style.height = Math.round(100 * value / max) + "%";
			var innerBar = document.createElement("div");
			innerBar.className = "bar-chart-inner-bar";
			bar.appendChild(innerBar);
			column.appendChild(bar);
		}
		graph.appendChild(column);
		total += value;
	}
	var avg = total / chartData.length;
	var avgDiv = document.createElement("div");
	avgDiv.className = "bar-chart-average-container";
	avgDiv.style.top = (100 - (100 * avg / max)) + "%";
	var stdDevTotal = 0;
	for (var i = 0; i < chartData.length; i++) {
		var temp = chartData[i][1] - avg;
		stdDevTotal += temp * temp;
	}
	var stdDev = roundToDecimals(
		Math.sqrt(stdDevTotal / chartData.length),
		graphConfig["average_decimal_count"]);
	var avgText = roundToDecimals(avg, graphConfig["average_decimal_count"]);
	if (graphConfig["decimal_point_is_comma"]) {
		avgText = ("" + avgText).replace(".", ",");
		stdDev = ("" + stdDev).replace(".", ",");
	}
	var avgSpan = document.createElement("span");
	avgSpan.appendChild(document.createTextNode(avgText));
	avgSpan.className = "bar-chart-average";
	var stdDevSpan = document.createElement("span");
	stdDevSpan.appendChild(
		document.createTextNode(String.fromCharCode(0x00B1) + " " + stdDev));
	stdDevSpan.className = "bar-chart-standard-deviation";
	var avgTextDiv = document.createElement("div");
	avgTextDiv.appendChild(avgSpan);
	avgTextDiv.appendChild(document.createTextNode(" "));
	avgTextDiv.appendChild(stdDevSpan);
	avgDiv.appendChild(avgTextDiv);
	graph.appendChild(avgDiv);
	sourceNode.parentNode.replaceChild(div, sourceNode);
	return div;
}

function createPieChart (sourceNode, chartData) {
	var cnv = document.createElement("canvas");
	var rad = graphConfig["pie_chart_radius"];
	var ext = graphConfig["pie_chart_extrusion"];
	var side = (rad + ext) * 2;
	cnv.width = cnv.height = side;
	cnv.style.width = cnv.style.height = side + "px";
	var graph = document.createElement("div");
	graph.appendChild(cnv);
	cnv = ensureCanvas(cnv);
	if (!cnv) {
		return createBarChart(sourceNode, chartData);
	}
	var div = document.createElement("div");
	div.className = "chart pie-chart";
	sourceNode.parentNode.replaceChild(div, sourceNode);
	graph.className = "pie-chart-graph";
	var legend = document.createElement("dl");
	legend.className = "pie-chart-legend";
	div.appendChild(graph);
	div.appendChild(legend);
	drawPieChart(cnv, legend, chartData);
	return div;
}

function drawPieChart (canvas, legend, data) {
	var ctx = canvas.getContext("2d");
	var total = 0;
	for (var i = 0; i < data.length; i++) {
		total += data[i][1];
	}
	var runningTotal = 0;
	var rad = graphConfig["pie_chart_radius"];
	var ext = graphConfig["pie_chart_extrusion"];
	var xCenter = rad + ext;
	var yCenter = rad + ext;
	var radius = rad;
	var colors = graphConfig["pie_chart_colors"];
	var stroke;
	if (graphConfig["pie_chart_border_width"]) {
		ctx.strokeStyle = graphConfig["pie_chart_border_color"];
		var w = graphConfig["pie_chart_border_width"];
		ctx.lineWidth = w;
		radius -= 2 * w;
		stroke = true;
	}
	else {
		stroke = false;
	}
	var initialAngle = (graphConfig["pie_chart_random_rotation"]
		? Math.round(2 * Math.PI * Math.random())
		: - Math.PI / 2);
	for (var i = 0; i < data.length; i++) {
		var name = data[i][0];
		var value = data[i][1];
		var color = colors[i % colors.length];
		if (value > 0) {
			var startAngle = runningTotal / total * 2 * Math.PI + initialAngle;
			runningTotal += value;
			var endAngle = runningTotal / total * 2 * Math.PI + initialAngle;
			var diff = (startAngle + endAngle) / 2;
			var x = xCenter + Math.cos(diff) * ext;
			var y = yCenter + Math.sin(diff) * ext;
			ctx.fillStyle = color;
			ctx.beginPath();
			ctx.moveTo(x, y);
			ctx.arc(x, y, radius, startAngle, endAngle, false);
			ctx.lineTo(x, y);
			ctx.closePath();
			ctx.fill();
			if (stroke) {
				// Safari doesn't like it when we don't recreate the path
				ctx.beginPath();
				ctx.moveTo(x, y);
				ctx.arc(x, y, radius, startAngle, endAngle, false);
				ctx.lineTo(x, y);
				ctx.closePath();
				ctx.stroke();
			}
		}
		var block = document.createElement("div");
		block.style.backgroundColor = color;
		var dt = document.createElement("dt");
		dt.appendChild(block);
		legend.appendChild(dt);
		var dd = document.createElement("dd");
		var l = document.createElement("span");
		l.className = "label";
		l.appendChild(document.createTextNode(name));
		dd.appendChild(l);
		var v = document.createElement("span");
		v.className = "value";
		v.appendChild(document.createTextNode(value));
		dd.appendChild(v);
		var p = document.createElement("span");
		p.className = "percentage";
		p.appendChild(document.createTextNode(
			Math.round(100 * value / total) + "%"));
		dd.appendChild(p);
		legend.appendChild(dd);
	}
}

function createOgive (sourceNode, chartData, samples) {
	var cnv = document.createElement("canvas");
	cnv.width = graphConfig["ogive_chart_width"];
	cnv.height = graphConfig["ogive_chart_height"];
	cnv.style.width = graphConfig["ogive_chart_width"] + "px";
	cnv.style.height = graphConfig["ogive_chart_height"] + "px";
	var graph = document.createElement("div");
	graph.appendChild(cnv);
	cnv = ensureCanvas(cnv);
	if (!cnv) {
		var total = 0;
		for (var i = 0; i < chartData.length; i++) {
			var old = chartData[i][1];
			chartData[i][1] += total;
			total += old;
		}
		return createBarChart(sourceNode, chartData, samples);
	}
	var div = document.createElement("div");
	div.className = "chart ogive";
	div.appendChild(graph);
	sourceNode.parentNode.replaceChild(div, sourceNode);
	graph.className = "ogive-graph";
	var ignoreFirst = extractOgiveIgnoreCount(sourceNode);
	var points = sampleOgiveData(chartData,
		extractOgiveAverageSampleCount(sourceNode), ignoreFirst);
	var chartCumulData = new Array();
	var ignoreTotal = 0;
	for (var i = 0; i < ignoreFirst; i++) {
		ignoreTotal += chartData[i][1];
		chartCumulData[i] = ignoreTotal;
	}
	var total = ignoreTotal;
	for (var i = ignoreFirst; i < chartData.length; i++) {
		total += chartData[i][1];
		chartCumulData[i] = total;
	}
	var chartAvgData = new Array();
	/*
	// Old: Value-based, less smooth
	for (var i = ignoreFirst; i < chartData.length; i++) {
		chartAvgData[i] = ignoreTotal + lagrangeInterpolate(i, points);
	}
	*/
	// New: pixel-based
	var width = graphConfig["ogive_chart_width"];
	var firstX = Math.round(ignoreFirst / chartData.length * width);
	var max = chartCumulData[chartCumulData.length - 1];
	for (var x = firstX; x < width; x++) {
		var i = x / width * chartData.length;
		chartAvgData[x] = ignoreTotal + lagrangeInterpolate(i, points);
		if (chartAvgData[x] > max) {
			max = chartAvgData[x];
		}
	}
	createChartPane(div, graph, chartData, samples,
		graphConfig["ogive_values"], 0, max);
	var scale = graphConfig["ogive_chart_height"] / max;
	drawOgive(cnv, chartCumulData, false, scale);
	drawOgive(cnv, chartAvgData, true, scale);
	return div;
}

function drawOgive (canvas, chartData, avg, yScale) {
	var ctx = canvas.getContext("2d");
	var graphWidth = graphConfig["ogive_chart_width"];
	var graphHeight = graphConfig["ogive_chart_height"];
	if (avg) {
		ctx.strokeStyle = graphConfig["ogive_average_color"];
		ctx.lineWidth = 1;
	}
	else {
		ctx.fillStyle = graphConfig["ogive_chart_color"];
	}
	var xScale = graphWidth / chartData.length;
	var x0 = 0;
	var y0 = graphHeight;
	ctx.beginPath();
	var notFirst = false;
	for (var i = 0; i < chartData.length; i++) {
		if (chartData[i] == null) continue;
		var x = Math.round(x0 + (i + 1) * xScale);
		var y = Math.round(y0 - chartData[i] * yScale);
		if (notFirst) {
			ctx.lineTo(x, y);
		}
		else {
			ctx.moveTo(x, y);
			notFirst = true;
		}
	}
	if (avg) {
		ctx.stroke();
	}
	else {
		ctx.lineTo(graphWidth, graphHeight);
		ctx.lineTo(x0, y0);
		ctx.fill();
	}
	return yScale;
}

function sampleOgiveData (chartData, samples, ignoreFirst) {
	var segSize = (chartData.length - ignoreFirst) / (samples - 1);
	var total = chartData[ignoreFirst][1];
	var points = new Array();
	points[0] = [ ignoreFirst, total ];
	for (var i = ignoreFirst + 1; i < chartData.length; i++) {
		total += chartData[i][1];
		var seg = Math.floor((i - ignoreFirst) / segSize);
		if (points[seg]) continue;
		points[seg] = [ i, total ];
	}
	points[samples - 1] = [ chartData.length - 1, total ];
	return points;
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
	var result = extractChartParameter(dl, "label-count");
	if (result == null) return 0;
	return result;
}

function extractOgiveIgnoreCount (dl) {
	var result = extractChartParameter(dl, "ignore-first");
	if (result == null) return 0;
	return result;
}

function extractOgiveAverageSampleCount (dl) {
	var result = extractChartParameter(dl, "average-sample-count");
	if (result == null) return 3;
	return result;
}

function extractChartParameter (dl, name) {
	name += "-";
	var classNames = dl.className.split(/\s+/);
	for (var i = 0; i < classNames.length; i++) {
		var className = classNames[i];
		if (className.indexOf(name) == 0) {
			return parseInt(className.substring(name.length));
		}
	}
	return null;
}

function createChartPane (div, graph, chartData, samples, values, min, max) {
	div.appendChild(createChartValues(0, max, values, graph));
	div.appendChild(createChartLabels(chartData, samples));
}

function createChartValues (min, max, count, graph) {
	var values = document.createElement("div");
	values.className = "chart-values";
	var top = createChartValue(max);
	top.style.top = "0";
	top.style.marginTop = "0";
	var bottom = createChartValue(min);
	bottom.style.bottom = "0";
	bottom.style.marginBottom = "0";
	values.appendChild(top);
	var step = (max - min) / (count - 1);
	for (var i = 1; i < count - 1; i++) {
		var val = Math.round(step * i);
		var perc = 100 / (count - 1) * i + "%";
		var v = createChartValue(val);
		v.style.bottom = perc;
		values.appendChild(v);
		var line = document.createElement("div");
		line.className = "chart-line";
		line.style.top = perc;
		graph.appendChild(line);
	}
	var line = document.createElement("div");
	line.className = "chart-line";
	line.style.top = "0";
	graph.appendChild(line);
	values.appendChild(bottom);
	return values;
}

function createChartValue (value) {
	var v = document.createElement("div");
	v.className = "chart-value";
	v.appendChild(document.createTextNode(Math.round(value)));
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

// XXX: Speed up Lagrange interpolation

function lagrangeInterpolate (x, points) {
	var sum = 0;
	for (var i = 0; i < points.length; i++) {
		sum += points[i][1] * lagrangeBasis(x, points, i);
	}
	return sum;
}

function lagrangeBasis (x, points, index) {
	var product = 1;
	for (var i = 0; i < points.length; i++) {
		if (i == index) continue;
		product *= (x - points[i][0]) / (points[index][0] - points[i][0]);
	}
	return product;
}

function ensureCanvas (canvas) {
	if (!canvas.getContext && useExCanvas()) {
		canvas = G_vmlCanvasManager.initElement(canvas);
	}
	return (canvas.getContext ? canvas : null);
}

function useExCanvas () {
	return (typeof G_vmlCanvasManager != "undefined");
}

function hasClassName (element, className) {
	return element.className.match(new RegExp("\\b" + className + "\\b"));
}

function roundToDecimals (number, decimals) {
	var factor = Math.pow(10, decimals);
	return Math.round(number * factor) / factor;
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
