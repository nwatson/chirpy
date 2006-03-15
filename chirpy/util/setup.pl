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
# setup.pl                                                                    #
# Generic installation script                                                 #
###############################################################################

use strict;
use warnings;
use CGI;
use CGI::Carp qw(fatalsToBrowser);

BEGIN {
	unshift @INC, 'src/modules';
}

use Chirpy 0.2;
use Chirpy::Util 0.2;
use Chirpy::Account 0.2;
use Chirpy::NewsItem 0.2;

use constant DEFAULT_USERNAME => 'superuser';
use constant DEFAULT_PASSWORD => 'password';
use constant DEFAULT_NEWS_ITEM => 'Welcome to this brand new '
	. Chirpy::FULL_PRODUCT_NAME . ' installation! For more about '
	. Chirpy::PRODUCT_NAME . ', be sure to visit the project homepage, '
	. 'located at <' . Chirpy::URL . '>!';

my $ch = new Chirpy();
my $cgi = new CGI();

print $cgi->header(-type => 'text/html; charset=US-ASCII');

&_header();

if ($cgi->request_method() eq 'POST') {
	print '<pre>';

	if ($cgi->param('remove')) {
		&_log('Removing existing data (as requested) …');
		$ch->remove();
	}

	&_log('Setting up …');
	my $account = new Chirpy::Account(
		undef,
		DEFAULT_USERNAME,
		Chirpy::Util::encrypt(DEFAULT_PASSWORD),
		Chirpy::Account::USER_LEVEL_9
	);
	$ch->set_up(
		[
			$account
		],
		[
			new Chirpy::NewsItem(
				undef,
				DEFAULT_NEWS_ITEM,
				$account,
				time
			)
		]
	);

	&_log('Account "' . DEFAULT_USERNAME . '" and default news item added.');

	&_log('Setup completed!');

	print '</pre>', $/,
		'<p><strong>Finally, you <em>must remove this file</em> (<code>',
		$0, '</code>) on the ',
		'server immediately. Failing to do so will introduce a substantial ',
		'<em>security hazard</em>.</strong></p>', $/,
		'<p>Once you have completed the final step, you may click on the ',
		'button below to surf to your new ', Chirpy::PRODUCT_NAME, ' ',
		'installation.</p>', $/,
		'<form method="get" action="./"><div>', $/,
		'<input type="submit" value="Click here to launch ',
		Chirpy::PRODUCT_NAME, '">', $/, '</div></form>';
}
else {
	print '<p>Welcome to the ', Chirpy::FULL_PRODUCT_NAME, ' setup ',
		'script.</p>', $/,
		'<p><strong>Please make sure that all the necessary files are ',
		'present and that you have edited <code>chirpy.ini</code> ',
		'to match your configuration. Otherwise, the setup process ',
		'<em>will</em> fail.</strong></p>', $/,
		'<p>Now, please decide if you want to remove any existing data ',
		'from a previous installation. Note that if you are ',
		'<strong>upgrading</strong>, you do <strong>not</strong> need to ',
		'use this script at all.</p>', $/,
		'<form method="POST" action="', $cgi->script_name(), '"><div>', $/,
		'<input type="submit" name="keep" ',
		'value="KEEP Existing Data &amp; Set Up">', $/,
		'<input type="submit" name="remove" ',
		'value="REMOVE Existing Data &amp; Set Up">', $/,
		'</div></form>';
}

&_footer();

sub _header {
	print '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN"', $/,
		'"http://www.w3.org/TR/html4/strict.dtd">', $/,
		'<html>', $/,
		'<head>', $/,
		'<meta http-equiv="Content-Type"', $/,
		'content="text/html; charset=UTF-8">', $/,
		'<title>', Chirpy::FULL_PRODUCT_NAME, ' Setup</title>', $/,
		'</head>', $/,
		'<body>', $/,
		'<h1>', Chirpy::FULL_PRODUCT_NAME, ' Setup</h1>', $/;
}

sub _footer {
	print '</body>', $/, '</html>';
}

sub _log {
	my $message = shift;
	print $message, $/;
}

###############################################################################