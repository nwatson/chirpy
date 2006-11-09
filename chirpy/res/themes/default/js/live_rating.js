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
# live_rating.js                                                              #
# Enables rating and reporting of quotes without leaving the page             #
###############################################################################
# $Id::                                                                     $ #
###############################################################################
*/

var useBlinking = true;
var confirmationTimeout = 3000;
var errorTimeout = 10000;
var connectionTimeout = 30000;
var pollingInterval = 1000;
var okText = (/MSIE/.test(navigator.userAgent) && !window.opera
	? "OK" : String.fromCharCode(0x2713));

var requests = new Array();

function QuoteActionRequest (url, id, isReport) {
	var t = getTimestamp();
	var req = this;
	this.id = id;
	if (requests[this.id]) requests[this.id].verbose = false;
	requests[this.id] = this;
	this.url = url + "&output=xml&ignore=" + t;
	this.isReport = isReport;
	this.verbose = true;
	this.resultField = document.getElementById('quote-live-vote-result-' + id);
	this.setResult(locale["processing"], true);
	this.ajax = getAjaxObject();
	this.ajax.onreadystatechange = function() { readyStateChanged(req); };
	this.startTime = t;
	this.interval = setInterval(
		function () { checkRequestTime(req); }, pollingInterval);
	this.ajax.open("POST", this.url, true);
	this.ajax.send("");
}

QuoteActionRequest.prototype.setResult = function (text, blink, timeout) {
	if (!this.verbose) return;
	if (this.fadeTimeout) {
		clearTimeout(this.fadeTimeout);
		this.fadeTimeout = null;
	}
	setText(this.resultField, text);
	if (useBlinking)
		this.resultField.style.textDecoration = blink ? "blink" : "";
	var field = this.resultField;
	if (timeout)
		this.fadeTimeout = setTimeout(
			function () { setText(field, ""); }, timeout);
};

function sendRating (anchor, id) {
	if (!ajaxSupported()) return true;
	new QuoteActionRequest(anchor.href, id, false);
	return false;
}

function sendReport (anchor, id) {
	if (!ajaxSupported()) return true;
	new QuoteActionRequest(anchor.href, id, true);
	return false;
}

function readyStateChanged (req) {
	if (req.ajax.readyState != 4) return;
	if (req.ajax.status == 200) {
		if (req.isReport)
			reportRequestCompleted(req, processXML(req.ajax.responseXML));
		else
			ratingRequestCompleted(req, processXML(req.ajax.responseXML));
	}
	else
		req.setResult(locale["error"], false, errorTimeout);
	removeRequest(req);
}

function ratingRequestCompleted (req, result) {
	if (result) {
		switch (result["status"]) {
			case "1":
				req.setResult("");
				setText(document.getElementById('quote-rating-' + req.id),
					result["rating"]);
				var vc = document.getElementById('quote-vote-count-' + req.id);
				if (vc) setText(vc, result["votes"]);
				req.setResult(okText, false, confirmationTimeout);
				break;
			case "2":
				req.setResult(locale["error"], false, errorTimeout);
				if (req.verbose) alert(locale["already_rated_text"]);
				break;
			case "3":
				req.setResult(locale["error"], false, errorTimeout);
				if (req.verbose) alert(locale["limit_exceeded_text"]);
				break;
			case "4":
				req.setResult(locale["error"], false, errorTimeout);
				if (req.verbose) alert(locale["quote_not_found_text"]);
				break;
			case "5":
				req.setResult(locale["error"], false, errorTimeout);
				if (req.verbose) alert(locale["session_required_text"]);
				break;
			default:
				req.setResult(locale["error"], false, errorTimeout);
				break;
		}
	}
	else
		req.setResult(locale["error"], false, errorTimeout);
}

function reportRequestCompleted (req, result) {
	if (result) {
		switch (result["status"]) {
			case "1":
				req.setResult("");
				document.getElementById('quote-' + req.id).className
					+= " flagged";
				var rep = document.getElementById('quote-report-' + req.id);
				var el = document.createElement("span");
				var at = document.createAttribute("class");
				at.value = "quote-flagged";
				el.setAttributeNode(at);
				el.appendChild(document.createTextNode(
					"[" + locale["flagged"] + "]"));
				rep.parentNode.replaceChild(el, rep);
				req.setResult(okText, false, confirmationTimeout);
				break;
			case "5":
				req.setResult(locale["error"], false, errorTimeout);
				if (req.verbose) alert(locale["session_required_text"]);
				break;
			default:
				req.setResult(locale["error"], false, errorTimeout);
				break;
		}
	}
	else
		req.setResult(locale["error"], false, errorTimeout);
}

function removeRequest (req) {
	requests[req.id] = null;
	clearInterval(req.interval);
}

function checkRequestTime (req) {
	if (getTimestamp() - req.startTime >= connectionTimeout) {
		clearInterval(req.interval);
		req.setResult(locale["error"], false, errorTimeout);
		if (req.verbose) alert(locale["timeout_text"]);
	}
}

function processXML (xml) {
	if (!xml || !xml.childNodes
	|| xml.childNodes[xml.childNodes.length - 1].nodeName != "result")
		return null;
	var a = new Array();
	var root = xml.childNodes[xml.childNodes.length - 1];
	for (var i = 0; i < root.childNodes.length; i++) {
		var node = root.childNodes[i];
		a[node.nodeName] = node.firstChild.nodeValue;
	}
	return a;
}

function getTimestamp () {
	return (new Date()).getTime();
}

function setText (element, text) {
	if (element.firstChild)
		element.firstChild.nodeValue = text;
	else
		element.appendChild(document.createTextNode(text));
}