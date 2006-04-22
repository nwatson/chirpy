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

=head1 NAME

Chirpy::Configuration - Represents a configuration

=head1 SYNOPSIS

 $configuration = new Chirpy::Configuration('/path/to/chirpy.ini');

 $value = $configuration->get($section, $name);

 $hash_ref = $configuration->get_parameter_hash($section);

=head1 AUTHOR

Tim De Pauw E<lt>ceetee@users.sourceforge.netE<gt>

=head1 SEE ALSO

L<Chirpy::Util::IniFile>, L<Chirpy>,
L<http://chirpy.sourceforge.net/>

=head1 COPYRIGHT

Copyright 2005 Tim De Pauw. All rights reserved.

This program is free software; you can redistribute it and/or modify it under
the terms of the GNU General Public License as published by the Free Software
Foundation; either version 2 of the License, or (at your option) any later
version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY
WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
PARTICULAR PURPOSE.  See the GNU General Public License for more details.

=cut

package Chirpy::Configuration;

use strict;
use warnings;

use vars qw($VERSION @ISA);

$VERSION = '0.2';
@ISA = qw(Chirpy::Util::IniFile);

use Chirpy::Util::IniFile 0.2;

sub new {
	my ($class, $file) = @_;
	return $class->SUPER::new($file || 'chirpy.ini');
}

sub get_parameter_hash {
	my ($self, $level1, $level2) = @_;
	my $level1_hash = $self->get($level1);
	return undef unless ($level1_hash);
	my %hash = ();
	my $e = quotemeta lc $level2;
	while (my ($key, $value) = each %$level1_hash) {
		next unless ($key =~ s/^$e\.//);
		$hash{$key} = $value;
	}
	return \%hash;
}

1;

###############################################################################