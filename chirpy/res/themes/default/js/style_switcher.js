/*################################################################################ Chirpy!, a quote management system                                          ## Copyright (C) 2005-2007 Tim De Pauw <ceetee@users.sourceforge.net>          ################################################################################# This program is free software; you can redistribute it and/or modify it     ## under the terms of the GNU General Public License as published by the Free  ## Software Foundation; either version 2 of the License, or (at your option)   ## any later version.                                                          ##                                                                             ## This program is distributed in the hope that it will be useful, but WITHOUT ## ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or       ## FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for   ## more details.                                                               ##                                                                             ## You should have received a copy of the GNU General Public License along     ## with this program; if not, write to the Free Software Foundation, Inc., 51  ## Franklin St, Fifth Floor, Boston, MA  02110-1301  USA                       ################################################################################################################################################################ style_switcher.js                                                           ## Makes the user's alternate stylesheet choice persistent using a cookie      ## Largely based on http://www.alistapart.com/articles/alternate/              ################################################################################# $Id::                                                                     $ ################################################################################*/function isStyleSheet (title) {	if (title == null) {		return false;	}	var l = document.getElementsByTagName("link");	for (var i = 0; i < l.length; i++) {		var a = l[i];		var t = a.getAttribute("title");		var r = a.getAttribute("rel");		if (r != null && r.indexOf("stylesheet") == r.length - 10		&& t != null && t == title) {			return true;		}	}	return false;}function setActiveStyleSheet (title) {	if (title == null) {		return false;	}	var l = document.getElementsByTagName("link");	var found = false;	for (var i = 0; i < l.length; i++) {		var a = l[i];		var t = a.getAttribute("title");		var r = a.getAttribute("rel");		if (r != null && r.indexOf("stylesheet") == r.length - 10		&& t != null && t.length > 0) {			var d = (t != title);			a.disabled = d;			if (!d) {				found = true;			}		}	}	return found;}function getActiveStyleSheet () {	var l = document.getElementsByTagName("link");	for (var i = 0; i < l.length; i++) {		var a = l[i];		var t = a.getAttribute("title");		var r = a.getAttribute("rel");		if (r != null && r.indexOf("stylesheet") == r.length - 10		&& t != null && t.length > 0 && !a.disabled) {			return t;		}	}	return null;}function getPreferredStyleSheet () {	var l = document.getElementsByTagName("link");	for (var i = 0; i < l.length; i++) {		var a = l[i];		var t = a.getAttribute("title");		var r = a.getAttribute("rel");		if (r != null && r == "stylesheet" && t != null && t.length > 0) {			return t;		}	}	return null;}function readCookie (name) {	var nameEq = name + "=";	var ca = document.cookie.split(/; */);	for (var i = 0; i < ca.length; i++) {		var c = ca[i];		if (c.indexOf(nameEq) == 0) {			return c.substring(nameEq.length, c.length);		}	}	return null;}function createCookie (name, value) {	var date = new Date();	date.setYear(1900 + date.getYear() + 1);	document.cookie = name + "=" + value + "; expires=" + date.toGMTString()		+ "; path=" + cookiePath + "; domain=" + cookieDomain;}function addOnloadFunction (f) {	if (window.onload != null) {		var old = window.onload;		window.onload = function (e) {			old(e);			f();		};	}	else {		window.onload = f;	}}function addOnunloadFunction (f) {	if (window.onunload != null) {		var old = window.onunload;		window.onunload = function (e) {			old(e);			f();		};	}	else {		window.onunload = f;	}}addOnloadFunction(function () {	var style = readCookie("style");	if (isStyleSheet(style)) {		setActiveStyleSheet(style);	}});addOnunloadFunction(function () {	var style = getActiveStyleSheet();	if (style != null) {		createCookie("style", style);	}});