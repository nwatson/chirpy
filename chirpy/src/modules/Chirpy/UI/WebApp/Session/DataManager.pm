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

Chirpy::UI::WebApp::Session::DataManager - Abstract data manager class specific
to L<Chirpy::UI::WebApp::Session|Chirpy::UI::WebApp::Session>

=head1 USAGE

This class is required by L<Chirpy::UI::WebApp|Chirpy::UI::WebApp>'s session
manager L<Chirpy::UI::WebApp::Session|Chirpy::UI::WebApp::Session>. It is an
abstract class representing a data manager for session information.

If you wish to create an implementation of this class, the easiest way is to
extend an existing L<Chirpy::DataManager|Chirpy::DataManager> implementation
with this class's methods.

The class also has two non-abstract object method, namely
C<remove_expired_sessions()> and C<remove_expired_sessions_if_necessary()>. The
former returns a list containing the IDs of the sessions that have expired and
have consequently been removed. The latter does the same, but only every 24
hours; otherwise, it returns C<undef>.

=head1 IMPLEMENTATION

If you want to make your L<Chirpy::DataManager|Chirpy::DataManager> compatible
with L<Chirpy::UI::WebApp::Session|Chirpy::UI::WebApp::Session>, all you need
to do is implement a few extra object methods for creating, retrieving,
updating and deleting sessions. You will probably also have to extend your
C<set_up()> and C<remove()> methods accordingly. The extra methods to implement
are as follows:

=over 4

=item add_session($id, $data)

Stores the session with ID C<$id> and session data C<$data>. C<$data> is a hash
reference, so you will probably have to serialize it. How you do that is up to
you, but L<Data::Dumper> makes it easy. Returns a true value upon success.

=item get_sessions(@ids)

Returns a list containing the data hash for each session whose ID is contained
in C<@ids>, or all sessions if C<@ids> is empty. If no sessions are found,
returns an empty list (and I<not> C<undef>).

=item modify_session($id, $data)

Updates the existing session with ID C<$id> with the data from the hash
referred to by C<$data>.

=item remove_sessions(@ids)

Removes all sessions with an ID contained in C<@ids> from the system. Returns
the number of removed sessions.

=back

=head1 AUTHOR

Tim De Pauw E<lt>ceetee@users.sourceforge.netE<gt>

=head1 SEE ALSO

L<Chirpy::UI::WebApp::Session>, L<Chirpy::DataManager::MySQL>,
L<Chirpy::DataManager>, L<Chirpy>, L<http://chirpy.sourceforge.net/>

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

package Chirpy::UI::WebApp::Session::DataManager;

use strict;
use warnings;

use vars qw($VERSION);

use constant CLEANUP_INTERVAL => 24 * 60 * 60;

$VERSION = '0.2';

use Chirpy::Util 0.2;

sub remove_expired_sessions {
	my $self = shift;
	my @sessions = $self->get_sessions();
	return () unless (@sessions);
	my @remove = ();
	my $time = time;
	foreach my $data (@sessions) {
		if (my $exp = $data->{'_SESSION_ETIME'}) {
			my $at = $data->{'_SESSION_ATIME'};
			next unless ($exp + $at < $time);
			push @remove, $data->{'_SESSION_ID'};
		}
	}
	return () unless (@remove);
	$self->remove_sessions(@remove);
	return @remove;
}

sub remove_expired_sessions_if_necessary {
	my $self = shift;
	my $now = time();
	my $last_cleanup = $self->get_parameter('last_session_cleanup');
	if (!defined $last_cleanup || $last_cleanup + CLEANUP_INTERVAL < $now) {
		$self->set_parameter('last_session_cleanup', $now);
		return $self->remove_expired_sessions();
	}
	return undef;
}

*add_session = \&Chirpy::Util::abstract_method;

*get_sessions = \&Chirpy::Util::abstract_method;

*modify_session = \&Chirpy::Util::abstract_method;

*remove_sessions = \&Chirpy::Util::abstract_method;

1;

###############################################################################