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

=head1 NAME

Chirpy::Account - Represents a user account

=head1 SYNOPSIS

 $account = new Chirpy::Account($id, $username, $password, $level);

 $id = $account->get_id();
 $account->set_id($id);

 $username = $account->get_username($username);
 $account->set_username($username);

 $password = $account->get_password();
 $account->set_password($password);

 $level = $account->get_level();
 $account->set_level($level);

=head1 CONSTRAINTS

=over 4

=item ID

The account ID must be a positive non-zero integer.

=item Username

The username must be valid against the C<valid_username()> function of
L<Chirpy::Util>.

=item Password

Encryption is done I<before> invoking the constructor or the C<set_password()>
function. The C<get_password()> function returns the I<encrypted> password.
The password must be valid against the C<valid_password()> function and
encrypted using the C<encrypt()> function, both part of L<Chirpy::Util>.

=item User Level

The user level must be one of the user level constants described below.

=back

=head1 USER LEVEL CONSTANTS

The following constants are recommended for use as user levels:

 Chirpy::Account::USER_LEVEL_3
 Chirpy::Account::USER_LEVEL_6
 Chirpy::Account::USER_LEVEL_9

Note that the value of these is the integer representing the user level and
that the constants are only for the sake of code readability.

=head1 AUTHOR

Tim De Pauw E<lt>ceetee@users.sourceforge.netE<gt>

=head1 SEE ALSO

L<Chirpy>, L<http://chirpy.sourceforge.net/>

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

package Chirpy::Account;

use strict;
use warnings;

use constant USER_LEVEL_3 => 3;
use constant USER_LEVEL_6 => 6;
use constant USER_LEVEL_9 => 9;

use vars qw($VERSION);

$VERSION = '0.3';

use Chirpy 0.3;

sub new {
	my ($class, $id, $username, $password, $level) = @_;
	my $self = {
		'id' => $id,
		'username' => $username,
		'password' => $password,
		'level' => $level
	};
	return bless($self, $class);
}

sub get_id {
	my $self = shift;
	return $self->{'id'};
}

sub set_id {
	my $self = shift;
	return ($self->{'id'} = shift);
}

sub get_username {
	my $self = shift;
	return $self->{'username'};
}

sub set_username {
	my $self = shift;
	return ($self->{'username'} = shift);
}

sub get_password {
	my $self = shift;
	return $self->{'password'};
}

sub set_password {
	my $self = shift;
	return ($self->{'password'} = shift);
}

sub get_level {
	my $self = shift;
	return $self->{'level'};
}

sub set_level {
	my $self = shift;
	return ($self->{'level'} = shift);
}

1;

###############################################################################