###############################################################################
# Chirpy!, a quote management system                                          #
# Copyright (C) 2005-2007 Tim De Pauw <ceetee@users.sourceforge.net>          #
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
# $Id::                                                                     $ #
###############################################################################

=head1 NAME

Chirpy::Util - Static utility class

=head1 FUNCTIONS

=over 4

=item valid_username($username)

Returns whether or not the given username is valid. A username is valid if it
is minimally 2, maximally 32 characters long. The characters can be letters,
numbers, underscores or dashes.

=item valid_password($password)

Returns whether or not the given password is valid. A password is valid if it
is minimally 4, maximally 256 characters long. The characters can be letters,
numbers, underscores or dashes.

=item clean_up_submission($string)

Performs various cleanup operations on the given string, which is assumed to be
filled in by the user somewhere. The operations include removal of leading and
trailing whitespaces, and trimming down sequences of more than 2 line feeds.

=item parse_tags($tags)

Parses the string C<$tags> into an array of valid tags and returns a reference
to it. The array may be empty.

=item encrypt($string, $salt)

Encrypts the given string using the MD5 algorithm, optionally using the given
salt string for added security. This function is used for password encryption.

=item format_quote_rating($rating)

Returns a string representation of the given rating, i.e. the number prepended
with the Unicode representation of its sign.

=item format_date_time($timestamp, $format, $gmt)

Formats C<$timestamp> using L<the POSIX module|POSIX>'s C<strftime()> function
and C<$format> as the format. Returns Greenwich Mean Time if C<$gmt> is true.

=item encode_xml_entities($string)

Returns C<$string> with the character entities defined in XML encoded. The
entities and their respective codes are:
 
 Character Entity
 ========= ======
     &     &amp;
     "     &quot;
     <     &lt;
     >     &gt;

=item decode_utf8($string)

Returns the given string with UTF-8 characters decoded.

=back

=head1 PROCEDURES

=over 4

=item ensure_writable_directory($path)

Attempts to make the directory specified by C<$path> writable, creating it if it
does not exist. If, upon completion, C<$path> does represent a writable
directory, execution is aborted.

=item abstract_method()

Aborts execution immediately, stating that the method is abstract and must be
implemented. Hence, if you have an abstract method C<my_abstract_method()>, you
may define it as follows:

 *my_abstract_method = \&Chirpy::Util::abstract_method;

Invoking it will then cause a fatal error unless it is overridden in the module
implementation.

=back

=head1 AUTHOR

Tim De Pauw E<lt>ceetee@users.sourceforge.netE<gt>

=head1 SEE ALSO

L<Chirpy>, L<http://chirpy.sourceforge.net/>

=head1 COPYRIGHT

Copyright 2005-2007 Tim De Pauw. All rights reserved.

This program is free software; you can redistribute it and/or modify it under
the terms of the GNU General Public License as published by the Free Software
Foundation; either version 2 of the License, or (at your option) any later
version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY
WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
PARTICULAR PURPOSE.  See the GNU General Public License for more details.

=cut

package Chirpy::Util;

use strict;
use warnings;

use vars qw($VERSION);

$VERSION = '';

use Chirpy;

use POSIX qw(strftime);

sub valid_username {
	my $string = shift;
	return ($string =~ /^[a-zA-Z0-9_\-]{2,32}$/);
}

sub valid_password {
	my $string = shift;
	return ($string =~ /^[a-zA-Z0-9_\-]{4,256}$/);
}

sub clean_up_submission {
	my $text = shift;
	for ($text) {
		s/\r\n?/\n/g;
		s/^\s+//;
		s/\s+$//;
		s/\n{3,}/\n\n/g;
		s/\t/  /g;
		# Remove low ASCII chars (\12 = \n)
		s/[\0-\11\13-\37]//g;
	}
	return $text;
}

sub parse_tags {
	my $tags = shift;
	return [] unless (defined $tags && $tags ne '');
	$tags = lc $tags;
	my %tags = ();
	foreach my $tag (split(/[\s;,]+/, $tags)) {
		next if (length($tag) < 2);
		$tags{$tag} = 1;
	}
	return [ keys %tags ];
}

sub encrypt {
	my $raw = shift;
	my $salt = shift;
	if (defined $salt) {
		$raw = $salt . "\0" . $raw;
	}
	require Digest::MD5;
	return Digest::MD5::md5_hex($raw);
}

sub format_quote_rating {
	my $rating = shift;
	return ($rating
		? ($rating < 0 ? "\x{2212}" . (-$rating) : '+' . $rating)
		: '0');
}

sub format_date_time {
	my ($timestamp, $format, $gmt) = @_;
	return strftime($format,
		($gmt ? gmtime($timestamp) : localtime($timestamp)));
}

sub encode_xml_entities {
	require HTML::Entities;
	my $str = shift;
	return HTML::Entities::encode($str, '<>&"');
}

sub decode_utf8 {
	require Encode;
	return Encode::decode('utf8', shift);
}

sub shuffle_array {
	my $array = shift;
	for (my $i = scalar(@$array) - 1; $i > 0; $i--) {
		my $j = int rand $i;
		($array->[$i], $array->[$j]) = ($array->[$j], $array->[$i]);
	}
}

sub ensure_writable_directory {
	my $path = shift;
	if (-e $path) {
		if (-d $path) {
			if (!-w $path) {
				chmod 0777, $path;
				if (!-w $path) {
					Chirpy::die('Directory "' . $path . '" not writable');
				}
			}
		}
		else {
			Chirpy::die('Path "' . $path . '" must be a directory');
		}
	}
	else {
		mkdir $path
			or die('Cannot create directory "' . $path . '": ' . $!);
	}
}

sub abstract_method {
	Chirpy::die('Abstract method must be implemented');
}

1;

###############################################################################