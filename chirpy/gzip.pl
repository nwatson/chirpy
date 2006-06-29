#!/usr/bin/perl

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
# gzip.pl                                                                     #
# Provides compression for certain files, relying on .htaccess directives     #
###############################################################################

use strict;
use warnings;

use CGI;
use CGI::Carp qw/fatalsToBrowser/;

use constant MODULES => [
	'HTTP::Date',
	'Digest::MD5',
	'Compress::Zlib'
];
use constant CACHE_DIR => 'src/cache/gzip';
use constant MIME_TYPES => {
	'css' => 'text/css',
	'js' => 'text/javascript'
};

my $cgi = new CGI();
my $uri = $cgi->param('uri');
my $filename = $cgi->param('filename');

foreach my $module (@{MODULES()}) {
	eval 'require ' . $module;
	&redirect()
		if ($@);
}

unless (-d CACHE_DIR) {
	mkdir CACHE_DIR, 0777
		or &redirect();
}

&redirect()
	unless ($ENV{'REDIRECT_URL'} eq $uri);

&redirect()
	unless (defined $filename && -s $filename);

my $file_date = (stat($filename))[9];

my $md5 = Digest::MD5::md5_hex($filename);
my $etag = '"' . $md5 . '-' . sprintf('%x', $file_date) . '"';

my $ims = $cgi->http('If-Modified-Since');
my $inm = $cgi->http('If-None-Match');

my $not_modified = 0;
if (defined $ims) {
	$not_modified = ($file_date <= HTTP::Date::str2time($ims));
}
if (!$not_modified && defined $inm) {
	$not_modified = ($etag eq $inm);
}
if ($not_modified) {
	print $cgi->header(-status => '304 Not Modified');
	exit;
}

my $cache_file = CACHE_DIR . '/' . $md5;
my $contents;
if (!-f $cache_file || (stat($cache_file))[9] < $file_date) {
	my $contents = &get_file_contents($filename);
	$contents = Compress::Zlib::memGzip($contents);
	&put_file_contents($cache_file, $contents);
}
else {
	$contents = &get_file_contents($cache_file);
}

my $extension;
$filename =~ /([^.]+)$/ and $extension = $1;
my $ctype = (defined $extension && exists MIME_TYPES->{$extension}
	? MIME_TYPES->{$extension} : 'text/plain');

print $cgi->header(
	-type => $ctype,
	-Last_Modified => HTTP::Date::time2str($file_date),
	-ETag => $etag,
	-Content_Encoding => 'gzip',
	-Content_Length => length($contents)
);
binmode STDOUT;
print $contents;

sub redirect {
	print $cgi->header(-Location => $uri . '?nogzip');
	exit;
}

sub get_file_contents {
	my $filename = shift;
	local $/ = undef;
	local *FILE;
	open(FILE, '<', $filename)
		or die 'Failed to read "' . $filename . '": ' . $!;
	my $contents = <FILE>;
	close(FILE);
	return $contents;
}

sub put_file_contents {
	my ($filename, $contents) = @_;
	local *FILE;
	open(FILE, '>', $filename)
		or die 'Failed to write to "' . $filename . '": ' . $!;
	print FILE $contents;
	close(FILE);
}

###############################################################################