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
# remove_expired_sessions.pl                                                  #
# Preliminary Chirpy::UI::WebApp::Session session database cleanup script     #
###############################################################################

use strict;
use warnings;
use CGI;
use CGI::Carp qw(fatalsToBrowser);

BEGIN {
	unshift @INC, 'src/modules';
}

use Chirpy 0.2;

my $cgi = new CGI();
print $cgi->header(-type => 'text/plain; charset=US-ASCII');

my $chirpy = new Chirpy();

my $dm = $chirpy->_data_manager();

if (UNIVERSAL::isa('Chirpy::UI::WebApp::Session::DataManager', $dm)) {
	print 'Not a Chirpy::UI::WebApp::Session::DataManager. Aborting.', $/;
}
else {
	my @removed = $dm->remove_expired_sessions();
	print (@removed
		? 'The following expired sessions were removed from the database:'
			. $/ x 2 . join($/, map { '- ' . $_ } @removed)
		: 'None of the sessions in the database have expired.');
}

###############################################################################