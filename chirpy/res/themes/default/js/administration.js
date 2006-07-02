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
# administration.js                                                           #
# Functions specific to the administration interface                          #
###############################################################################
*/

var eventLogTable;
var eventLogTableBody;
var eventLogHeaders;
var eventLogRequest;
var eventLogPreviousLinks = new Array();
var eventLogNextLinks = new Array();
var eventLogURLParam = new Array();
eventLogURLParam["start"] = 0;
eventLogURLParam["count"] = 10;

function editQuote (id) {
	var editLink = document.getElementById("quote-edit-" + id);
	editLink.parentNode.removeChild(editLink);
	var body = getNodeText("quote-body-" + id);
	var notes = getNodeText("quote-notes-" + id);
	var tags = getNodeText("quote-tags-" + id);
	var dataNode = document.getElementById("quote-data-" + id);
	while (dataNode.firstChild) dataNode.removeChild(dataNode.firstChild);
	var bodyArea = document.createElement("textarea");
	bodyArea.name = "body_" + id;
	bodyArea.appendChild(document.createTextNode(body));
	bodyArea.className = "body-field";
	var notesArea = document.createElement("textarea");
	notesArea.name = "notes_" + id;
	notesArea.appendChild(document.createTextNode(notes));
	notesArea.className = "notes-field";
	var tagsInput = document.createElement("input");
	tagsInput.name = "tags_" + id;
	tagsInput.value = tags;
	tagsInput.className = "tags-field";
	dataNode.appendChild(stickInDiv(bodyArea));
	dataNode.appendChild(stickInDiv(notesArea));
	dataNode.appendChild(stickInDiv(tagsInput));
}

function stickInDiv (node) {
	var div = document.createElement("div");
	div.className = "field-container";
	div.appendChild(node);
	return div;
}

function getNodeText (id) {
	var node = document.getElementById(id);
	if (!node) return "";
	var text = "";
	for (var i = 0; i < node.childNodes.length; i++) {
		var child = node.childNodes[i];
		if (child.nodeType == 3) {
			text += child.nodeValue.replace(/ *[\r\n]/g, "");
		}
		else if (child.nodeName && child.nodeName.toLowerCase() == "br") {
			// \n breaks in IE
			text += "\r";
		}
	}
	return text;
}

function insertEventLog () {
	var node = document.getElementById("event-log-placeholder");
	if (!node || !ajaxSupported()) return;
	var div = document.createElement("div");
	var navTop = createEventLogNavigation();
	navTop.id = "event-log-navigation-top";
	var navBottom = createEventLogNavigation();
	navBottom.id = "event-log-navigation-bottom";
	div.appendChild(navTop);
	var table = document.createElement("table");
	eventLogTable = table;
	eventLogHeaders = new Array();
	table.id = "event-log-table";
	var thead = document.createElement("thead");
	var thr = document.createElement("tr");
	var cols = [ "id", "date", "username", "event" ];
	for (var i = 0; i < cols.length; i++) {
		var col = cols[i];
		var th = document.createElement("th");
		th.className = col;
		th.appendChild(document.createTextNode(eventLogLocale[col]));
		thr.appendChild(th);
		eventLogHeaders[col] = th;
	}
	thead.appendChild(thr);
	table.appendChild(thead);
	eventLogTableBody = document.createElement("tbody");
	table.appendChild(eventLogTableBody);
	div.appendChild(table);
	div.appendChild(navBottom);
	node.parentNode.replaceChild(div, node);
	updateEventLog();
}

function createEventLogNavigation () {
	var div = document.createElement("div");
	div.className = "event-log-navigation";
	var prev = document.createElement("a");
	var pHref = document.createAttribute("href");
	prev.setAttributeNode(pHref);
	prev.appendChild(document.createTextNode(
		String.fromCharCode(0x2190) + " " + eventLogLocale["previous"]));
	prev.className = "back";
	var next = document.createElement("a");
	var nHref = document.createAttribute("href");
	next.setAttributeNode(nHref);
	next.appendChild(document.createTextNode(
		eventLogLocale["next"] + " " + String.fromCharCode(0x2192)));
	next.className = "forward";
	div.appendChild(prev);
	div.appendChild(next);
	eventLogPreviousLinks.push(prev);
	eventLogNextLinks.push(next);
	return div;
}

function updateEventLog (reset) {
	clearEventLog();
	var tr = document.createElement("tr");
	var td = document.createElement("td");
	td.colSpan = 4;
	td.className = "loading";
	td.appendChild(document.createTextNode("[" + eventLogLocale["loading"] + "]"));
	tr.appendChild(td);
	eventLogTableBody.appendChild(tr);
	eventLogHeaders["event"].className = "event" + (eventLogURLParam["code"] != null ? " filtered" : "");
	eventLogHeaders["username"].className = "username" + (eventLogURLParam["user"] != null ? " filtered" : "");
	if (eventLogRequest) eventLogRequest.abort();
	eventLogRequest = getAjaxObject();
	eventLogRequest.onreadystatechange = checkEventLogRequest;
	var url = eventLogURL + getEventLogURLString(reset) + "&output=xml";
	eventLogRequest.open("GET", url, true);
	eventLogRequest.send("");
}

function checkEventLogRequest () {
	if (eventLogRequest.readyState != 4 || eventLogRequest.status != 200) return;
	var xml = eventLogRequest.responseXML;
	eventLogRequest = null;
	var data = parseEventLogXML(xml);
	if (data == null) {
		return;
	}
	fillEventLog(data);
}

function clearEventLog () {
	setEventLogNavigationEnabled(false, false);
	setEventLogNavigationEnabled(true, false);
	while (eventLogTableBody.firstChild)
		eventLogTableBody.removeChild(eventLogTableBody.firstChild);
}

function fillEventLog (tableData) {
	clearEventLog();
	setEventLogNavigationEnabled(false, tableData["leading"]);
	setEventLogNavigationEnabled(true, tableData["trailing"]);
	var events = tableData["events"];
	var dataFilter;
	if (eventLogURLParam["data"])
		dataFilter = eventLogURLParam["data"].replace(/=.*/, "");
	for (var i = 0; i < events.length; i++) {
		var evt = events[i];
		var data = evt["data"];
		var evenOdd = (i % 2 == 0 ? "even" : "odd");
		var firstRow = document.createElement("tr");
		firstRow.className = evenOdd;
		var idCell = document.createElement("td");
		idCell.className = "id";
		var rowSpan = 1;
		for (name in data) rowSpan++;
		idCell.rowSpan = rowSpan;
		idCell.appendChild(document.createTextNode(evt["id"]));
		firstRow.appendChild(idCell);
		var dateCell = document.createElement("td");
		dateCell.className = "date";
		dateCell.appendChild(document.createTextNode(evt["date"]));
		firstRow.appendChild(dateCell);
		var userCell = document.createElement("td");
		userCell.className = "username";
		var userID = evt["userid"];
		var username;
		if (userID == 0) {
			userCell.className += " guest";
			username = eventLogLocale["guest"];
		}
		else if ("username" in evt) {
			username = evt["username"];
		}
		else {
			userCell.className += " removed-account";
			username = "#" + userID;
		}
		var userLink = createEventLogLink("user", userID);
		userLink.appendChild(document.createTextNode(username));
		userCell.appendChild(userLink);
		firstRow.appendChild(userCell);
		var descCell = document.createElement("td");
		descCell.className = "event";
		var descLink = document.createElement("a");
		var descHref = document.createAttribute("href");
		var descLink = createEventLogLink("code", evt["code"]);
		descLink.appendChild(document.createTextNode(evt["description"]));
		descCell.appendChild(descLink);
		firstRow.appendChild(descCell);
		eventLogTableBody.appendChild(firstRow);
		for (name in data) {
			var value = data[name];
			var row = document.createElement("tr");
			row.className = evenOdd;
			var nameCell = document.createElement("td");
			nameCell.className = "property-name";
			if (dataFilter && name == dataFilter)
				nameCell.className += " filtered";
			nameCell.appendChild(document.createTextNode(name));
			var valueCell = document.createElement("td");
			valueCell.className = "property-value";
			valueCell.colSpan = 2;
			if (value.length > 1) {
				valueCell.appendChild(document.createTextNode(fixWhiteSpace(value[0])));
				for (var j = 1; j < value.length; j++) {
					valueCell.appendChild(document.createElement("br"));
					valueCell.appendChild(document.createTextNode(fixWhiteSpace(value[j])));
				}
			}
			else {
				var empty = (value.length == 0);
				var val = (!empty ? value[0].replace(/'/g, '\\\'') : "");
				var link = createEventLogLink("data", name + "=" + val);
				var text;
				if (empty) {
					link.className = "empty";
					text = eventLogLocale["empty"];
				}
				else
					text = fixWhiteSpace(value[0]);
				link.appendChild(document.createTextNode(text));
				valueCell.appendChild(link);
			}
			row.appendChild(nameCell);
			row.appendChild(valueCell);
			eventLogTableBody.appendChild(row);
		}
	}
}

function setEventLogNavigationEnabled (next, enabled) {
	var links, className;
	if (next) {
		links = eventLogNextLinks;
		className = "forward";
	}
	else {
		links = eventLogPreviousLinks;
		className = "back";
	}
	for (var i = 0; i < links.length; i++) {
		var link = links[i];
		var href = link.getAttributeNode("href");
		if (enabled) {
			link.className = className;
			var start = eventLogURLParam["start"];
			var count = eventLogURLParam["count"];
			if (!next)
				start = (start >= count ? start - count : 0);
			else
				start += count;
			link.onclick = function () {
				eventLogURLParam["start"] = start;
				updateEventLog();
				return false;
			};
			href.value = getEventLogURLString(false, "start", start);
		}
		else {
			link.className = className + " inactive";
			link.onclick = function () {
				return false;
			};
			href.value = "#";
		}
	}
}

function parseEventLogXML (xml) {
	if (!xml || !xml.childNodes) return null;
	var leading = false;
	var trailing = false;
	var events = new Array();
	for (var i = 0; i < xml.childNodes.length; i++) {
		var root = xml.childNodes[i];
		if (root.nodeType == 1) {
			for (var j = 0; j < root.childNodes.length; j++) {
				var child = root.childNodes[j];
				if (child.nodeType == 1) {
					switch (child.nodeName) {
						case "event":
							events.push(parseLogEventNode(child));
							break;
						case "leading":
							leading = true;
							break;
						case "trailing":
							trailing = true;
							break;
					}
				}
			}
			break;
		}
	}
	var data = new Array();
	data["leading"] = leading;
	data["trailing"] = trailing;
	data["events"] = events;
	return data;
}

function parseLogEventNode (node) {
	var event = new Array();
	event["data"] = new Array();
	for (var i = 0; i < node.childNodes.length; i++) {
		var child = node.childNodes[i];
		if (child.nodeType == 1) {
			if (child.nodeName == "data") {
				var name, value;
				for (var j = 0; j < child.childNodes.length; j++) {
					var n = child.childNodes[j];
					if (n.nodeType == 1) {
						switch (n.nodeName) {
							case "name":
								name = n.firstChild.nodeValue;
								break;
							case "value":
								value = extractLogEventDataValue(n);
								break;
						}
					}
				}
				event["data"][name] = value;
			}
			else {
				event[child.nodeName] = child.firstChild.nodeValue;
			}
		}
	}
	return event;
}

function extractLogEventDataValue (node) {
	var value = new Array();
	for (var i = 0; i < node.childNodes.length; i++) {
		var child = node.childNodes[i];
		if (child.nodeType != 3) continue;
		value.push(child.nodeValue);
	}
	return value;
}

function createEventLogLink (name, value) {
	var anchor = document.createElement("a");
	var href = document.createAttribute("href");
	href.value = eventLogURL + getEventLogURLString(true, name, value);
	anchor.setAttributeNode(href);
	anchor.onclick = function () {
		eventLogURLParam[name]
			= (eventLogURLParam[name] == value ? null : value);
		updateEventLog(true);
		return false;
	};
	return anchor;
}

function getEventLogURLString (reset, name, value) {
	var pairs = new Array();
	var found = false;
	for (key in eventLogURLParam) {
		var val;
		switch (key) {
			case name:
				val = (eventLogURLParam[key] == value ? null : value);
				found = true;
				break;
			case "start":
				val = (reset ? 0 : eventLogURLParam[key]);
				break;
			default:
				val = eventLogURLParam[key];
		}
		if (val != null)
			pairs.push(escape(key) + "=" + escape(val));
	}
	if (name && !found) {
		pairs.push(escape(name) + "=" + escape(value));
	}
	return pairs.join("&");
}

function fixWhiteSpace (text) {
	var nbsp = String.fromCharCode(160);
	return text
		.replace(/[\r\n]+/g, "")
		.replace(/^\s/, nbsp)
		.replace(/\s$/, nbsp)
		.replace(/\s{2}/g, nbsp + nbsp);
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

addOnloadFunction(insertEventLog);