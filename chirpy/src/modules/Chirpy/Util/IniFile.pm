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

=head1 NAME

Chirpy::Util::IniFile - Load from and save to an INI file

=head1 SYNOPSIS

 $inifile = new Chirpy::Util::IniFile('/path/to/inifile.ini');

 $value = $inifile->get($section, $name);

 $inifile->set($section, $name, $value);
 
 undef $inifile;

=head1 NOTE

The C<undef $inifile;> in the above example is not necessary to trigger an
update of the file's contents. The file is updated as soon as the object goes
out of scope (but only if the C<set()> function has been called).

=head1 AUTHOR

Tim De Pauw E<lt>ceetee@users.sourceforge.netE<gt>

=head1 SEE ALSO

L<Chirpy::Configuration>, L<Chirpy::Locale>, L<Chirpy>,
L<http://chirpy.sourceforge.net/>

=head1 COPYRIGHT

Copyright 2005-2006 Tim De Pauw. All rights reserved.

This program is free software; you can redistribute it and/or modify it under
the terms of the GNU General Public License as published by the Free Software
Foundation; either version 2 of the License, or (at your option) any later
version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY
WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
PARTICULAR PURPOSE.  See the GNU General Public License for more details.

=cut

package Chirpy::Util::IniFile;

use strict;
use warnings;

use vars qw($VERSION);

$VERSION = '';

use Chirpy;

sub new {
	my ($class, $file, $create) = @_;
	my $self = {
		'contents' => {},
		'filename' => $file
	};
	if (!defined $file) {
		Chirpy::die('No filename specified');
	}
	if ($create) {
		$self->{'modified'} = 1;
	}
	elsif (!-f $file) {
		Chirpy::die('File "' . $file . '" does not exist');
	}
	local *FILE;
	open(FILE, '<:utf8', $file)
		or Chirpy::die('Failed to read from ' . $file . ': ' . $!);
	my $section;
	while (<FILE>) {
		chomp;
		next if (/^;/);
		if (/^\s*\[([^\]]+)\]\s*$/) {
			$section = $1;
		}
		elsif (defined($section) && /^([^=]+)=(.*)/) {
			$self->{'contents'}{$section}{$1} = $2;
		}
	}
	close FILE;
	return bless($self, $class);
}

sub DESTROY {
	my $self = shift;
	return unless ($self->{'modified'});
	local *FILE;
	open(FILE, '>:utf8', $self->{'filename'})
		or Chirpy::die('Failed to write to ' . $self->{'filename'}
			. ': ' . $!);
	print FILE '; Automatically generated by ', __PACKAGE__, $/,
		'; ', (my $str = gmtime()), $/;
	foreach my $section (sort { lc($a) cmp lc($b) }
		keys %{$self->{'contents'}}) {
			print FILE $/, '[', $section, ']', $/;
			foreach my $name (sort { lc($a) cmp lc($b) }
				keys %{$self->{'contents'}{$section}}) {
					print FILE $name, '=',
						$self->{'contents'}{$section}{$name}, $/;
			}
	}
	close FILE;
}

sub get {
	my ($self, $section, $name) = @_;
	return (defined $name
		? $self->{'contents'}{$section}{$name}
		: $self->{'contents'}{$section});
}

sub set {
	my ($self, $section, $name, $value) = @_;
	$self->{'contents'}{$section} = {}
		if (!exists($self->{'contents'}{$section}));
	$self->{'contents'}{$section}{$name} = $value;
	$self->{'modified'} = 1;
}

1;

###############################################################################