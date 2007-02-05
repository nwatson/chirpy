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

Chirpy::UI::WebApp::Captcha - Captcha provider interface

=head1 AUTHOR

Tim De Pauw E<lt>ceetee@users.sourceforge.netE<gt>

=head1 SEE ALSO

L<Chirpy::UI::WebApp>, L<Chirpy>, L<http://chirpy.sourceforge.net/>

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

package Chirpy::UI::WebApp::Captcha;

use strict;
use warnings;

use vars qw($VERSION);

$VERSION = '';

use Chirpy;
use Chirpy::Util;

sub new {
	my ($class, $parent, $hash) = @_;
	my $self = {
		'parent' => $parent,
		'hash' => $hash
	};
	return bless($self, $class);
}

sub parent {
	my $self = shift;
	return $self->{'parent'};
}

sub hash {
	my ($self, $hash) = @_;
	$self->{'hash'} = $hash if (defined $hash);
	return $self->{'hash'};
}

sub data_path {
	my $self = shift;
	my $path = $self->parent()->configuration()->get('general', 'base_path')
		. '/cache/captcha';
	Chirpy::Util::ensure_writable_directory($path);
	return $path;
}

sub base_path {
	my $self = shift;
	my $path = $self->param('captcha_path');
	return $path if (defined $path);
	return $self->parent()->configuration()->get('general', 'base_path')
		. '/../res/captcha';
}

sub base_url {
	my $self = shift;
	my $url = $self->param('captcha_url');
	return $url if (defined $url);
	return $self->param('site_url') . '/res/captcha';
}

sub param {
	my ($self, $name) = @_;
	return $self->parent()->param($name); 
}

*create = \&Chirpy::Util::abstract_method;

*verify = \&Chirpy::Util::abstract_method;

1;

###############################################################################