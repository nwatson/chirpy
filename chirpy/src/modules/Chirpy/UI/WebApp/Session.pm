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

Chirpy::UI::WebApp::Session - Basic CGI session class

=head1 AUTHOR

Tim De Pauw E<lt>ceetee@users.sourceforge.netE<gt>

=head1 SEE ALSO

L<Chirpy::UI::WebApp::Session::DataManager>, L<Chirpy>,
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

package Chirpy::UI::WebApp::Session;

use strict;
use warnings;

use vars qw($VERSION $NAME);

$VERSION = '';
$NAME = 'sid';

use Chirpy;

sub new {
	my ($class, $parent, $create) = @_;
	
	$create = 0 unless (defined $create);
	
	my $dm = $parent->parent()->_data_manager();
	my $class_name = 'Chirpy::UI::WebApp::Session::DataManager';
	Chirpy::die('Data manager must implement ' . $class_name)
		unless (UNIVERSAL::isa($dm, $class_name));

	$dm->remove_expired_sessions_if_necessary();

	my $self = {
		'dm' => $dm,
		'data' => undef,
		'ro' => 0
	};
	bless $self, $class;

	my $time = time();
	my $expire = $parent->param('session_expiry');
	$expire = ($expire ? &_parse_time($expire) : 0);
	
	my $cgi = $parent->{'cgi'};
	my $ip = $cgi->remote_addr();
	if ($create) {
		my $sid = &_generate_id();
		$self->{'data'} = {
			'_SESSION_ID' => $sid,
			'_SESSION_CTIME' => $time,
			'_SESSION_ATIME' => $time,
			'_SESSION_ETIME' => $expire,
			'_SESSION_REMOTE_ADDR' => $ip
		};
		$dm->add_session($sid, $self->data());
		return $self;
	}
	else {
		my $sid = $cgi->cookie(-name => $NAME);
		if (&_valid_id($sid)) {
			my @result = $dm->get_sessions($sid);
			$self->{'data'} = $result[0] if (@result);
			if ($self->id()) {
				my $exp = $self->expire();
				if ($exp && $self->atime() + $exp < $time) {
					$self->delete();
				}
				elsif ($self->remote_addr() eq $ip) {
					return $self;
				}
			}
		}
	}
	return undef;
}

sub DESTROY {
	my $self = shift;
	unless ($self->read_only()) {
		$self->atime(time);
		$self->update();
	}
}

sub param {
	my ($self, %params) = @_;
	my $name;
	Chirpy::die('Parameter name required') unless ($name = $params{'-name'});
	if (exists $params{'-value'}) {
		$self->{'data'}->{$name} = $params{'-value'};
	}
	return $self->{'data'}->{$name};
}

sub delete {
	my $self = shift;
	my $id = $self->id();
	$self->{'dm'}->remove_sessions($self->id());
	$self->{'data'} = {};
}

sub data {
	my $self = shift;
	return $self->{'data'};
}

sub id {
	my $self = shift;
	return $self->param(-name => '_SESSION_ID');
}

sub ctime {
	my $self = shift;
	return $self->param(-name => '_SESSION_CTIME');
}

sub atime {
	my ($self, $value) = @_;
	return (defined $value
		? $self->param(-name => '_SESSION_ATIME', -value => $value)
		: $self->param(-name => '_SESSION_ATIME'));
}

sub expire {
	my ($self, $value) = @_;
	return (defined $value
		? $self->param(-name => '_SESSION_ETIME', -value => $value)
		: $self->param(-name => '_SESSION_ETIME'));
}

sub remote_addr {
	my $self = shift;
	return $self->param(-name => '_SESSION_REMOTE_ADDR');
}

sub update {
	my $self = shift;
	$self->{'dm'}->modify_session($self->id(), $self->data());
}

sub read_only {
	my ($self, $value) = @_;
	if (defined $value) {
		$self->{'ro'} = $value;
	}
	return $self->{'ro'};
}

sub _generate_id {
	require Digest::MD5;
	return Digest::MD5::md5_hex(time() . $$ . rand 9999);
}

sub _valid_id {
	my $id = shift;
	return (defined $id && $id =~ /^[0-9a-f]{32}$/);
}

sub _parse_time {
    my $time = shift;
    return $time if ($time =~ /^\d+$/);
	if ($time =~ /^([+-]?\d+)([smhdMy])$/) {
		my ($number, $unit) = ($1, $2);
		if ($unit eq 'y') {
			return $number * 365 * 24 * 60 * 60;
		}
		elsif ($unit eq 'M') {
			return $number * 30 * 24 * 60 * 60;
		}
		elsif ($unit eq 'd') {
			return $number * 24 * 60 * 60;
		}
		elsif ($unit eq 'h') {
			return $number * 60 * 60;
		}
		elsif ($unit eq 'm') {
			return $number * 60;
		}
		else {
			return $number;
		}
	}
	return 0;
}

1;

###############################################################################