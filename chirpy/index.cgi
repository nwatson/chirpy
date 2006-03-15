#!/usr/bin/perl

###############################################################################
# Chirpy! v0.2, a quote management system                                     #
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
# index.cgi                                                                   #
# Initialization script                                                       #
###############################################################################

use strict;
use warnings;
use CGI::Carp qw(fatalsToBrowser set_message);

BEGIN {
	unshift @INC, 'src/modules';
	set_message(sub {
		my $msg = shift;
		print '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN"', $/,
			'"http://www.w3.org/TR/html4/strict.dtd">', $/,
			'<html>', $/,
			'<head>', $/,
			'<meta http-equiv="Content-Type"', $/,
			'content="text/html; charset=UTF-8">', $/,
			'<title>An Error Occurred</title>', $/,
			'</head>', $/,
			'<body>', $/,
			'<h1>An Error Occurred</h1>', $/,
			'<blockquote><pre>', $msg, '</pre></blockquote>', $/,
			'<p><em>Powered by <a', $/,
			'href="http://chirpy.sourceforge.net/">Chirpy!</a></em></p>', $/,
			'</body>', $/,
			'</html>';
		exit;
	});
}

use Chirpy 0.2;

chirpy;

###############################################################################