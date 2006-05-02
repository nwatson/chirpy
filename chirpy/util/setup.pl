#!/usr/bin/perl

###############################################################################
# Chirpy! v0.3, a quote management system                                     #
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
# Generic installation/upgrade script                                         #
###############################################################################

use strict;
use warnings;
use CGI;
use CGI::Carp qw(fatalsToBrowser);

BEGIN {
	unshift @INC, 'src/modules';
}

use Chirpy 0.3;
use Chirpy::Util 0.3;
use Chirpy::Account 0.3;
use Chirpy::NewsItem 0.3;

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
	
	my $fresh = $cgi->param('fresh');

	if ($fresh) {
		&_log('Removing old installation (if any) ...');
		$ch->remove();
		&_log('Setting up ' . Chirpy::FULL_PRODUCT_NAME . ' ...');
		my $account = new Chirpy::Account(
			undef,
			DEFAULT_USERNAME,
			Chirpy::Util::encrypt(DEFAULT_PASSWORD),
			Chirpy::Account::USER_LEVEL_9
		);
		my $news = new Chirpy::NewsItem(
			undef,
			DEFAULT_NEWS_ITEM,
			$account,
			time
		);
		$ch->set_up([ $account ], [ $news ]);
		&_log('Account "' . DEFAULT_USERNAME . '" and news item added.');
		&_log('Setup completed!');
	}
	else {
		&_log('Upgrading to ' . Chirpy::FULL_PRODUCT_NAME . ' ...');
		$ch->set_up();
		&_log('Upgrade successful!');
	}

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
		'<p>Now, please tell us if this is a fresh installation, or you ',
		'are upgrading an existing installation.</p>', $/,
		'<form method="POST" action="', $cgi->script_name(), '"><div>', $/,
		'<input type="submit" name="fresh" ',
		'value="FRESH INSTALLATION" ',
		'onclick="return confirm(&quot;This will DELETE all existing data. ',
		'Are you sure?&quot;);">', $/,
		'<input type="submit" name="upgrade" ',
		'value="UPGRADE (a.k.a. Keep My Stuff!)">', $/,
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