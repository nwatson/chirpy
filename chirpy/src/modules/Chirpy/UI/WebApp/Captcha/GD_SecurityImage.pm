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

Chirpy::UI::WebApp::Captcha::GD_SecurityImage - Captcha provider interface
using L<GD::SecurityImage>

=head1 CONFIGURATION

The following parameters from your configuration file affect the behavior of
this module. Please see L<GD::SecurityImage's documentation|GD::SecurityImage>
for a detailed explanation. Setting a value is optional for every parameter.

=over 4

=item webapp.gd_securityimage_width

=item webapp.gd_securityimage_height

=item webapp.gd_securityimage_ptsize

=item webapp.gd_securityimage_lines

=item webapp.gd_securityimage_font

=item webapp.gd_securityimage_gd_font

=item webapp.gd_securityimage_bgcolor

=item webapp.gd_securityimage_send_ctobg

=item webapp.gd_securityimage_frame

=item webapp.gd_securityimage_scramble

=item webapp.gd_securityimage_angle

=item webapp.gd_securityimage_thickness

=item webapp.gd_securityimage_rndmax

=item webapp.gd_securityimage_rnd_data

=item webapp.gd_securityimage_method

=item webapp.gd_securityimage_style

=item webapp.gd_securityimage_text_color

=item webapp.gd_securityimage_line_color

=item webapp.gd_securityimage_particle_density

=item webapp.gd_securityimage_particle_maxdots

=back

The value for C<rnd_data> should simply be a sequence of characters to use.
Colors can only be passed as their hex values.

=head1 NOTES

This implementation is preliminary. You might have to set quite a few parameters
to get it in a usable state.

If you have previously used C<Authen_Captcha> as a captcha provider, this module
should adapt its stored captcha information flawlessly. Therefore,
theoretically, you can switch back and forth between the two without any major
problems. 

=head1 AUTHOR

Tim De Pauw E<lt>ceetee@users.sourceforge.netE<gt>

=head1 SEE ALSO

L<Chirpy::UI::WebApp::Captcha>, L<Chirpy>, L<http://chirpy.sourceforge.net/>

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

package Chirpy::UI::WebApp::Captcha::GD_SecurityImage;

use strict;
use warnings;

use vars qw($VERSION @ISA);

$VERSION = '';
@ISA = qw(Chirpy::UI::WebApp::Captcha);

use Chirpy;
use Chirpy::UI::WebApp::Captcha;
use GD::SecurityImage;
use Digest::MD5 qw(md5_hex);

sub new {
	my $class = shift;
	my $self = $class->SUPER::new(@_);
	my @params = qw(width height ptsize lines font gd_font bgcolor send_ctobg
		frame scramble angle thickness);
	my %config = ();
	foreach my $param (@params) {
		my $value = $self->param('gd_securityimage_' . $param);
		$config{$param} = $value if (defined $value);
	}
	my $rnd_data = $self->param('gd_securityimage_rnd_data');
	if (defined $rnd_data) {
		$config{'rnd_data'} = [ split(//, $rnd_data) ];
	}
	$self->{'gdsi'} = new GD::SecurityImage(%config);
	return $self;
}

sub create {
	my ($self, $expire) = @_;
	my $gdsi = $self->{'gdsi'};
	my $method = $self->param('gd_securityimage_method');
	my $style = $self->param('gd_securityimage_style');
	my $text_color = $self->param('gd_securityimage_text_color');
	my $line_color = $self->param('gd_securityimage_line_color');
	my $density = $self->param('gd_securityimage_particle_density');
	my $maxdots = $self->param('gd_securityimage_particle_maxdots');
	my ($image, $type, $rnd) = $gdsi->random()
		->create($method, $style, $text_color, $line_color)
		->particle($density, $maxdots)
		->out('force' => 'png', 'compress' => 1);
	my $hash = md5_hex($rnd);
	my $path = $self->_img_path($hash);
	my $url = $self->_img_url($hash);
	local *FILE;
	open(FILE, '>', $path)
		or Chirpy::die('Failed to open "' . $path . '" for writing: ' . $!);
	binmode FILE;
	print FILE $image;
	close FILE;
	my $list = $self->_list_file();
	local *LIST;
	open(LIST, '>>', $list)
		or Chirpy::die('Failed to open "' . $list . '" for writing: ' . $!);
	print LIST $expire, '::', $hash, $/;
	close(LIST);
	return ($hash, $url,
		$self->param('gd_securityimage_width'),
		$self->param('gd_securityimage_height'));
}

sub verify {
	my ($self, $code) = @_;
	my $hash = $self->hash();
	return 0 unless (defined $hash);
	my $list_file = $self->_list_file();
	my @data;
	my $now = time();
	my $update = 0;
	my $ok = 0;
	return 0 unless (-f $list_file);
	local *LIST;
	open(LIST, '<', $list_file)
		or Chirpy::die('Failed to read from "' . $list_file . '": ' . $!);
	while (<LIST>) {
		chomp;
		my ($exp, $h) = split /::/;
		if ($exp < $now) {
			$update = 1;
		}
		elsif ($h eq $hash) {
			$ok = ($hash eq md5_hex($code));
			unlink $self->_img_path($hash);
		}
		else {
			push @data, $_;
		}
	}
	close(LIST);
	if ($update) {
		open(LIST, '>', $list_file)
			or Chirpy::die('Failed to open "' . $list_file
				. '" for writing: ' . $!);
		foreach my $line (@data) {
			print LIST $line, $/;
		}
		close LIST;
	}
	return $ok;
}

sub _list_file {
	my $self = shift;
	return $self->data_path() . '/codes.txt';
}

sub _img_path {
	my ($self, $hash) = @_;
	return $self->base_path() . '/' . $hash . '.png';
}

sub _img_url {
	my ($self, $hash) = @_;
	return $self->base_url() . '/' . $hash . '.png';
}

1;

###############################################################################