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

Chirpy::UpdateChecker - Update checker

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

package Chirpy::UpdateChecker;

use strict;
use warnings;

use vars qw($VERSION);

$VERSION = '';

use Chirpy;

use constant UPDATE_URL => Chirpy::URL . 'update/';
use constant TIMEOUT => 5;
use constant KEY_VERSION_NUMBER => 'VersionNumber';
use constant KEY_RELEASE_DATE => 'ReleaseDate';
use constant KEY_DETAIL_URL => 'DetailURL';

sub new {
	my ($class, $parent) = @_;
	eval 'use LWP::UserAgent';
	my ($ua, $error);
	if ($@) {
		$error = 'LWP::UserAgent not available';
	}
	else {
		$ua = new LWP::UserAgent();
		$ua->timeout(TIMEOUT);
		$ua->env_proxy();
	}
	my $self = {
		'parent' => $parent,
		'ua' => $ua,
		'error' => $error
	};
	return bless $self, $class;
}

sub check_for_updates {
	my $self = shift;
	return 1 unless ($self->{'ua'});
	my $info = $self->get_version_information();
	if (ref $info ne 'ARRAY') {
		$self->{'error'} = $info;
		return 1;
	}
	if (shift(@$info)) {
		return $info;
	}
	return 0;
}

sub get_error_message {
	my $self = shift;
	return $self->{'error'};
}

sub get_version_information {
	my $self = shift;
	my $ua = $self->{'ua'};
	my $url = $self->{'parent'}->configuration()->get('ui', 'webapp.site_url');
	if (defined $url) {
		eval 'use URI::Escape';
		$url = ($@ ? undef : URI::Escape::uri_escape($url));
	}
	$url = UPDATE_URL . '?version=' . $Chirpy::VERSION
		. (defined $url ? '&url=' . $url : '');
	my $response = $ua->get($url);
	if ($response->is_success) {
		my $xml = $response->content;
		my %info = ();
		if ($xml =~ m{
			<CurrentVersion(?:\s+newer="(.*?))?">\s*(.*?)\s*</CurrentVersion>
		}sx) {
			my ($newer, $node) = ($1, $2);
			$newer = (defined $newer && lc $newer eq 'true');
			my $pattern = join('|', map { quotemeta }
				(KEY_VERSION_NUMBER, KEY_RELEASE_DATE, KEY_DETAIL_URL));
			while ($node =~ m!<($pattern)>\s*(.*?)\s*</\1>!sg) {
				$info{$1} = $2;
			}
			$info{KEY_DETAIL_URL} =~ s/&amp;/&/g;
			return [
				$newer,
				$info{KEY_VERSION_NUMBER()},
				$info{KEY_RELEASE_DATE()},
				$info{KEY_DETAIL_URL()}
			];
		}
		return 'Unknown response from update server';
	}
	return $response->status_line;
}

1;

###############################################################################