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

Chirpy::Quote - Represents a quote

=head1 SYNOPSIS

 $quote = new Chirpy::Quote(
     $id, $body, $notes, $rating, $vote_count,
     $submitted, $approved, $flagged, $tags);

 $id = $quote->get_id();
 $quote->set_id($id);

 $body = $quote->get_body();
 $quote->set_body($body);

 $notes = $quote->get_notes();
 $quote->set_notes($notes);

 $rating = $quote->get_rating();
 $quote->set_rating($rating);
 
 $vote_count = $quote->get_vote_count();
 $quote->set_vote_count($vote_count);

 $submitted = $quote->get_date_submitted();
 $quote->set_date_submitted($submitted);

 $approved = $quote->get_approved();
 $quote->set_approved($approved);

 $flagged = $quote->get_flagged();
 $quote->set_flagged($flagged);
 
 $tags = $quote->get_tags();
 $quote->set_tags($tags);
 $quote->add_tag($tag);
 $quote->remove_tag($tag);

=head1 CONSTRAINTS

=over 4

=item ID

The quote ID must be a positive non-zero integer.

=item Body

The quote body can be any text string.

=item Notes

The quote notes can be any text string, if any.

=item Rating

The quote rating must be an integer.

=item Vote Count

The vote count must be a positive integer; a value of zero is allowed.

=item Submitted

The date when the quote was submitted must be a UNIX timestamp.

=item Approved

The quote approval status is 1 if the quote has been approved, 0 if it has not.

=item Flagged

The quote flag status is 1 if the quote has been reported, 0 if it has not.

=item Tags

Tags must be passed as a reference to an array of strings, each of which
constructed of lowercase non-whitespace characters.

=back

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

package Chirpy::Quote;

use strict;
use warnings;

use vars qw($VERSION);

$VERSION = '';

use Chirpy;

sub new {
	my ($class, $id, $body, $notes,
		$rating, $vote_count, $submitted, $approved, $flagged, $tags) = @_;
	my $self = {
		'id' => $id,
		'body' => $body,
		'notes' => (defined $notes && $notes ne '' ? $notes : undef),
		'rating' => $rating,
		'vote_count' => $vote_count,
		'submitted' => $submitted,
		'approved' => $approved,
		'flagged' => $flagged,
		'tags' => (ref $tags eq 'ARRAY' ? [ sort @$tags ] : [])
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

sub get_notes {
	my $self = shift;
	return $self->{'notes'};
}

sub set_notes {
	my ($self, $notes) = @_;
	return ($self->{'notes'}
		= (defined $notes && $notes ne '' ? $notes : undef));
}

sub get_rating {
	my $self = shift;
	return $self->{'rating'};
}

sub set_vote_count {
	my $self = shift;
	return ($self->{'vote_count'} = shift);
}

sub get_vote_count {
	my $self = shift;
	return $self->{'vote_count'};
}

sub set_rating {
	my $self = shift;
	return ($self->{'rating'} = shift);
}

sub get_date_submitted {
	my $self = shift;
	return $self->{'submitted'};
}

sub set_date_submitted {
	my $self = shift;
	return ($self->{'submitted'} = shift);
}

sub get_approved {
	my $self = shift;
	return $self->{'approved'};
}

sub set_approved {
	my $self = shift;
	return ($self->{'approved'} = shift);
}

sub get_flagged {
	my $self = shift;
	return $self->{'flagged'};
}

sub set_flagged {
	my $self = shift;
	return ($self->{'flagged'} = shift);
}

sub get_tags {
	my $self = shift;
	return $self->{'tags'};
}

sub set_tags {
	my $self = shift;
	return ($self->{'tags'} = shift);
}

1;

###############################################################################