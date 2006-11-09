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
# $Id::                                                                     $ #
###############################################################################

=head1 NAME

Chirpy::Event - Represents a log event

=head1 SYNOPSIS

 $event = new Chirpy::Event($id, $date, $code, $user, $data);

 $id = $event->get_id();
 $event->set_id($id);

 $date = $event->get_date();
 $event->set_date($date);

 $code = $event->get_code();
 $event->set_code($code);

 $user = $event->get_user();
 $event->set_user($user);

 $data = $event->get_data();
 $event->set_data($data);
 
 $event_code = Chirpy::Event::translate_code($code);

=head1 CONSTRAINTS

=over 4

=item ID

The event ID must be a positive non-zero integer.

=item Date

The event date must be a UNIX timestamp.

=item Code

The event code must be one of the event code constants described below.

=item User

The user who was logged in at the time of the event must be an instance of
L<Chirpy::Account>, if any.

=item Data

The event data must be a reference to a hash containing information about the
event.

=back

=head1 EVENT CODE CONSTANTS

 Chirpy::Event::LOGIN_SUCCESS
 Chirpy::Event::LOGIN_FAILURE
 Chirpy::Event::CHANGE_PASSWORD

 Chirpy::Event::ADD_QUOTE
 Chirpy::Event::EDIT_QUOTE
 Chirpy::Event::REMOVE_QUOTE
 Chirpy::Event::QUOTE_RATING_UP
 Chirpy::Event::QUOTE_RATING_DOWN
 Chirpy::Event::REPORT_QUOTE
 Chirpy::Event::APPROVE_QUOTE
 Chirpy::Event::UNFLAG_QUOTE

 Chirpy::Event::ADD_NEWS
 Chirpy::Event::EDIT_NEWS
 Chirpy::Event::REMOVE_NEWS

 Chirpy::Event::ADD_ACCOUNT
 Chirpy::Event::EDIT_ACCOUNT
 Chirpy::Event::REMOVE_ACCOUNT

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

package Chirpy::Event;

use strict;
use warnings;

use constant LOGIN_SUCCESS     => 100;
use constant LOGIN_FAILURE     => 101;
use constant CHANGE_PASSWORD   => 102;

use constant ADD_QUOTE         => 200;
use constant EDIT_QUOTE        => 201;
use constant REMOVE_QUOTE      => 202;
use constant QUOTE_RATING_UP   => 203;
use constant QUOTE_RATING_DOWN => 204;
use constant REPORT_QUOTE      => 205;
use constant APPROVE_QUOTE     => 206;
use constant UNFLAG_QUOTE      => 207;

use constant ADD_NEWS          => 300;
use constant EDIT_NEWS         => 301;
use constant REMOVE_NEWS       => 302;

use constant ADD_ACCOUNT       => 400;
use constant EDIT_ACCOUNT      => 401;
use constant REMOVE_ACCOUNT    => 402;

use vars qw($VERSION $CODES);

$VERSION = '';

# TODO: Find a way to automate this.
$CODES = {
	LOGIN_SUCCESS() => 'LOGIN_SUCCESS',
	LOGIN_FAILURE() => 'LOGIN_FAILURE',
	CHANGE_PASSWORD() => 'CHANGE_PASSWORD',
	ADD_QUOTE() => 'ADD_QUOTE',
	EDIT_QUOTE() => 'EDIT_QUOTE',
	REMOVE_QUOTE() => 'REMOVE_QUOTE',
	QUOTE_RATING_UP() => 'QUOTE_RATING_UP',
	QUOTE_RATING_DOWN() => 'QUOTE_RATING_DOWN',
	REPORT_QUOTE() => 'REPORT_QUOTE',
	APPROVE_QUOTE() => 'APPROVE_QUOTE',
	UNFLAG_QUOTE() => 'UNFLAG_QUOTE',
	ADD_NEWS() => 'ADD_NEWS',
	EDIT_NEWS() => 'EDIT_NEWS',
	REMOVE_NEWS() => 'REMOVE_NEWS',
	ADD_ACCOUNT() => 'ADD_ACCOUNT',
	EDIT_ACCOUNT() => 'EDIT_ACCOUNT',
	REMOVE_ACCOUNT() => 'REMOVE_ACCOUNT'
};

use Chirpy;

sub new {
	my ($class, $id, $date, $code, $user, $data) = @_;
	my $self = {
		'id' => $id,
		'date' => $date,
		'code' => $code,
		'user' => $user,
		'data' => $data
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

sub get_date {
	my $self = shift;
	return $self->{'date'};
}

sub set_date {
	my $self = shift;
	return ($self->{'date'} = shift);
}

sub get_code {
	my $self = shift;
	return $self->{'code'};
}

sub set_code {
	my $self = shift;
	return ($self->{'code'} = shift);
}

sub get_user {
	my $self = shift;
	return $self->{'user'};
}

sub set_user {
	my $self = shift;
	return ($self->{'user'} = shift);
}

sub get_data {
	my $self = shift;
	return $self->{'data'};
}

sub set_data {
	my $self = shift;
	return ($self->{'data'} = shift);
}

sub translate_code {
	my $code = shift;
	return $CODES->{$code};
}

1;

###############################################################################