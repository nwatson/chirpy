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

function editQuote (id) {
	var editLink = document.getElementById("quote-edit-" + id);
	editLink.parentNode.removeChild(editLink);
	var body = getNodeText("quote-body-" + id);
	var notes = getNodeText("quote-notes-" + id);
	var tags = getNodeText("quote-tags-" + id);
	var dataNode = document.getElementById("quote-data-" + id);
	while (dataNode.firstChild) dataNode.removeChild(dataNode.firstChild);
	var bodyArea = document.createElement("textarea");
	bodyArea.setAttribute("name", "body_" + id);
	bodyArea.appendChild(document.createTextNode(body));
	bodyArea.className = "body-field";
	var notesArea = document.createElement("textarea");
	notesArea.setAttribute("name", "notes_" + id);
	notesArea.appendChild(document.createTextNode(notes));
	notesArea.className = "notes-field";
	var tagsInput = document.createElement("input");
	tagsInput.setAttribute("name", "tags_" + id);
	tagsInput.setAttribute("value", tags);
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