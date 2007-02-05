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

Chirpy::NewsItem - Represents a news item

=head1 SYNOPSIS

 $item = new Chirpy::NewsItem($id, $body, $poster, $date);

 $id = $item->get_id();
 $item->set_id($id);

 $body = $item->get_body();
 $item->set_body($body);

 $poster = $item->get_poster();
 $item->set_poster($poster);

 $date = $item->get_date();
 $item->set_date($date);

=head1 CONSTRAINTS

=over 4

=item ID

The news item ID must be a positive non-zero integer.

=item Body

The news item body can be any text string.

=item Poster

The poster of the news item must be an instance of L<Chirpy::Account>, if any.

=item Date

The date when the news item was posted must be a UNIX timestamp.

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

package Chirpy::NewsItem;

use strict;
use warnings;

use vars qw($VERSION);

$VERSION = '';

use Chirpy;

sub new {
	my ($class, $id, $body, $poster, $date) = @_;
	my $self = {
		'id' => $id,
		'body' => $body,
		'poster' => $poster,
		'date' => $date
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

sub get_body {
	my $self = shift;
	return $self->{'body'};
}

sub set_body {
	my $self = shift;
	return ($self->{'body'} = shift);
}

sub get_poster {
	my $self = shift;
	return $self->{'poster'};
}

sub set_poster {
	my $self = shift;
	return ($self->{'poster'} = shift);
}

sub get_date {
	my $self = shift;
	return $self->{'date'};
}

sub set_date {
	my $self = shift;
	return ($self->{'date'} = shift);
}

1;

###############################################################################