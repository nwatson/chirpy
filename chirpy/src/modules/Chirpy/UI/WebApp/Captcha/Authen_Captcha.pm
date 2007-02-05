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

Chirpy::UI::WebApp::Captcha::Authen_Captcha - Captcha provider interface using
L<Authen::Captcha>

=head1 CONFIGURATION

This module uses the following parameters from your configuration file:

=item webapp.authen_captcha_source_image_path

The physical path to the source images to be used by L<Authen::Captcha>.

=item webapp.authen_captcha_character_width

The pixel width of each character in a captcha image.

=item webapp.authen_captcha_character_height

The pixel height of each character in a captcha image.

=item webapp.authen_captcha_code_length

The number of characters in the captcha code.

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

package Chirpy::UI::WebApp::Captcha::Authen_Captcha;

use strict;
use warnings;

use vars qw($VERSION @ISA);

$VERSION = '';
@ISA = qw(Chirpy::UI::WebApp::Captcha);

use Chirpy;
use Chirpy::UI::WebApp::Captcha;
use Authen::Captcha;

sub new {
	my $class = shift;
	my $self = $class->SUPER::new(@_);
	$self->{'ac'} = new Authen::Captcha(
		'data_folder' => $self->data_path(),
		'output_folder' => $self->base_path()
	);
	return $self;
}

sub create {
	my ($self, $expire) = @_;
	my $ac = $self->{'ac'};
	$ac->expire($expire);
	my $length = $self->param('authen_captcha_code_length') || 4;
	my $imgpath = $self->param('authen_captcha_source_image_path');
	my $width = $self->param('authen_captcha_character_width');
	my $height = $self->param('authen_captcha_character_height');
	my $set_dimensions = ($width && $height);
	unless ($set_dimensions) {
		$width = 25;
		$height = 35;
	}
	if ($imgpath && -d $imgpath) {
		$ac->images_folder($imgpath);
		if ($set_dimensions) {
			$ac->width($width);
			$ac->height($height);
		}
	}
	my $hash = $ac->generate_code($length);
	my $imgurl = $self->base_url() . '/' . $hash . '.png';
	return ($hash, $imgurl, $length * $width, $height);
}

sub verify {
	my ($self, $code) = @_;
	return ($self->{'ac'}->check_code($code, $self->hash()) == 1);
}

1;

###############################################################################