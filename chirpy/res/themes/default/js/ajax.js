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
# ajax.js                                                                     #
# Facilitates access to the browser's AJAX features, if any                   #
###############################################################################
*/

var ajaxMethods = new Array(
	function() { return new ActiveXObject("Msxml2.XMLHTTP") },
	function() { return new ActiveXObject("Microsoft.XMLHTTP") },
	function() { return new XMLHttpRequest() }
);

var ajaxMethodIndex = -1;

for (var i = 0; i < ajaxMethods.length; i++) {
	try {
		ajaxMethods[i]();
		ajaxMethodIndex = i;
		break;
	} catch (e) { }
}

function ajaxSupported () {
	return (ajaxMethodIndex >= 0);
}

function getAjaxObject () {
	return (ajaxSupported()
		? ajaxMethods[ajaxMethodIndex]()
		: null);
}