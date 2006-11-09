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
# tabbed_pane.js                                                              #
# Emulates a tabbed pane for the administrative interface                     #
###############################################################################
# $Id::                                                                     $ #
###############################################################################
*/

var tabs, activeTab;

function initializeTabbedPane (name, initialTab) {
	tabs = document.getElementById(name + '-navigation').childNodes;
	contents = document.getElementById(name + '-contents').childNodes;
	for (var i = 0; i < tabs.length; i++) {
		initializeTab(tabs[i].firstChild);
	}
	setActiveTab(initialTab ? initialTab : tabs[0].firstChild);
}

function initializeTab (tab) {
	tab.onclick = function() {
		displayTab(tab);
		return false;
	};
	tab.onmousedown = tab.onselectstart = function () {
		return false;
	};
	tab.removeAttribute('href');
}

function displayTab (tab) {
	if (tab == activeTab) return;
	setActiveTab(tab);
}

function setActiveTab (tab) {
	activeTab = tab;
	for (var i = 0; i < tabs.length; i++) {
		var tab = tabs[i].firstChild;
		var active = (tab == activeTab);
		var className = active ? 'active-tab' : '';
		tab.className = className;
		document.getElementById(tab.id.substring(4)).style.display = (active ? '' : 'none');
	}
}