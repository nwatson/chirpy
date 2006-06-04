###############################################################################
# Chirpy! v0.3, a quote management system                                     #
# Copyright (C) 2005 Tim De Pauw <ceetee@users.sourceforge.net>               #
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

Chirpy::UI::WebApp - User interface class to use Chirpy! as a Web application

=head1 REQUIREMENTS

Apart from a proper Chirpy! installation, this module requires the following
Perl modules:
 
 HTML::Template
 HTTP::Date
 URI::Escape

Optionally, for on-the-fly gzip compression, L<Compress::Zlib> is required. If
you wish to use Captchas, you will need L<Authen::Captcha>.

=head1 CONFIGURATION

This module uses the following values from your configuration file:

=over 4

=item webapp.webmaster_name

The name of the site's webmaster.

=item webapp.webmaster_email

The e-mail address of the site's webmaster.

=item webapp.site_url

The base URL of the web site, i.e. the path to F<index.cgi>, without the
trailing forward slash.

=item webapp.resources_url

The base URL of the path where resources, i.e. publicly available files used
by the output pages, are stored, again without the trailing forward slash.

=item webapp.theme

The identifier of the theme to use.

=item webapp.welcome_text_file

The name of the file that contains the welcome message to display on the home
page. Use a path name relative to the base path defined in the C<general>
section.

=item webapp.cookie_domain

=item webapp.cookie_path

When cookies are set, these two values are used to limit them to the correct
domain name and path. For example, if your QDB is located at
I<http://www.mysite.com/myname/qdb>, you would enter C<mysite.com> and
C</myname/qdb>.

=item webapp.template_cache_path

The L<HTML::Template> module uses a cache of templates to speed things up. This
cache is file-based and resides in the path specificed by this setting. Hence,
it should be the physical path to a world-writable directory, typically
F<src/cache/template>.

=item webapp.session_expiry

To keep track of users' actions, sessions are used. These are kept around for
a while if the user is inactive. This value sets how long they should be saved.
You can use a number for the expiry time in seconds, or use a number directly
followed by one of these suffixes to indicate time units:

 m: minutes
 h: hours
 d: days
 M: months
 y: years

This format was borrowed from L<CGI.pm|CGI>.

=item webapp.enable_short_urls

If you run Chirpy! on an Apache web server that has the C<mod_rewrite> module
installed, you can set this value to 1 to make URLs short, pretty and easy to
remember.

=item webapp.enable_feeds

Set this value to 1 to enable the RSS and Atom feeds the module offers.

=item webapp.enable_gzip

Apply gzip compression on output if possible.

=item webapp.enable_captchas

Use captchas to prevent spam on the quote submission interface.

=item webapp.captcha_information_path

The physical path to the directory where captcha information is to be stored.

=item webapp.captcha_image_path

The physical path to the directory where captcha images are to be stored.

=item webapp.captcha_image_url

The URL to the captcha image path.

=item webapp.captcha_code_length

The number of characters in the captcha code.

=item webapp.captcha_expiry_time

The number of seconds between the moment when the captcha image was generated
and the moment when its code expires.

=item webapp.captcha_source_image_path

The physical path to the source images to be used by L<Authen::Captcha>.

=item webapp.captcha_character_width

The pixel width of each character in a captcha image.

=item webapp.captcha_character_height

The pixel height of each character in a captcha image.

=item webapp.enable_autolink

Automatically turn hyperlinks and e-mail addresses in quotes into hyperlinks.

=back

=head1 LOCALE STRINGS

This module uses the following strings from your locale. Please make sure they
are present before using the module.

=over 4

=item webapp.start_page_description

Brief description of what the start page does, for tooltips and such.

=item webapp.start_page_short_title

Abbreviated version of I<Start Page>, e.g. I<Home>, for use in compact menus.

=item webapp.quote_link_description

Brief description of what a link to the quote is for, for tooltips and such.

=item webapp.next_page_title

Translation of I<Next Page>, for multi-page quote lists.

=item webapp.previous_page_title

Translation of I<Previous Page>, for multi-page quote lists.

=item webapp.footer_text

Text stating that the page was generated by Chirpy! and informing the user of
the number of milliseconds used to do so. C<%1%> is replaced with the Chirpy!
product name and version, linked to the Chirpy! web site, C<%2%> with the
number of milliseconds (without a unit).

=item webapp.footer_text_no_time

Text stating that the page was generated by Chirpy!. C<%1%> is replaced with
the string I<Chirpy!>, possibly with formatting.

=item webapp.manage_quote_instructions

Message explaining to the user that, if he would like to modify or remove
a quote, the links to do so are available from the quote list.

=item webapp.remove_quote_without_viewing_confirmation

Question confirming the removal of a quote by entering its ID and stressing
that this is not a recommended action.

=item webapp.manage_news_instructions

Message explaining to the user that, if he would like to modify or remove
a news item, the links to do so are available from the list of recent news
items on the start page.

=item webapp.session_required

Message explaining that the session information cookie that Chirpy! tried to
store was not accepted by the user's browser and suggesting that he try again
after reviewing his cookie settings.

=item webapp.timed_out_text

Error message explaining that the connection has timed out while attempting to
rate the quote, and asking the user to try again.

=item webapp.captcha_code_label

The label text for the field where the user fills in the captcha code.

=item webapp.captcha_image_text

The alternate text for the captcha image.

=back

=head1 AUTHOR

Tim De Pauw E<lt>ceetee@users.sourceforge.netE<gt>

=head1 SEE ALSO

L<Chirpy::UI::WebApp::Session>, L<Chirpy::UI>, L<Chirpy>,
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

package Chirpy::UI::WebApp;

use strict;
use warnings;

use vars qw($VERSION $TARGET_VERSION @ISA);

$VERSION = '0.3';
@ISA = qw(Chirpy::UI);

$TARGET_VERSION = 0.3;

use Chirpy 0.3;
use Chirpy::UI 0.3;
use Chirpy::UI::WebApp::Session 0.3;

use HTML::Template;
use CGI;

use constant ACTIONS => {
	'START_PAGE' => '',
	'QUOTE_RATING_UP' => 'up',
	'QUOTE_RATING_DOWN' => 'down',
	'REPORT_QUOTE' => 'report',
	'QUOTE_BROWSER' => 'browse',
	'RANDOM_QUOTES' => 'random',
	'TOP_QUOTES' => 'top',
	'BOTTOM_QUOTES' => 'bottom',
	'QUOTES_OF_THE_WEEK' => 'qotw',
	'QUOTE_SEARCH' => 'search',
	'TAG_CLOUD' => 'tags',
	'STATISTICS' => 'statistics',
	'SUBMIT_QUOTE' => 'submit',
	'ADMINISTRATION' => 'admin',
	'LOGIN' => 'login',
	'LOGOUT' => 'logout',
};

use constant ADMIN_ACTIONS => {
	'CHANGE_PASSWORD' => 'password',
	'MANAGE_UNAPPROVED_QUOTES' => 'quote_approve',
	'MANAGE_FLAGGED_QUOTES' => 'quote_flags',
	'EDIT_QUOTE' => 'quote_edit',
	'REMOVE_QUOTE' => 'quote_remove',
	'ADD_NEWS' => 'news_add',
	'EDIT_NEWS' => 'news_edit',
	'REMOVE_NEWS' => 'news_remove',
	'ADD_ACCOUNT' => 'accounts',
	'EDIT_ACCOUNT' => 'accounts',
	'REMOVE_ACCOUNT' => 'account'
};

use constant STATUS_OK                     => 1;
use constant STATUS_ALREADY_RATED          => 2;
use constant STATUS_RATING_LIMIT_EXCEEDED  => 3;
use constant STATUS_QUOTE_NOT_FOUND        => 4;
use constant STATUS_SESSION_REQUIRED       => 5;

sub new {
	my $class = shift;
	my $self = $class->SUPER::new(@_);
	$self->{'templates_path'}
		= $self->configuration()->get('general', 'base_path')
			. '/templates/' . $self->param('theme');
	$self->{'cgi'} = new CGI();
	$self->{'cookies'} = [];
	my $session = new Chirpy::UI::WebApp::Session($self);
	if (defined $session) {
		$self->{'session'} = $session;
		$self->_set_cookie($Chirpy::UI::WebApp::Session::NAME,
			$session->id(), $self->param('session_expiry'));
	}
	return bless($self, $class);
}

sub get_target_version {
	return $TARGET_VERSION;
}

sub get_current_page {
	my $self = shift;
	my $action = $self->_action();
	my $page;
	if (defined $action && $action) {
		while (my ($n, $v) = each %{ACTIONS()}) {
			if ($v eq $action) {
				$page = eval 'Chirpy::UI::' . $n;
				last;
			}
		}
	}
	else {
		$page = ($self->_id()
			? Chirpy::UI::SINGLE_QUOTE : Chirpy::UI::START_PAGE);
	}
	$self->_provide_session_if_necessary($page);
	# XXX: This is sort of hackish. What to do?
	if (defined $self->_feed_type()) {
		my $quotes_per_feed = $self->param('quotes_per_feed');
		$quotes_per_feed = 50
			unless (defined $quotes_per_feed && $quotes_per_feed > 0);
		$self->parent()->quotes_per_page($quotes_per_feed);
	}
	return $page;
}

sub get_selected_quote_id {
	my $self = shift;
	return $self->_id();
}

sub get_first_quote_index {
	my $self = shift;
	return $self->_cgi_param('start') || 0;
}

sub get_search_instruction {
	my $self = shift;
	my $query = $self->_cgi_param('query');
	my @queries = ();
	my @tags = ();
	while ($query =~ /"(.*?)"|(\S+)|"([^"]+)$/g) {
		my $literal = defined $1 ? $1 : $3;
		if (defined $literal) {
			push @queries, $literal;
		}
		else {
			my $word = $2;
			if ($word =~ s/^tag://i) {
				push @tags, $word;
			}
			else {
				push @queries, $word;
			}
		}
	}
	return (\@queries, \@tags);
}

sub get_submitted_quote {
	my $self = shift;
	if ($self->_requires_captcha()) {
		my $captcha = $self->_captcha();
		my $result = $captcha->check_code(
			$self->_cgi_param('captcha_code'),
			$self->_cgi_param('captcha_hash')
		);
		if ($result <= 0) {
			return undef;
		}
	}
	return ($self->_cgi_param('quote'),
		$self->_cgi_param('notes'), $self->_cgi_param('tags'));
}

sub attempting_login {
	my $self = shift;
	return $self->_is_post();
}

sub get_supplied_username_and_password {
	my $self = shift;
	return ($self->_cgi_param('username'), $self->_cgi_param('password'));
}

sub get_rating_history {
	my $self = shift;
	return undef unless (defined $self->_session());
	my $hist = $self->_session()->param(-name => 'history');
	return () unless (ref $hist eq 'ARRAY');
	return @$hist;
}

sub set_rating_history {
	my ($self, @history) = @_;
	return undef unless (defined $self->_session());
	$self->_session()->param(-name => 'history', -value => \@history);
}

sub get_rated_quotes {
	my $self = shift;
	return undef unless (defined $self->_session());
	my $list = $self->_session()->param(-name => 'rated');
	return () unless (ref $list eq 'ARRAY');
	return @$list;
}

sub set_rated_quotes {
	my ($self, @list) = @_;
	return undef unless (defined $self->_session());
	$self->_session()->param(-name => 'rated', -value => \@list);
}

sub get_logged_in_user {
	my $self = shift;
	return undef unless (defined $self->_session());
	return $self->_session()->param(-name => 'user');
}

sub set_logged_in_user {
	my ($self, $id) = @_;
	return undef unless (defined $self->_session());
	$self->_session()->param(-name => 'user', -value => $id);
}

sub report_unknown_action {
	my $self = shift;
	$self->_report_error($self->locale()->get_string('unknown_action'));
}

sub report_no_quotes_to_display {
	my ($self, $page) = @_;
	my $type = $self->_feed_type();
	if (defined $type) {
		$self->_generate_feed([], $type, $page);
	}
	else {
		$self->_report_error($self->locale()->get_string('no_quotes'));
	}
}

sub _report_message {
	my ($self, $title, $text) = @_;
	my $template = $self->_load_template('message');
	$template->param(
		'PAGE_TITLE' => &_text_to_xhtml($title),
		'MESSAGE_TEXT' => &_text_to_xhtml($text)
	);
	$self->_output_template($template);
}

sub _report_error {
	my ($self, $error) = @_;
	my $template = $self->_load_template('error');
	$template->param(
		'PAGE_TITLE' => &_text_to_xhtml(
			$self->locale()->get_string('error_title')),
		'ERROR_MESSAGE' => &_text_to_xhtml($error)
	);
	$self->_output_template($template);
}

sub welcome_user {
	my ($self, $news) = @_;
	my $template = $self->_load_template('start_page');
	my $locale = $self->locale();
	$template->param('PAGE_TITLE' => &_text_to_xhtml(
		$locale->get_string('welcome')));
	$template->param('NEWS_TITLE' => &_text_to_xhtml(
		$locale->get_string('latest_news')));
	if (defined $news) {
		my @news_tmpl = ();
		foreach my $item (@$news) {
			my $poster = $item->get_poster();
			push @news_tmpl, {
				'BODY' => $self->_format_news_body($item->get_body()),
				'AUTHOR' => defined $poster 
					? &_text_to_xhtml($poster->get_username())
					: undef,
				'DATE' => &_text_to_xhtml(
					$self->format_date_time($item->get_date())),
				'ALLOW_EDIT'
					=> $self->administration_allowed(Chirpy::UI::EDIT_NEWS),
				'ALLOW_REMOVE'
					=> $self->administration_allowed(Chirpy::UI::REMOVE_NEWS),
				'EDIT' => &_text_to_xhtml(
					$locale->get_string('edit')),
				'REMOVE' => &_text_to_xhtml(
					$locale->get_string('remove')),
				'REMOVAL_CONFIRMATION' => &_text_to_xhtml(
					$locale->get_string('news_removal_confirmation')),
				'EDIT_URL' => $self->_url(
					ADMIN_ACTIONS->{'EDIT_NEWS'},
					1,
					'id' => $item->get_id()),
				'REMOVE_URL' => $self->_url(
					ADMIN_ACTIONS->{'REMOVE_NEWS'},
					1,
					'id' => $item->get_id())
			};
		}
		$template->param('NEWS' => \@news_tmpl);
	}
	my $motd_path = $self->configuration()->get('general', 'base_path')
		. '/' . $self->param('welcome_text_file');
	# TODO: find a better way to include this
	if (-f $motd_path) {
		$template->param('MOTD' => $self->_process_template(
			new HTML::Template(
				'filename' => $motd_path,
				'die_on_bad_params' => 0,
				'global_vars' => 1,
				'file_cache' => 1,
				'file_cache_dir' => $self->param('template_cache_path'),
				'file_cache_dir_mode' => 0777
			)
		));
	}
	$self->_output_template($template);
}

sub browse_quotes {
	my ($self, $quotes, $page, $previous, $next) = @_;
	my $type = $self->_feed_type();
	if (defined $type) {
		$self->_generate_feed($quotes, $type, $page);
	}
	else {
		$self->_generate_xhtml($quotes, $page, $previous, $next);
	}
}

sub _generate_feed {
	my ($self, $quotes, $type, $page) = @_;
	my $locale = $self->locale();
	my $conf = $self->configuration();
	my $site_title = &_text_to_xhtml(
			$conf->get('general', 'title'));
	my $page_title = &_text_to_xhtml(
		$self->locale()->get_string(&_get_page_name($page)));
	my $name = &_text_to_xhtml($self->param('webmaster_name'));
	my $email = &_hide_email($self->param('webmaster_email'));
	my $template = new HTML::Template(
		'filename' => $self->{'templates_path'}
			. '/feeds/' . ($type eq 'atom' ? 'atom10' : 'rss20') . '.xml',
		'die_on_bad_params' => 0,
		'global_vars' => 1,
		'file_cache' => 1,
		'file_cache_dir' => $self->param('template_cache_path'),
		'file_cache_dir_mode' => 0777
	);
	my @quotes = ();
	my $date;
	my $auto_link = $conf->get('ui', 'webapp.enable_autolink');
	foreach my $quote (@$quotes) {
		my $id = $quote->get_id();
		my $d = $quote->get_date_submitted();
		$date = $d if (!defined($date) || $d > $date);
		my $up_url = $self->_url(ACTIONS->{'QUOTE_RATING_UP'},
			undef, 'id' => $id);
		my $down_url = $self->_url(ACTIONS->{'QUOTE_RATING_DOWN'},
			undef, 'id' => $id);
		my $report_url = $self->_url(ACTIONS->{'REPORT_QUOTE'},
			undef, 'id' => $id);
		my $body = &_text_to_xhtml($quote->get_body());
		my $notes = &_text_to_xhtml($quote->get_notes());
		my $tags = $self->_link_tags($quote);
		if ($auto_link) {
			$body = &_auto_link($body);
			$notes = &_auto_link($notes);
		}
		else {
			$body = &_spam_protect_email_addresses($body);
			$notes = &_spam_protect_email_addresses($notes);
		}
		push @quotes, {
			'QUOTE_ID' => $id,
			'QUOTE_URL' => &_text_to_xhtml($self->_quote_url($id)),
			'QUOTE_BODY' => $body,
			'QUOTE_NOTES' => $notes,
			'QUOTE_TAGS' => $tags,
			'QUOTE_NOTES_TITLE' => &_text_to_xhtml(
				$locale->get_string('quote_notes_title')),
			'QUOTE_TAGS_TITLE' => &_text_to_xhtml(
				$locale->get_string('quote_tags_title')),
			'QUOTE_RATING'
				=> Chirpy::Util::format_quote_rating($quote->get_rating()),
			'QUOTE_RATING_UP_URL' => $up_url,
			'QUOTE_RATING_DOWN_URL' => $down_url,
			'QUOTE_REPORT_URL' => $report_url,
			'QUOTE_RATING_UP_SHORT_TITLE' => &_text_to_xhtml(
				$locale->get_string('quote_rating_up_short_title')),
			'QUOTE_RATING_DOWN_SHORT_TITLE' => &_text_to_xhtml(
				$locale->get_string('quote_rating_down_short_title')),
			'QUOTE_REPORT_SHORT_TITLE' => &_text_to_xhtml(
				$locale->get_string('report_quote_short_title')),
			'QUOTE_DATE_RFC822' => sub {
				return &_format_date_time_rfc822($d);
			},
			'QUOTE_DATE_ISO8601' => sub {
				return &_format_date_time_iso8601($d);
			}
		};
	}
	$date = time unless (defined $date);
	require HTTP::Date;
	my $header_date = HTTP::Date::time2str($date);
	if ($self->{'cgi'}->http('If-Modified-Since') eq $header_date) {
		print $self->{'cgi'}->header(-status => '304 Not Modified');
		return;
	}
	$template->param(
		'FEED_TITLE' => $site_title,
		'FEED_SUBTITLE' => $page_title,
		'FEED_URL' => $self->_feed_url($type),
		'SITE_URL' => $self->_url(),
		'WEBMASTER_NAME' => $name,
		'WEBMASTER_EMAIL' => $email,
		'CHARACTER_ENCODING' => 'UTF-8',
		'CHIRPY_NAME' => Chirpy::PRODUCT_NAME,
		'CHIRPY_VERSION' => Chirpy::VERSION_STRING,
		'CHIRPY_URL' => Chirpy::URL,
		'QUOTES' => \@quotes,
		'FEED_DATE_RFC822' => sub {
			return &_format_date_time_rfc822($date);
		},
		'FEED_DATE_ISO8601' => sub {
			return &_format_date_time_iso8601($date);
		}
	);
	my $ctype = 'application/' . $type . '+xml';
	$ctype = 'text/xml' unless ($self->_accepts($ctype));
	$self->_maybe_gzip($template->output(), $ctype,
		'Last-Modified' => $header_date);
}

sub _generate_xhtml {
	my ($self, $quotes, $page, $previous, $next) = @_;
	$self->parent()->mark_debug_event('Build quote browser');
	my $name = &_get_page_name($page);
	my $locale = $self->locale();
	my $page_title = &_text_to_xhtml(
		$self->locale()->get_string($name));
	my $processing = &_text_to_xhtml(
		$locale->get_string('processing'));
	my $timed_out = &_text_to_xhtml(
		$locale->get_string('timed_out'));
	my $error = &_text_to_xhtml($locale->get_string('error'));
	my $flagged = &_text_to_xhtml($locale->get_string('flagged'));
	my $up = &_text_to_xhtml(
		$locale->get_string('quote_rating_up_short_title'));
	my $down = &_text_to_xhtml(
		$locale->get_string('quote_rating_down_short_title'));
	my $report = &_text_to_xhtml(
		$locale->get_string('report_quote_short_title'));
	my $edit = &_text_to_xhtml($locale->get_string('edit'));
	my $remove = &_text_to_xhtml($locale->get_string('remove'));
	my $unflag = &_text_to_xhtml($locale->get_string('unflag'));
	my $template = $self->_load_template('quote_list');
	$template->param(
		'PAGE_TITLE' => $page_title,
		'FLAGGED' => $flagged,
		'ERROR' => $error,
		'PROCESSING' => $processing,
		'TIMED_OUT' => $timed_out,
		'QUOTE_RATING_TIMED_OUT' => &_text_to_xhtml(
			$locale->get_string('webapp.quote_rating_timed_out')),
		'LIMIT_EXCEEDED_TEXT' => &_text_to_xhtml(
			$self->_quote_rating_limit_text()),
		'QUOTE_ALREADY_RATED_TEXT' => &_text_to_xhtml(
			$self->_quote_already_rated_text()),
		'QUOTE_NOT_FOUND_TEXT' => &_text_to_xhtml(
			$locale->get_string('rated_quote_not_found_text')),
		'SESSION_REQUIRED_TEXT' => &_text_to_xhtml(
			$locale->get_string('webapp.session_required'))
	);
	my $link_desc = &_text_to_xhtml(
		$locale->get_string('webapp.quote_link_description'));
	my $rating_up_desc = &_text_to_xhtml(
		$locale->get_string('quote_rating_up_description'));
	my $rating_down_desc = &_text_to_xhtml(
		$locale->get_string('quote_rating_down_description'));
	my $report_desc = &_text_to_xhtml(
		$locale->get_string('quote_report_description'));
	my $rating_desc = &_text_to_xhtml(
		$locale->get_string('quote_rating_description'));
	my $date_desc = &_text_to_xhtml(
		$locale->get_string('quote_date_description'));
	my $edit_desc = &_text_to_xhtml(
		$locale->get_string('quote_edit_description'));
	my $remove_desc = &_text_to_xhtml(
		$locale->get_string('quote_remove_description'));
	my $removal_conf = &_text_to_xhtml(
		$locale->get_string('quote_removal_confirmation'));
	my $notes_title = &_text_to_xhtml(
		$locale->get_string('quote_notes_title'));
	my $tags_title = &_text_to_xhtml(
		$locale->get_string('quote_tags_title'));
	my %static_strings = (
		'RATING_UP_DESCRIPTION' => $rating_up_desc,
		'RATING_DOWN_DESCRIPTION' => $rating_down_desc,
		'REMOVE_DESCRIPTION' => $remove_desc,
		'LINK_DESCRIPTION' => $link_desc,
		'REMOVE_DESCRIPTION' => $remove_desc,
		'REPORT_DESCRIPTION' => $report_desc,
		'RATING_DESCRIPTION' => $rating_desc,
		'DATE_DESCRIPTION' => $date_desc,
		'EDIT_DESCRIPTION' => $edit_desc,
		'REMOVE_DESCRIPTION' => $remove_desc,
		'REMOVAL_CONFIRMATION' => $removal_conf,
		'UP' => $up,
		'DOWN' => $down,
		'EDIT' => $edit,
		'REMOVE' => $remove,
		'UNFLAG' => $unflag,
		'REPORT' => $report,
		'FLAGGED' => $flagged,
		'NOTES_TITLE' => $notes_title,
		'TAGS_TITLE' => $tags_title
	);
	my $auto_link = $self->configuration()->get('ui', 'webapp.enable_autolink');
	my @quotes_tmpl = ();
	$self->parent()->mark_debug_event('Parse quotes for template');
	foreach my $quote (@$quotes) {
		my $up_url = $self->_url(
			ACTIONS->{'QUOTE_RATING_UP'},
			undef,
			'id' => $quote->get_id());
		my $down_url = $self->_url(
			ACTIONS->{'QUOTE_RATING_DOWN'},
			undef,
			'id' => $quote->get_id());
		my $report_url = $self->_url(
			ACTIONS->{'REPORT_QUOTE'},
			undef,
			'id' => $quote->get_id());
		$self->parent()->mark_debug_event('Parse quote body');
		my $body = &_text_to_xhtml($quote->get_body());
		my $notes = &_text_to_xhtml($quote->get_notes());
		my $tags = $self->_link_tags($quote);
		if ($auto_link) {
			$body = &_auto_link($body);
			$notes = &_auto_link($notes);
		}
		else {
			$body = &_spam_protect_email_addresses($body);
			$notes = &_spam_protect_email_addresses($notes);
		}
		$self->parent()->mark_debug_event('Quote body parsed');
		push @quotes_tmpl, {
			'ID' => $quote->get_id(),
			'BODY' => $body,
			'NOTES' => $notes,
			'TAGS' => $tags,
			'NOTES_OR_TAGS' => (defined $notes || @$tags ? 1 : 0),
			'RATING_NUMBER' => $quote->get_rating(),
			'RATING_TEXT'
				=> Chirpy::Util::format_quote_rating($quote->get_rating()),
			'SUBMITTED_TEXT' => &_text_to_xhtml(
				$self->format_date_time($quote->get_date_submitted())),
			'IS_APPROVED' => $quote->get_approved(),
			'IS_FLAGGED' => $quote->get_flagged(),
			'LINK_URL' => &_text_to_xhtml(
				$self->_quote_url($quote->get_id())),
			'RATING_UP_URL' => $up_url,
			'RATING_DOWN_URL' => $down_url,
			'REPORT_URL' => $report_url,
			'ALLOW_EDIT'
				=> $self->administration_allowed(Chirpy::UI::EDIT_QUOTE),
			'ALLOW_REMOVE'
				=> $self->administration_allowed(Chirpy::UI::REMOVE_QUOTE),
			'ALLOW_UNFLAG'
				=> $quote->get_flagged() && $self->administration_allowed(
					Chirpy::UI::MANAGE_FLAGGED_QUOTES),
			'EDIT_URL' => sub { return $self->_url(
				ADMIN_ACTIONS->{'EDIT_QUOTE'},
				1,
				'id' => $quote->get_id()) },
			'REMOVE_URL' => sub { return $self->_url(
				ADMIN_ACTIONS->{'REMOVE_QUOTE'},
				1,
				'id' => $quote->get_id()) },
			'UNFLAG_URL' => sub { return $self->_url(
				ADMIN_ACTIONS->{'MANAGE_FLAGGED_QUOTES'},
				1,
				'action_' . $quote->get_id() => 1) },
			'ADMINISTRATOR_LINKS'
				=> defined($self->get_logged_in_user_account()),
			%static_strings
		};
	}
	$self->parent()->mark_debug_event('Quotes parsed');
	$template->param('QUOTES' => \@quotes_tmpl);
	if (defined $previous || defined $next) {
		my $query = $self->_cgi_param('query');
		my %query = (defined $query && $query ne '' ? ('query' => $query) : ());
		$template->param('BROWSER' => 1);
		$template->param('PREVIOUS_URL' => $self->_url(
				$self->_action(),
				undef,
				'start' => $previous,
				%query
			)) if (defined $previous);
		$template->param('NEXT_URL' => $self->_url(
				$self->_action(),
				undef,
				'start' => $next,
				%query
			)) if (defined $next);
	}
	$self->_output_template($template);
	$self->parent()->mark_debug_event('Quote browser displayed');
	my $dbg = $self->parent()->debug_events();
	if (defined $dbg) {
		print "$/$/<!-- ";
		my $line = '=' x 80;
		print $/, $line;
		printf "$/%6s\t%6s\t%s", 'Time', 'Total', 'Event';
		print $/, $line;
		my $last_time = $self->parent()->start_time();
		my $total = 0;
		foreach my $event (@$dbg) {
			my $time = $event->[0] - $last_time;
			$total += $time;
			printf "$/%6.0f\t%6.0f\t%s",
				$time * 1000,
				$total * 1000,
				$event->[1];
			$last_time = $event->[0];
		}
		print "$/$line$/-->";
	}
}

sub provide_quote_search_interface {
	my $self = shift;
	my $template = $self->_load_template('quote_search');
	my $locale = $self->locale();
	$template->param(
		'PAGE_TITLE' => &_text_to_xhtml(
			$locale->get_string('search_for_quotes')),
		'SEARCH_FORM_START' => '<form method="get" action="'
			. $self->_url(ACTIONS->{'QUOTE_SEARCH'})
			. '">',
		'SEARCH_FORM_END' => '</form>',
		'QUERY_LABEL' => &_text_to_xhtml(
			$locale->get_string('search_query_title')),
		'SUBMIT_LABEL' => &_text_to_xhtml(
			$locale->get_string('search_button_label'))
	);
	$self->_output_template($template);
}

sub provide_tag_cloud {
	my ($self, $tag_information) = @_;
	my $template = $self->_load_template('tag_cloud');
	my $locale = $self->locale();
	my @tag_info = ();
	foreach my $arrayref (@$tag_information) {
		my ($tag, $cnt, $perc) = @$arrayref;
		my $title = $self->locale()->get_string('tag_link_description', $tag);
		push @tag_info, {
			'TAG' => &_text_to_xhtml($tag),
			'USAGE_COUNT' => $cnt,
			'SIZE_PERCENTAGE' => $perc,
			'URL' => &_text_to_xhtml($self->_tag_url($tag)),
			'LINK_DESCRIPTION' => &_text_to_xhtml($title)
		};
	}
	$template->param(
		'PAGE_TITLE' => &_text_to_xhtml(
			$locale->get_string('tag_cloud')),
		'TAGS' => \@tag_info
	);
	$self->_output_template($template);
}

sub report_no_tagged_quotes {
	my $self = shift;
	$self->_report_error($self->locale()->get_string('no_tagged_quotes'));
}

sub provide_statistics {
	my ($self, $quotes_by_date, $quotes_by_month, $quotes_by_week_day) = @_;
	my $template = $self->_load_template('statistics');
	my $locale = $self->locale();
	my @by_date = ();
	foreach my $d (sort keys %$quotes_by_date) {
		push @by_date, { 'DATE' => $self->format_date($d),
			'QUOTE_COUNT' => $quotes_by_date->{$d} };
	}
	my @by_month = ();
	foreach my $m (sort keys %$quotes_by_month) {
		push @by_month, { 'MONTH' => $self->format_month(split(/-/, $m)),
			'QUOTE_COUNT' => $quotes_by_month->{$m} };
	}
	my @by_week_day = ();
	my @days = qw(sunday monday tuesday wednesday thursday friday saturday);
	foreach my $d (0..6) {
		push @by_week_day, { 'WEEK_DAY' => $locale->get_string($days[$d]),
			'QUOTE_COUNT' => $quotes_by_week_day->[$d] };
	}
	$template->param(
		'PAGE_TITLE' => &_text_to_xhtml(
			$locale->get_string('statistics')),
		'QUOTES_BY_DATE_TITLE' => &_text_to_xhtml(
			$locale->get_string('quote_count_by_date')),
		'QUOTES_BY_DATE' => \@by_date,
		'QUOTES_BY_MONTH' => \@by_month,
		'QUOTES_BY_MONTH_TITLE' => &_text_to_xhtml(
			$locale->get_string('quote_count_by_month')),
		'QUOTES_BY_WEEK_DAY' => \@by_week_day,
		'QUOTES_BY_WEEK_DAY_TITLE' => &_text_to_xhtml(
			$locale->get_string('quote_count_by_week_day'))
		
	);
	$self->_output_template($template);
}

sub report_statistics_unavailable {
	my $self = shift;
	$self->_report_error($self->locale()->get_string('statistics_unavailable'));
}

sub report_no_search_results {
	my $self = shift;
	my $type = $self->_feed_type();
	if (defined $type) {
		$self->_generate_feed([], $type, Chirpy::UI::QUOTE_SEARCH);
	}
	else {
		my $locale = $self->locale();
		$self->_report_message($locale->get_string('no_search_results'),
			$locale->get_string('no_search_results_text'));
	}
}

sub report_inexistent_quote {
	my $self = shift;
	my $locale = $self->locale();
	$self->_report_message($locale->get_string('quote_not_found'),
		$locale->get_string('quote_not_found_text'));
}

sub provide_quote_submission_interface {
	my $self = shift;
	my $template = $self->_load_template('submit_quote');
	my $locale = $self->locale();
	$template->param(
		'PAGE_TITLE' => &_text_to_xhtml(
			$locale->get_string('submit_quote')),
		'NO_APPROVAL'
			=> $self->administration_allowed(Chirpy::UI::SUBMIT_QUOTE),
		'SUBMIT_FORM_START' => '<form method="post" action="'
			. $self->_url(ACTIONS->{'SUBMIT_QUOTE'}) . '">',
		'SUBMIT_FORM_END' => '</form>',
		'QUOTE_LABEL' => &_text_to_xhtml(
			$locale->get_string('submission_title')),
		'NOTES_LABEL' => &_text_to_xhtml(
			$locale->get_string('notes_title')),
		'TAGS_LABEL' => &_text_to_xhtml(
			$locale->get_string('tags_title')),
		'SUBMIT_LABEL' => &_text_to_xhtml(
			$locale->get_string('submit_button_label')),
		'SUBMIT_LABEL_NO_APPROVAL' => &_text_to_xhtml(
			$locale->get_string('submit_button_label_no_approval'))
	);
	if ($self->_requires_captcha()) {
		my $captcha = $self->_captcha();
		my $length = $self->param('captcha_code_length') || 4;
		my $imgpath = $self->param('captcha_source_image_path');
		my $width = $self->param('captcha_character_width');
		my $height = $self->param('captcha_character_height');
		my $expire = $self->param('captcha_expiry_time');
		$captcha->expire($expire) if ($expire);
		if ($imgpath && -d $imgpath) {
			$captcha->images_folder($imgpath);
			if ($width && $height) {
				$captcha->width($width);
				$captcha->height($height);
			}
			else {
				$width = $captcha->width();
				$height = $captcha->height();
			}
		}
		my $hash = $captcha->generate_code($length);
		$template->param(
			'USE_CAPTCHA' => 1,
			'CAPTCHA_HASH' => $hash,
			'CAPTCHA_IMAGE_URL'
				=> $self->param('captcha_image_url') . '/' . $hash . '.png',
			'CAPTCHA_CODE_LABEL' => &_text_to_xhtml(
				$locale->get_string('webapp.captcha_code_label')),
			'CAPTCHA_IMAGE_TEXT' => &_text_to_xhtml(
				$locale->get_string('webapp.captcha_image_text')),
			'CAPTCHA_IMAGE_WIDTH' => $length * $width,
			'CAPTCHA_IMAGE_HEIGHT' => $height,
			'CAPTCHA_CODE_LENGTH' => $length
		);
	}
	$self->_output_template($template);
}

sub confirm_quote_submission {
	my ($self, $admin) = @_;
	my $loc = $self->locale();
	if ($admin) {
		$self->_report_message(
			$loc->get_string('quote_submitted_no_approval'),
			$loc->get_string('quote_submission_thanks_no_approval'));
	}
	else {
		$self->_report_message($loc->get_string('quote_submitted'),
			$loc->get_string('quote_submission_thanks'));
	}
}

sub confirm_quote_rating {
	my ($self, $up, $new_rating) = @_;
	if ($self->_wants_xml()) {
		$self->_output_xml('result',
			'status' => STATUS_OK,
			'rating' => Chirpy::Util::format_quote_rating($new_rating)
		);
	}
	else {
		my $loc = $self->locale();
		$self->_report_message(
			$loc->get_string('quote_rating_'
				. ($up ? 'increased' : 'decreased')),
			$loc->get_string('quote_rating_thanks')
		);
	}
}

sub report_rated_quote_not_found {
	my ($self, $up) = @_;
	if ($self->_wants_xml()) {
		$self->_output_xml('result', 'status' => STATUS_QUOTE_NOT_FOUND);
	}
	else {
		my $loc = $self->locale();
		$self->_report_message(
			$loc->get_string('quote_not_found'),
			$loc->get_string('rated_quote_not_found_text')
		);
	}
}

sub report_quote_already_rated {
	my $self = shift;
	if ($self->_wants_xml()) {
		$self->_output_xml('result', 'status' => STATUS_ALREADY_RATED);
	}
	else {
		$self->_report_error($self->_quote_already_rated_text());
	}
}

sub report_quote_rating_limit_excess {
	my $self = shift;
	if ($self->_wants_xml()) {
		$self->_output_xml('result', 'status' => STATUS_RATING_LIMIT_EXCEEDED);
	}
	else {
		$self->_report_error($self->_quote_rating_limit_text());
	}
}

sub confirm_quote_report {
	my $self = shift;
	if ($self->_wants_xml()) {
		$self->_output_xml('result', 'status' => STATUS_OK);
	}
	else {
		my $loc = $self->locale();
		$self->_report_message(
			$loc->get_string('quote_reported'),
			$loc->get_string('quote_report_thanks')
		);
	}
}

sub report_reported_quote_not_found {
	my $self = shift;
	if ($self->_wants_xml()) {
		$self->_output_xml('result', 'status' => STATUS_QUOTE_NOT_FOUND);
	}
	else {
		my $loc = $self->locale();
		$self->_report_message(
			$loc->get_string('quote_not_found'),
			$loc->get_string('reported_quote_not_found_text')
		);
	}
}

sub provide_login_interface {
	my ($self, $invalid) = @_;
	my $template = $self->_load_template('login');
	my $locale = $self->locale();
	$template->param(
		'PAGE_TITLE' => &_text_to_xhtml(
			$locale->get_string($invalid
				? 'invalid_login_title'
				: 'login_title')),
		'USERNAME_TITLE' => &_text_to_xhtml(
			$locale->get_string('username_title')),
		'PASSWORD_TITLE' => &_text_to_xhtml(
			$locale->get_string('password_title')),
		'LOGIN_BUTTON_LABEL' => &_text_to_xhtml(
			$locale->get_string('login_button_label')),
		'LOGIN_FORM_START' => '<form method="post" action="'
			. $self->_url(ACTIONS->{'LOGIN'}) . '">',
		'LOGIN_FORM_END' => '</form>',
		'INVALID_LOGIN_INSTRUCTIONS' => &_text_to_xhtml(
			$locale->get_string(
				'invalid_login_instructions')),
		'INVALID_LOGIN' => $invalid
	);
	$self->_output_template($template);
}

sub report_invalid_login {
	my $self = shift;
	$self->provide_login_interface(1);
}

sub attempting_password_change {
	my $self = shift;
	return $self->_is_post();
}

sub get_supplied_passwords {
	my $self = shift;
	return ($self->_cgi_param('current_password'),
		$self->_cgi_param('new_password'),
		$self->_cgi_param('repeat_new_password'));
}

sub update_available {
	my ($self, $version, $released, $url) = @_;
	$self->{'available_update'} = [ $version, $released, $url ];
}

sub update_check_error {
	my ($self, $error) = @_;
	$self->{'update_check_error'} = $error;
}

sub get_current_administration_page {
	my $self = shift;
	my $action = $self->_admin_action();
	if (defined $action && $action) {
		if ($action eq ADMIN_ACTIONS->{'ADD_ACCOUNT'}) {
			return ($self->_cgi_param('account_remove')
				? Chirpy::UI::REMOVE_ACCOUNT
				: $self->get_account_to_modify() < 0
					? Chirpy::UI::ADD_ACCOUNT
					: Chirpy::UI::EDIT_ACCOUNT);
		}
		while (my ($n, $v) = each %{ADMIN_ACTIONS()}) {
			if ($v eq $action) {
				return eval 'Chirpy::UI::' . $n;
				return undef;
			}
		}
	}
	return undef;
}

sub report_administration_user_level_insufficient {
	my ($self, $page) = @_;
	$self->_output_administration_page();
}

sub welcome_administrator {
	my $self = shift;
	$self->_output_administration_page();
}

sub get_quote_to_remove {
	my $self = shift;
	return $self->_id();
}

sub confirm_quote_removal {
	my $self = shift;
	$self->_output_administration_page(
		'quote_removed' => 1
	);
}

sub report_quote_to_remove_not_found {
	my $self = shift;
	$self->_output_administration_page(
		'quote_to_remove_not_found' => 1
	);
}

sub provide_quote_selection_for_removal_interface {
	my $self = shift;
	$self->_output_administration_page();
}

sub provide_quote_selection_for_modification_interface {
	my $self = shift;
	$self->_output_administration_page();
}

sub get_quote_to_edit {
	my $self = shift;
	return $self->_id();
}

sub get_modified_quote_information {
	my $self = shift;
	return ($self->_cgi_param('quote'),
		$self->_cgi_param('notes'), $self->_cgi_param('tags'));
}

sub confirm_quote_modification {
	my $self = shift;
	$self->_output_administration_page(
		'quote_modified' => 1
	);
}

sub provide_quote_editing_interface {
	my ($self, $quote) = @_;
	$self->_output_administration_page(
		'edit_quote' => $quote
	);
}

sub report_quote_to_edit_not_found {
	my $self = shift;
	$self->_output_administration_page(
		'quote_to_edit_not_found' => 1
	);
}

sub provide_quote_approval_interface {
	my $self = shift;
	$self->_output_administration_page();
}

sub get_quote_flag_management_result {
	my $self = shift;
	my @unflag = ();
	my @remove = ();
	my @params = $self->_cgi_params();
	foreach my $name (@params) {
		if ($name =~ /^action_(\d+)$/) {
			my $id = $1;
			my $action = $self->_cgi_param($name);
			next unless $action;
			if ($action == 1) {
				push @unflag, $id;
			}
			elsif ($action == 2) {
				push @remove, $id;
			}
		}
	}
	return (\@unflag, \@remove);
}

sub provide_quote_flag_management_interface {
	my $self = shift;
	$self->_output_administration_page();
}

sub get_quote_approval_result {
	my $self = shift;
	my @approve = ();
	my @remove = ();
	my @params = $self->_cgi_params();
	foreach my $name (@params) {
		if ($name =~ /^action_(\d+)$/) {
			my $id = $1;
			my $action = $self->_cgi_param($name);
			next unless $action;
			if ($action == 1) {
				push @approve, $id;
			}
			elsif ($action == 2) {
				push @remove, $id;
			}
		}
	}
	return (\@approve, \@remove);
}

sub get_news_item_to_add {
	my $self = shift;
	return $self->_cgi_param('news');
}

sub confirm_news_submission {
	my $self = shift;
	$self->_output_administration_page(
		'news_item_added' => 1
	);
}

sub provide_news_submission_interface {
	my $self = shift;
	$self->_output_administration_page();
}

sub get_news_item_to_edit {
	my $self = shift;
	return $self->_id();
}

sub get_modified_news_item {
	my $self = shift;
	return ($self->_cgi_param('body'), $self->_cgi_param('poster') || undef);
}

sub confirm_news_item_modification {
	my $self = shift;
	$self->_output_administration_page(
		'news_item_modified' => 1
	);
}

sub report_news_item_to_edit_not_found {
	my $self = shift;
	$self->_output_administration_page(
		'news_item_to_edit_not_found' => 1
	);
}

sub provide_news_item_editing_interface {
	my ($self, $item) = @_;
	$self->_output_administration_page(
		'edit_news_item' => $item
	);
}

sub provide_news_item_selection_for_modification_interface {
	my $self = shift;
	$self->_output_administration_page();
}

sub get_news_item_to_remove {
	my $self = shift;
	return $self->_id();
}

sub confirm_news_item_removal {
	my $self = shift;
	$self->_output_administration_page(
		'news_item_removed' => 1
	);
}

sub report_news_item_to_remove_not_found {
	my $self = shift;
	$self->_output_administration_page(
		'news_item_to_remove_not_found' => 1
	);
}

sub get_account_information_to_add {
	my $self = shift;
	return $self->_get_supplied_account_information();
}

sub report_invalid_new_username {
	my $self = shift;
	$self->_output_administration_page(
		'invalid_username' => 1
	);
}

sub report_new_username_exists {
	my $self = shift;
	$self->_output_administration_page(
		'username_exists' => 1
	);
}

sub report_invalid_new_password {
	my $self = shift;
	$self->_output_administration_page(
		'invalid_password' => 1
	);
}

sub report_different_new_passwords {
	my $self = shift;
	$self->_output_administration_page(
		'different_passwords' => 1
	);
}

sub report_invalid_new_user_level {
	my $self = shift;
	$self->_output_administration_page(
		'invalid_user_level' => 1
	);
}

sub confirm_account_creation {
	my $self = shift;
	$self->_output_administration_page(
		'account_created' => 1
	);
}

sub provide_account_creation_interface {
	my $self = shift;
	$self->_output_administration_page();
}

sub get_account_to_modify {
	my $self = shift;
	return $self->_id() || undef;
}

sub get_modified_account_information {
	my $self = shift;
	return $self->_get_supplied_account_information();
}

sub report_invalid_modified_username {
	my $self = shift;
	$self->_output_administration_page(
		'invalid_username' => 1
	);
}

sub report_modified_username_exists {
	my $self = shift;
	$self->_output_administration_page(
		'username_exists' => 1
	);
}

sub report_invalid_modified_password {
	my $self = shift;
	$self->_output_administration_page(
		'invalid_password' => 1
	);
}

sub report_different_modified_passwords {
	my $self = shift;
	$self->_output_administration_page(
		'different_passwords' => 1
	);
}

sub report_invalid_modified_user_level {
	my $self = shift;
	$self->_output_administration_page(
		'invalid_user_level' => 1
	);
}

sub confirm_account_modification {
	my $self = shift;
	$self->_output_administration_page(
		'account_modified' => 1
	);
}

sub report_account_to_modify_not_found {
	my $self = shift;
	$self->_output_administration_page(
		'account_to_modify_not_found' => 1
	);
}

sub report_modified_account_information_required {
	my $self = shift;
	$self->_output_administration_page(
		'modified_account_information_required' => 1
	);
}

sub provide_account_selection_for_modification_interface {
	my $self = shift;
	$self->_output_administration_page();
}

sub get_account_to_remove {
	my $self = shift;
	return $self->_id() || undef;
}

sub confirm_account_removal {
	my $self = shift;
	$self->_output_administration_page(
		'account_removed' => 1
	);
}

sub report_account_to_remove_not_found {
	my $self = shift;
	$self->_output_administration_page(
		'account_to_remove_not_found' => 1
	);
}

sub provide_account_selection_for_removal_interface {
	my $self = shift;
	$self->_output_administration_page();
}

sub report_last_owner_account_removal_error {
	my $self = shift;
	$self->_output_administration_page(
		'last_owner_account_removal' => 1
	);
}

sub provide_password_change_interface {
	my ($self, $error) = @_;
	$self->_output_administration_page(
		'password_change_error' => $error
	);
}

sub confirm_password_change {
	my $self = shift;
	$self->_output_administration_page(
		'password_changed' => 1
	);
}

sub confirm_login {
	my $self = shift;
	$self->welcome_administrator();
}

sub confirm_logout {
	my $self = shift;
	$self->provide_login_interface();	
}

sub get_user_information {
	my $self = shift;
	my $cgi = $self->{'cgi'};
	return {
		'remote_addr' => $cgi->remote_addr(),
		'user_agent' => $cgi->user_agent()
	};
}

sub _get_supplied_account_information {
	my $self = shift;
	my $level = $self->_cgi_param('new_level');
	return ($self->_cgi_param('new_username') || undef,
		$self->_cgi_param('new_password') || undef,
		$self->_cgi_param('new_password_repeat') || undef,
		(!defined $level || $level < 0) ? undef : $level);
}

sub _output_administration_page {
	my ($self, %params) = @_;
	my $template = $self->_load_template('administration');
	my $locale = $self->locale();
	my ($upd_url, $upd_text);
	if (my $update = $self->{'available_update'}) {
		$template->param('UPDATE_AVAILABLE'
			=> &_text_to_xhtml($locale->get_string('update_available')));
		$template->param('UPDATE_AVAILABLE_TEXT' => &_text_to_xhtml(
			$locale->get_string('update_available_text',
			$update->[0], $update->[1])));
		$template->param('UPDATE_LINK_TEXT'
			=> &_text_to_xhtml($locale->get_string('update_link_text')));
		$template->param('UPDATE_URL' => &_text_to_xhtml($update->[2]));
	}
	elsif (my $errmsg = $self->{'update_check_error'}) {
		$template->param('UPDATE_CHECK_FAILED'
			=> &_text_to_xhtml($locale->get_string('update_check_failed')));
		$template->param('UPDATE_CHECK_FAILED_TEXT' => &_text_to_xhtml(
			$locale->get_string('update_check_failed_text')));
		$template->param('UPDATE_CHECK_ERROR_MESSAGE'
			=> &_text_to_xhtml($errmsg));
	}
	$template->param(
		'PAGE_TITLE' => &_text_to_xhtml(
			$locale->get_string('administration')),
		'APPROVE_QUOTES' => &_text_to_xhtml(
			$locale->get_string('approve_quotes')),
		'APPROVE_QUOTES_HTML'
			=> sub { return $self->_get_approve_quotes_html(%params) },
		'APPROVE_QUOTES_ALLOWED'
			=> $self->administration_allowed(Chirpy::UI::MANAGE_UNAPPROVED_QUOTES),
		'APPROVE_QUOTES_NOT_ALLOWED_HTML'
			=> sub { return $self->_get_access_disallowed_html() },
		'FLAGGED_QUOTES' => &_text_to_xhtml(
			$locale->get_string('flagged_quotes')),
		'FLAGGED_QUOTES_HTML'
			=> sub { return $self->_get_flagged_quotes_html(%params) },
		'FLAGGED_QUOTES_ALLOWED'
			=> $self->administration_allowed(Chirpy::UI::MANAGE_FLAGGED_QUOTES),
		'FLAGGED_QUOTES_NOT_ALLOWED_HTML'
			=> sub { return $self->_get_access_disallowed_html() },
		'MANAGE_QUOTES' => &_text_to_xhtml(
			$locale->get_string('manage_quotes')),
		'MANAGE_QUOTES_HTML'
			=> sub { return $self->_get_manage_quotes_html(%params) },
		'MANAGE_QUOTES_ALLOWED'
			=> $self->administration_allowed(Chirpy::UI::EDIT_QUOTE)
				&& $self->administration_allowed(Chirpy::UI::REMOVE_QUOTE),
		'MANAGE_QUOTES_NOT_ALLOWED_HTML'
			=> sub { return $self->_get_access_disallowed_html() },
		'MANAGE_NEWS' => &_text_to_xhtml(
			$locale->get_string('manage_news')),
		'MANAGE_NEWS_HTML'
			=> sub { return $self->_get_manage_news_html(%params) },
		'MANAGE_NEWS_ALLOWED'
			=> $self->administration_allowed(Chirpy::UI::ADD_NEWS)
				&& $self->administration_allowed(Chirpy::UI::EDIT_NEWS)
				&& $self->administration_allowed(Chirpy::UI::REMOVE_NEWS),
		'MANAGE_NEWS_NOT_ALLOWED_HTML'
			=> sub { return $self->_get_access_disallowed_html() },
		'MANAGE_ACCOUNTS' => &_text_to_xhtml(
			$locale->get_string('manage_accounts')),
		'MANAGE_ACCOUNTS_HTML'
			=> sub { return $self->_get_manage_accounts_html(%params) },
		'MANAGE_ACCOUNTS_ALLOWED'
			=> $self->administration_allowed(Chirpy::UI::ADD_ACCOUNT)
				&& $self->administration_allowed(Chirpy::UI::EDIT_ACCOUNT)
				&& $self->administration_allowed(Chirpy::UI::REMOVE_ACCOUNT),
		'MANAGE_ACCOUNTS_NOT_ALLOWED_HTML'
			=> sub { return $self->_get_access_disallowed_html() },
		'CHANGE_PASSWORD' => &_text_to_xhtml(
			$locale->get_string('change_password')),
		'CHANGE_PASSWORD_HTML'
			=> sub { return $self->_get_change_password_html(%params) },
		'ACTION_IS_' . $self->_admin_action() => 1
	);
	$self->_output_template($template);
}

sub _get_approve_quotes_html {
	my ($self, %params) = @_;
	my $locale = $self->parent()->locale();
	my $quotes = $self->parent()->get_unapproved_quotes();
	if (defined $quotes) {
		my $html = '<form method="post" action="'
			. $self->_url(
				Chirpy::UI::WebApp::ADMIN_ACTIONS->{'MANAGE_UNAPPROVED_QUOTES'},
				1
			) . '">' . $/
			. '<ul id="unapproved-quotes-list" class="quote-list">' . $/;
		foreach my $quote (@$quotes) {
			my $id = $quote->get_id();
			my $notes = $quote->get_notes();
			my $tags = $quote->get_tags();
			$html .= '<li>' . $/
				. '<div class="quote-container">' . $/
				. '<h3 class="quote-header">'
				. '<span class="quote-id">#' . $quote->get_id() . '</span> '
				. '<span class="quote-date">'
				. $self->format_date_time($quote->get_date_submitted())
				. '</span>'
				. '</h3>' . $/
				. '<blockquote class="quote-body">' . $/
				. '<p>' . &_text_to_xhtml($quote->get_body())
				. '</p>' . $/
				. '</blockquote>' . $/
				. (defined $notes || @$tags ?
				  '<div class="quote-footer">' . (defined $notes
					? '<div class="quote-notes">' . $/
						. '<p><em class="quote-notes-title">Notes:</em>' . $/
						. &_text_to_xhtml($notes)
						. '</p>' . $/
						. '</div>' . $/
					: '')
				. (@$tags
					? '<div class="quote-tags">' . $/
						. '<p><em class="quote-tags-title">'
						. &_text_to_xhtml(
							$locale->get_string('quote_tags_title'))
						. '</em>' . $/
						. &_text_to_xhtml(join(' ', @$tags))
						. '</p>' . $/
						. '</div>' . $/
					: '')
				  . '</div>' : '')
				. '</div>' . $/
				. '<div class="approval-options">' . $/
				. '<input type="radio" name="action_' . $id
				. '" value="0" id="a' . $id . '-0" '
				. 'checked="checked" /> <label '
				. 'for="a' . $id . '-0">'
				. &_text_to_xhtml(
					$locale->get_string('do_nothing'))
				. '</label>' . $/
				. '<input type="radio" class="approve-rb" name="action_' . $id
				. '" value="1" id="a' . $id . '-1" /> <label '
				. 'for="a' . $id . '-1">'
				. &_text_to_xhtml(
					$locale->get_string('approve_unapproved_quote'))
				. '</label>' . $/
				. '<input type="radio" class="discard-rb" name="action_' . $id
				. '" value="2" id="a' . $id . '-2" /> <label '
				. 'for="a' . $id . '-2">'
				. &_text_to_xhtml(
					$locale->get_string('discard_unapproved_quote'))
				. '</label>' . $/
				. '</div>' . $/
				. '</li>' . $/;
		}
		$html .= '</ul>' . $/
			. '<div id="approve-submit-container">' . $/
			. '<div id="mass-approve-container">' . $/
			. '<input type="button" value="'
			. &_text_to_xhtml(
				$locale->get_string('approve_all_unapproved_quotes'))
			. '" id="approve-all-button" onclick="if (confirm(\''
			. &_text_to_xhtml(
				$locale->get_string('approve_all_unapproved_quotes_confirm'))
			. '\')) { var a = document.getElementsByTagName(\'input\'); '
			. 'for (var i = 0; i &lt; a.length; i++) '
			. 'if (a[i].className == \'approve-rb\') a[i].checked = true; '
			. 'submit(); }" />' . $/
			. '<input type="button" value="'
			. &_text_to_xhtml(
				$locale->get_string('discard_all_unapproved_quotes'))
			. '" id="discard-all-button" onclick="if (confirm(\''
			. &_text_to_xhtml(
				$locale->get_string('discard_all_unapproved_quotes_confirm'))
			. '\')) { var a = document.getElementsByTagName(\'input\'); '
			. 'for (var i = 0; i &lt; a.length; i++) '
			. 'if (a[i].className == \'discard-rb\') a[i].checked = true; '
			. 'submit(); }" />' . $/
			. '</div>' . $/
			. '<input type="submit" value="'
			. &_text_to_xhtml(
				$locale->get_string('update_database'))
			. '" id="approve-submit-button" />' . $/
			. '<input type="reset" value="'
			. &_text_to_xhtml(
				$locale->get_string('reset_form'))
			. '" id="approve-reset-button" />' . $/
			. '</div>' . $/
			. '</form>';
		return $html;
	}
	else {
		return '<p>' . &_text_to_xhtml(
			$locale->get_string('no_unapproved_quotes')) . '</p>';
	}
}

sub _get_flagged_quotes_html {
	my ($self, %params) = @_;
	my $locale = $self->parent()->locale();
	my $quotes = $self->parent()->get_flagged_quotes();
	if (defined $quotes) {
		my $html = '<form method="post" action="'
			. $self->_url(
				Chirpy::UI::WebApp::ADMIN_ACTIONS->{'MANAGE_FLAGGED_QUOTES'},
				1
			) . '">' . $/
			. '<ul id="flagged-quotes-list" class="quote-list">' . $/;
		foreach my $quote (@$quotes) {
			my $id = $quote->get_id();
			my $notes = $quote->get_notes();
			my $tags = $quote->get_tags();
			$html .= '<li>' . $/
				. '<div class="quote-container">' . $/
				. '<h3 class="quote-header">'
				. '<span class="quote-id">#' . $quote->get_id() . '</span> '
				. '<span class="quote-date">'
				. $self->format_date_time($quote->get_date_submitted())
				. '</span>'
				. '</h3>' . $/
				. '<blockquote class="quote-body">' . $/
				. '<p>' . &_text_to_xhtml($quote->get_body())
				. '</p>' . $/
				. '</blockquote>' . $/
				. (defined $notes || @$tags ?
				  '<div class="quote-footer">' . (defined $notes
					? '<div class="quote-notes">' . $/
						. '<p><em class="quote-notes-title">'
						. &_text_to_xhtml(
							$locale->get_string('quote_notes_title'))
						. '</em>' . $/
						. &_text_to_xhtml($notes)
						. '</p>' . $/
						. '</div>' . $/
					: '')
				. (@$tags
					? '<div class="quote-tags">' . $/
						. '<p><em class="quote-tags-title">'
						. &_text_to_xhtml(
							$locale->get_string('quote_tags_title'))
						. '</em>' . $/
						. &_text_to_xhtml(join(' ', @$tags))
						. '</p>' . $/
						. '</div>' . $/
					: '')
				  . '</div>' : '')
				. '</div>' . $/
				. '<div class="flag-options">' . $/
				. '<input type="radio" name="action_' . $id
				. '" value="0" id="a' . $id . '-0" '
				. 'checked="checked" /> <label '
				. 'for="a' . $id . '-0">'
				. &_text_to_xhtml(
					$locale->get_string('do_nothing'))
				. '</label>' . $/
				. '<input type="radio" class="keep-rb" name="action_' . $id
				. '" value="1" id="a' . $id . '-1" /> <label '
				. 'for="a' . $id . '-1">'
				. &_text_to_xhtml(
					$locale->get_string('keep_flagged_quote'))
				. '</label>' . $/
				. '<input type="radio" class="remove-rb" name="action_' . $id
				. '" value="2" id="a' . $id . '-2" /> <label '
				. 'for="a' . $id . '-2">'
				. &_text_to_xhtml(
					$locale->get_string('remove_flagged_quote'))
				. '</label>' . $/
				. '</div>' . $/
				. '</li>' . $/;
		}
		$html .= '</ul>' . $/
			. '<div id="flag-submit-container">' . $/
			. '<div id="mass-unflag-container">' . $/
			. '<input type="button" value="'
			. &_text_to_xhtml(
				$locale->get_string('keep_all_flagged_quotes'))
			. '" id="keep-all-button" onclick="if (confirm(\''
			. &_text_to_xhtml(
				$locale->get_string('keep_all_flagged_quotes_confirm'))
			. '\')) { var a = document.getElementsByTagName(\'input\'); '
			. 'for (var i = 0; i &lt; a.length; i++) '
			. 'if (a[i].className == \'keep-rb\') a[i].checked = true; '
			. 'submit(); }" />' . $/
			. '<input type="button" value="'
			. &_text_to_xhtml(
				$locale->get_string('remove_all_flagged_quotes'))
			. '" id="discard-all-button" onclick="if (confirm(\''
			. &_text_to_xhtml(
				$locale->get_string('remove_all_flagged_quotes_confirm'))
			. '\')) { var a = document.getElementsByTagName(\'input\'); '
			. 'for (var i = 0; i &lt; a.length; i++) '
			. 'if (a[i].className == \'remove-rb\') a[i].checked = true; '
			. 'submit(); }" />' . $/
			. '</div>' . $/
			. '<input type="submit" value="'
			. &_text_to_xhtml(
				$locale->get_string('update_database'))
			. '" id="flag-submit-button" />' . $/
			. '<input type="reset" value="'
			. &_text_to_xhtml(
				$locale->get_string('reset_form'))
			. '" id="flag-reset-button" />' . $/
			. '</div>' . $/
			. '</form>';
		return $html;
	}
	else {
		return '<p>' . &_text_to_xhtml(
			$locale->get_string('no_flagged_quotes')) . '</p>';
	}
}

sub _get_manage_quotes_html {
	my ($self, %params) = @_;
	my $locale = $self->parent()->locale();
	if (my $quote = $params{'edit_quote'}) {
		my $notes = $quote->get_notes();
		my $tags = $quote->get_tags();
		return '<div id="edit-quote-form">' . $/
			. '<form method="post" action="'
			. $self->_url(
				Chirpy::UI::WebApp::ADMIN_ACTIONS->{'EDIT_QUOTE'},
				1,
				'id' => $quote->get_id()
			) . '"><div id="quote-container">' . $/
			. '<label for="quote-field">'
			. &_text_to_xhtml(
				$locale->get_string('submission_title'))
			. '</label>' . $/
			. '<textarea name="quote" id="quote-field"' . $/
			. 'rows="8" cols="80">'
			. Chirpy::Util::encode_xml_entities($quote->get_body())
			. '</textarea></div>' . $/
			. '<div id="notes-container">' . $/
			. '<label for="notes-field">'
			. &_text_to_xhtml(
				$locale->get_string('notes_title'))
			. '</label>' . $/
			. '<textarea name="notes" id="notes-field"' . $/
			. 'rows="3" cols="80">'
			. (defined $notes ? Chirpy::Util::encode_xml_entities($notes) : '')
			. '</textarea></div>' . $/
			. '<div id="tags-container">' . $/
			. '<label for="tags-field">'
			. &_text_to_xhtml(
				$locale->get_string('tags_title'))
			. '</label>' . $/
			. '<input type="text" name="tags" value="'
			. (@$tags ? &_text_to_xhtml(join(' ', @$tags)) : '')
			. '" id="tags-field" /></div>' . $/
			. '<div id="edit-quote-submit-container">' . $/
			. '<input type="submit" value="'
			. &_text_to_xhtml($locale->get_string('save_quote'))
			. '" id="edit-quote-submit-button" />' . $/
			. '<input type="reset" value="'
			. &_text_to_xhtml($locale->get_string('reset_form'))
			. '" id="edit-quote-reset-button" />' . $/
			. '</div></form></div>';
	}
	my $result;
	if ($params{'quote_removed'}) {
		$result = $locale->get_string('quote_removed');
	}
	elsif ($params{'quote_to_edit_not_found'}) {
		$result = $locale->get_string('quote_to_edit_not_found');
	}
	elsif ($params{'quote_to_remove_not_found'}) {
		$result = $locale->get_string('quote_to_remove_not_found');
	}
	elsif ($params{'quote_modified'}) {
		$result = $locale->get_string('quote_modified');
	}
	return (defined $result
		? '<p id="manage-quotes-result">'
			. &_text_to_xhtml($result) . '</p>'
		: '')
		. '<p id="manage-quote-instructions">'
		. &_text_to_xhtml(
			$locale->get_string('webapp.manage_quote_instructions'))
		. '</p>' . $/
		. '<div id="quick-manage-quote-form">' . $/
		. '<form method="post" action="'
		. $self->_url(undef, 1)
		. '" onsubmit="return (!document.getElementById'
		. '(\'quote-remove\').checked || confirm(&quot;'
		. &_text_to_xhtml($locale->get_string(
			'webapp.remove_quote_without_viewing_confirmation'))
		. '&quot;))">' . $/
		. '<div id="quick-manage-quote-id-container"><label' . $/
		. 'for="quick-manage-quote-id-field">'
		. &_text_to_xhtml(
			$locale->get_string('quote_id_title')) . '</label>' . $/
		. '<input name="id" id="quick-manage-quote-id-field" />' . $/
		. '</div>' . $/
		. '<div id="quick-manage-quote-options">' . $/
		. '<input type="radio" name="admin_action" value="'
		. Chirpy::UI::WebApp::ADMIN_ACTIONS->{'EDIT_QUOTE'} . '"' . $/
		. 'id="quote-edit" checked="checked" /> <label for="quote-edit">'
		. &_text_to_xhtml($locale->get_string('edit'))
		. '</label>' . $/
		. '<input type="radio" name="admin_action" value="'
		. Chirpy::UI::WebApp::ADMIN_ACTIONS->{'REMOVE_QUOTE'} . '"' . $/
		. 'id="quote-remove" /> <label for="quote-remove">'
		. &_text_to_xhtml($locale->get_string('remove'))
		. '</label></div>' . $/
		. '<div id="quick-manage-quote-submit">'
		. '<input type="submit" value="'
		. &_text_to_xhtml($locale->get_string('go'))
		. '&rarr;" /></div>' . $/
		. '</form></div>';
}

sub _get_manage_news_html {
	my ($self, %params) = @_;
	my $locale = $self->parent()->locale();
	if (my $item = $params{'edit_news_item'}) {
		my $html = '<div id="edit-news-item-form">' . $/
			. '<form method="post" action="'
			. $self->_url(
				Chirpy::UI::WebApp::ADMIN_ACTIONS->{'EDIT_NEWS'},
				1,
				'id' => $item->get_id())
			. '">' . $/
			. '<div id="news-item-container">' . $/
			. '<textarea name="body" id="news-item-field"' . $/
			. 'rows="8" cols="80">'
			. Chirpy::Util::encode_xml_entities($item->get_body())
			. '</textarea></div>' . $/
			. '<div id="news-item-poster-container">' . $/
			. '<label for="news-item-poster-select">'
			. &_text_to_xhtml(
				$locale->get_string('news_poster_title'))
			. '</label>' . $/
			. '<select name="poster" id="news-item-poster-select">' . $/
			. '<option>('
			. &_text_to_xhtml(
				$locale->get_string('unknown'))
			. ')</option>' . $/;
		my $posters = $self->get_news_posters();
		if (defined $posters) {
			foreach my $account (@$posters) {
				my $p = $item->get_poster();
				my $level = $account->get_level();
				$html .= '<option value="' . $account->get_id() . '"'
					. (defined $p && $account->get_id() == $p->get_id()
						? ' selected="selected"' : '')
					. ' class="user-level-' . $level . '">'
					. $account->get_username()
					. ' &lt;' . $self->parent()->user_level_name($level)
					. '&gt;</option>' . $/;
			}
		}
		return $html . '</select>'
			. '</div>' . $/
			. '<div id="edit-news-item-submit-container">' . $/
			. '<input type="submit" value="'
			. &_text_to_xhtml(
				$locale->get_string('save_news_item'))
			. '" id="edit-news-item-submit-button" />' . $/
			. '<input type="reset" value="'
			. &_text_to_xhtml(
				$locale->get_string('reset_form'))
			. '"' . $/
			. 'id="edit-news-item-reset-button" />' . $/
			. '</div></form></div>';
	}
	my $result;
	if ($params{'news_item_added'}) {
		$result = $locale->get_string('news_item_added');
	}
	elsif ($params{'news_item_modified'}) {
		$result = $locale->get_string('news_item_modified');
	}
	elsif ($params{'news_item_to_edit_not_found'}) {
		$result = $locale->get_string('news_item_to_edit_not_found');
	}
	elsif ($params{'news_item_removed'}) {
		$result = $locale->get_string('news_item_removed');
	}
	elsif ($params{'news_item_to_remove_not_found'}) {
		$result = $locale->get_string('news_item_to_remove_not_found');
	}
	return (defined $result
		? '<p id="manage-news-items-result">'
			. &_text_to_xhtml($result) . '</p>'
		: '')
		. '<div id="post-news-form">' . $/
		. '<form method="post" action="'
		. $self->_url(
			Chirpy::UI::WebApp::ADMIN_ACTIONS->{'ADD_NEWS'},
			1
		) . '">' . $/
		. '<div id="news-container">' . $/
		. '<label for="news-field">'
		. &_text_to_xhtml(
			$locale->get_string('new_news_item_title'))
		. '</label>' . $/
		. '<textarea name="news" id="news-field" rows="8" cols="80">' 
		. '</textarea>' . $/
		. '</div>' . $/
		. '<div id="submit-news-container">' . $/
		. '<input type="submit" value="'
		. &_text_to_xhtml($locale->get_string('add_news_item'))
		. '" id="submit-news-button" />' . $/
		. '<input type="reset" value="'
		. &_text_to_xhtml($locale->get_string('reset_form'))
		. '" id="reset-news-button" />' . $/
		. '</div>' . $/
		. '</form>' . $/
		. '</div>' . $/
		. '<p id="news-instructions">'
		. &_text_to_xhtml(
			$locale->get_string('webapp.manage_news_instructions'))
		. '</p>';
}

sub _get_manage_accounts_html {
	my ($self, %params) = @_;
	my $locale = $self->parent()->locale();
	my $status_message;
	if ($params{'account_to_modify_not_found'}) {
		$status_message = $locale->get_string('account_to_modify_not_found');
	}
	elsif ($params{'account_to_remove_not_found'}) {
		$status_message = $locale->get_string('account_to_remove_not_found');
	}
	elsif ($params{'last_owner_account_removal'}) {
		$status_message = $locale->get_string(
			'last_owner_account_removal_error');
	}
	elsif ($params{'modified_account_information_required'}) {
		$status_message = $locale->get_string(
			'modified_account_information_required');
	}
	elsif ($params{'invalid_username'}) {
		$status_message = $locale->get_string('invalid_username');
	}
	elsif ($params{'username_exists'}) {
		$status_message = $locale->get_string('username_exists');
	}
	elsif ($params{'invalid_password'}) {
		$status_message = $locale->get_string('invalid_password');
	}
	elsif ($params{'different_passwords'}) {
		$status_message = $locale->get_string('different_passwords');
	}
	elsif ($params{'invalid_user_level'}) {
		$status_message = $locale->get_string('invalid_user_level');
	}
	elsif ($params{'account_removed'}) {
		$status_message = $locale->get_string('account_removed');
	}
	elsif ($params{'account_modified'}) {
		$status_message = $locale->get_string('account_modified');
	}
	elsif ($params{'account_created'}) {
		$status_message = $locale->get_string('account_created');
	}
	my $html = '<form method="post" action="'
		. $self->_url(
			Chirpy::UI::WebApp::ADMIN_ACTIONS->{'ADD_ACCOUNT'},
			1
		) . '">' . $/
		. '<div id="account-manager">' . $/
		. '<div id="username-select-container">' . $/
		. '<select name="id" id="username-select" size="16">' . $/
		. '<option value="-1" id="username-new-user" selected="selected">'
		. '&lt;&lt; '
		. &_text_to_xhtml($locale->get_string('new_account'))
		. ' &gt;&gt;</option>' . $/;
	my $users = $self->parent()->get_accounts();
	if (defined $users) {
		foreach my $user (@$users) {
			$html .= '<option value="' . $user->get_id()
				. '" class="user-level-' . $user->get_level()
				. '">' . $user->get_username() . ' &lt;'
				. &_text_to_xhtml(
					$self->parent()->user_level_name($user->get_level()))
				. '&gt;</option>' . $/;
		}
	}
	$html .= '</select>' . $/
		. '</div>' . $/
		. '<div id="username-container">' . $/
		. '<label for="username-field">'
		. &_text_to_xhtml(
			$locale->get_string('new_username_title'))
		. '</label>' . $/
		. '<input name="new_username" id="username-field" />' . $/
		. '</div>' . $/
		. '<div id="password-container">' . $/
		. '<label for="password-field">'
		. &_text_to_xhtml(
			$locale->get_string('new_password_title'))
		. '</label>' . $/
		. '<input type="password" name="new_password" '
		. 'id="password-field" />' . $/
		. '</div>' . $/
		. '<div id="repeat-password-container">' . $/
		. '<label for="repeat-password-field">'
		. &_text_to_xhtml(
			$locale->get_string('repeat_new_password_title'))
		. '</label>' . $/
		. '<input type="password" name="new_password_repeat" '
		. 'id="repeat-password-field" />' . $/
		. '</div>' . $/
		. '<div id="level-container">' . $/
		. '<label for="level-select">'
		. &_text_to_xhtml(
			$locale->get_string('new_user_level_title'))
		. '</label>' . $/
		. '<select name="new_level" id="level-select" size="1">' . $/
		. '<option value="-1" selected="selected">&lt;'
		. &_text_to_xhtml(
			$locale->get_string('no_change'))
		. '&gt;</option>' . $/;
	foreach my $level ($self->parent()->user_levels()) {
		$html .= '<option value="' . $level . '" class="user-level-'
			. $level . '">' . &_text_to_xhtml(
				$self->parent()->user_level_name($level))
			. ' &lt;' . $level . '&gt;</option>' . $/;
	}
	$html .= '</select>' . $/
		. '</div>' . $/
		. '<div id="account-submit-container">' . $/
		. '<input type="submit" value="'
		. &_text_to_xhtml($locale->get_string('update_accounts'))
		. '" id="account-submit-button" />' . $/
		. '<input type="submit" name="account_remove" value="'
		. &_text_to_xhtml(
			$locale->get_string('remove_account'))
		. '" id="modify-account-remove-button" onclick="return confirm(&quot;'
		. &_text_to_xhtml(
			$locale->get_string('account_removal_confirmation'))
		. '&quot;)" />' . $/
		. '</div>' . $/
		. (defined $status_message
			? '<div id="account-manager-result">' . $/
				. &_text_to_xhtml($status_message)
				. $/ . '</div>' . $/
			: '')
		. '</div>' . $/
		. '<div style="clear: both;"></div>' . $/
		. '</form>' . $/;
	return $html;
}

sub _get_access_disallowed_html {
	my $self = shift;
	return '<p id="insufficient-administrator-privileges-notification">'
		. &_text_to_xhtml($self->locale()->get_string(
			'insufficient_administrative_privileges'))
		. '</p>';
}

sub _get_change_password_html {
	my ($self, %params) = @_;
	my $locale = $self->locale();
	if ($params{'password_changed'}) {
		return '<div id="change-password-result">' . $/
			. '<p>' . $locale->get_string('password_changed_text') . '</p>' . $/
			. '</div>';
	}
	my $html = '';
	if (my $error = $params{'password_change_error'}) {
		$html = '<div id="change-password-error">' . $/ . '<p>'
			. &_text_to_xhtml($locale->get_string(
				$error == Chirpy::UI::NEW_PASSWORD_INVALID
					? 'change_password_new_password_invalid_text'
					: ($error == Chirpy::UI::PASSWORDS_DIFFER
						? 'change_password_passwords_differ_text'
						: ($error == Chirpy::UI::CURRENT_PASSWORD_INVALID
							? 'change_password_current_password_invalid_text'
							: undef))))
			. '</p>' . $/ . '</div>' . $/;
	}
	return $html . '<div id="change-password-form">' . $/
		. '<form method="post" action="'
		. $self->_url(ADMIN_ACTIONS->{'CHANGE_PASSWORD'}, 1) . '">' . $/
		. '<div id="current-password-container">' . $/
		. '<label for="current-password-field">'
		. &_text_to_xhtml(
			$locale->get_string('current_password_title'))
		. '</label>' . $/
		. '<input type="password" name="current_password" '
		. 'id="current-password-field" />' . $/
		. '</div>' . $/
		. '<div id="new-password-container">' . $/
		. '<label for="new-password-field">'
		. &_text_to_xhtml(
			$locale->get_string('new_password_title'))
		. '</label>' . $/
		. '<input type="password" name="new_password" '
		. 'id="new-password-field" />' . $/
		. '</div>' . $/
		. '<div id="repeat-new-password-container">' . $/
		. '<label for="repeat-new-password-field">'
		. &_text_to_xhtml(
			$locale->get_string('repeat_new_password_title'))
		. '</label>' . $/
		. '<input type="password" name="repeat_new_password" '
		. 'id="repeat-new-password-field" />' . $/
		. '</div>' . $/
		. '<div id="submit-container">' . $/
		. '<input type="submit" value="'
		. &_text_to_xhtml(
			$locale->get_string('change_password_button_label'))
		. '" id="change-password-button" />' . $/
		. '</div>' . $/
		. '</form>' . $/
		. '</div>';
}

sub _provide_session {
	my $self = shift;
	my $session = new Chirpy::UI::WebApp::Session($self, 1);
	$self->_set_cookie($Chirpy::UI::WebApp::Session::NAME,
		$session->id(), $self->param('session_expiry'));
	return $session;
}

sub _provide_session_if_necessary {
	my ($self, $page) = @_;
	return if (defined $self->_session());
	my $force = &_requires_session($page);
	my $st = $self->_url_param('session_test');
	$st = 0 unless (defined $st);
	if ($force) {
		if ($self->_wants_xml()) {
			$self->_output_xml('result',
				'status' => STATUS_SESSION_REQUIRED);
		}
		elsif ($st == 2) {
			$self->_report_error($self->locale()
				->get_string('webapp.session_required'));
		}
		else {
			if ($st == 1) {
				$self->_provide_session();
				$st = 2;
			}
			else {
				$st = 1;
			}
			my $cgi = $self->{'cgi'};
			my $uri = $cgi->url(-path_info => 1) . '?session_test=' . $st;
			my @params = $self->_url_params();
			if ($self->param('enable_short_urls')) {
				@params = grep
					!/^(?:(?:admin_)?action|session_test)$/,
					@params;
			}
			else {
				@params = grep
					{ $_ ne 'session_test' }
					@params;
			}
			if (@params) {
				require URI::Escape;
				foreach my $p (@params) {
					$uri .= '&'
						. URI::Escape::uri_escape($p)
						. '='
						. URI::Escape::uri_escape($self->_url_param($p));
				}
			}
			print $cgi->header(
				-location => $uri,
				-cookie => $self->{'cookies'}
			);
		}
		exit;
	}
	else {
		$self->_provide_session();
	}
}

sub _get_page_name {
	my $page = shift;
	if ($page == Chirpy::UI::QUOTE_BROWSER) {
		return 'quote_browser';
	}
	elsif ($page == Chirpy::UI::RANDOM_QUOTES) {
		return 'random_quotes';
	}
	elsif ($page == Chirpy::UI::TOP_QUOTES) {
		return 'top_quotes';
	}
	elsif ($page == Chirpy::UI::BOTTOM_QUOTES) {
		return 'bottom_quotes';
	}
	elsif ($page == Chirpy::UI::QUOTES_OF_THE_WEEK) {
		return 'quotes_of_the_week';
	}
	elsif ($page == Chirpy::UI::SINGLE_QUOTE) {
		return 'view_quote';
	}
	elsif ($page == Chirpy::UI::QUOTE_SEARCH) {
		return 'search_results';
	}
	elsif ($page == Chirpy::UI::TAG_CLOUD) {
		return 'tag_cloud';
	}
	elsif ($page == Chirpy::UI::STATISTICS) {
		return 'statistics';
	}
	return undef;
}

sub _get_cookie {
	my ($self, $name) = @_;
	return $self->{'cgi'}->cookie(-name => $name);
}

sub _set_cookie {
	my ($self, $name, $value, $expires) = @_;
	my $cookie = $self->{'cgi'}->cookie(
		-name => $name,
		-value => $value, -expires => $expires,
		-domain => $self->param('cookie_domain'),
		-path => $self->param('cookie_path')
	);
	push @{$self->{'cookies'}}, $cookie;
}

sub _output_xml {
	my ($self, $root, %params) = @_;
	$self->_print_http_header('text/xml');
	print '<?xml version="1.0" encoding="UTF-8"?>', $/;
	print '<', $root, '>';
	while (my ($key, $value) = each %params) {
		print '<', $key, '>', $value, '</', $key, '>';
	}
	print '</', $root, '>';
}

sub _load_template {
	my ($self, $name) = @_;
	my $template = new HTML::Template(
		'filename' => $self->{'templates_path'} . '/' . $name . '.html',
		'die_on_bad_params' => 0,
		'global_vars' => 1,
		'file_cache' => 1,
		'file_cache_dir' => $self->param('template_cache_path'),
		'file_cache_dir_mode' => 0777
	);
	Chirpy::die('Failed to load template: ' . $!) unless ($template);
	return $template;
}

sub _output_template {
	my ($self, $template) = @_;
	my $output = $self->_process_template($template);
	my $ctype = 'application/xhtml+xml';
	if ($output =~ m#^<!DOCTYPE\b[^>]*\bXHTML 1\.1\b[^>]*>#
		&& $self->_accepts($ctype)) {
			$output = '<?xml version="1.0" encoding="UTF-8"?>' . $/
				. $output;
	}
	else {
		$ctype = 'text/html';
	}
	$self->_maybe_gzip($output, $ctype);
}

sub _maybe_gzip {
	my ($self, $content, $ctype, %headers) = @_;
	if (!defined $self->parent()->debug_events()
	&& $self->param('enable_gzip')
	&& $self->{'cgi'}->http('Accept-Encoding') =~ /\bgzip\b/i) {
		require Compress::Zlib;
		$self->_print_http_header($ctype,
			'Content-Encoding' => 'gzip', %headers);
		print Compress::Zlib::memGzip($content);
	}
	else {
		$self->_print_http_header($ctype, %headers);
		binmode(STDOUT, ":utf8");
		print $content;
	}
}

sub _print_http_header {
	my ($self, $ctype, %headers) = @_;
	print $self->{'cgi'}->header(-type => $ctype . '; charset=UTF-8',
		-cookie => $self->{'cookies'},
		%headers);
}

# TODO: make this faster
sub _process_template {
	my ($self, $template) = @_;
	my $locale = $self->locale();
	my $url = &_text_to_xhtml(Chirpy::URL);
	my $link = '<a href="' . $url . '">' . Chirpy::FULL_PRODUCT_NAME . '</a>';
	$template->param('CHIRPY_PRODUCT_NAME' => Chirpy::PRODUCT_NAME);
	$template->param('CHIRPY_VERSION' => Chirpy::VERSION_STRING);
	$template->param('CHIRPY_FULL_PRODUCT_NAME' => Chirpy::FULL_PRODUCT_NAME);
	$template->param('CHIRPY_URL' => $url);
	$template->param('CHIRPY_LINK' => $link);
	$template->param('SITE_TITLE'
		=> &_text_to_xhtml($self->configuration()
			->get('general', 'title')));
	$template->param('SITE_URL' => $self->_url());
	$template->param('WEBMASTER_EMAIL'
		=> sub { return &_hide_email($self->param('webmaster_email')) });
	my $qt = $locale->get_string('quotes_of_the_week');
	$template->param('FEEDS' => [
		{
			'FEED_URL' => $self->_feed_url('rss'),
			'FEED_TITLE' => &_text_to_xhtml($qt) . ' (RSS 2.0)',
			'FEED_MIME_TYPE' => 'application/rss+xml'
		},
		{
			'FEED_URL' => $self->_feed_url('atom'),
			'FEED_TITLE' => &_text_to_xhtml($qt) . ' (Atom 1.0)',
			'FEED_MIME_TYPE' => 'application/atom+xml'
		}
	]) if ($self->param('enable_feeds'));
	$template->param('APPROVED_QUOTE_COUNT' => sub {
		return $self->parent()->approved_quote_count();
	});
	$template->param('UNAPPROVED_QUOTE_COUNT' => sub {
		return $self->parent()->unapproved_quote_count();
	});
	$template->param('TOTAL_QUOTE_COUNT' => sub {
		return $self->parent()->total_quote_count();
	});
	$template->param('COOKIE_DOMAIN' => sub { return &_text_to_xhtml(
		$self->param('cookie_domain')) });
	$template->param('COOKIE_PATH' => sub { return &_text_to_xhtml(
		$self->param('cookie_path')) });
	$template->param('RESOURCES_URL' => sub { return &_text_to_xhtml(
		$self->param('resources_url')) . '/themes/' . $self->param('theme') });
	foreach my $action (keys %{ACTIONS()}) {
		$template->param($action . '_URL'
			=> $self->_url(ACTIONS->{$action}));
		foreach my $string (qw(DESCRIPTION SHORT_TITLE)) {
			my $name = $action . '_' . $string;
			$template->param($name => &_text_to_xhtml(
				$locale->get_string(
					($action eq 'START_PAGE' ? 'webapp.' : '')
					. lc $name)));
		}
	}
	$template->param('NEXT_PAGE_TITLE', sub { return &_text_to_xhtml(
		$locale->get_string('webapp.next_page_title')) });
	$template->param('PREVIOUS_PAGE_TITLE', sub { return &_text_to_xhtml(
		$locale->get_string('webapp.previous_page_title')) });
	if (my $account = $self->get_logged_in_user_account()) {
		$template->param('LOGGED_IN' => 1);
		$template->param('LOGGED_IN_NOTICE' => &_text_to_xhtml(
			$locale->get_string(
				'logged_in_as', $account->get_username(),
				$self->parent()->user_level_name($account->get_level()))));
	}
	$template->param('FOOTER_TEXT' => ($self->parent()->timing_enabled()
		? sub {
			(my $str = &_text_to_xhtml(
				$locale->get_string('webapp.footer_text',
					sprintf('%.0f', 1000 * $self->parent()->total_time()),
					"\0"))) =~ s/\0/$link/g;
			return $str;
		}
		: sub {
			(my $str = &_text_to_xhtml(
				$locale->get_string('webapp.footer_text_no_time', "\0")))
					=~ s/\0/$link/g;
			return $str;
		})
	);
	return $template->output();
}

sub _text_to_xhtml {
	my ($str, $leave_whitespaces) = @_;
	return undef unless (defined $str);
	return '' if ($str eq '');
	$str = Chirpy::Util::encode_xml_entities($str);
	$str = &_whitespaces_to_xhtml($str) unless ($leave_whitespaces);
	return $str;
}

sub _whitespaces_to_xhtml {
	my $str = shift;
	$str =~ s|\r?\n|<br/>\n|g;
	$str =~ s/(?:[ \t])([ \t]+)/' ' . ('&#xA0;' x length($1))/eg;
	return $str;
}

sub _quick_style_to_xhtml {
	my ($string, $quote_url_template) = @_;
	$string = &_text_to_xhtml($string, 1);
	$string =~ s{
		&lt;
		\s*
		(
			(?:mailto:|(?:https?|ftp|irc)://)
			.*?
		)
		(?:
			\s+
			(.*?)
		)?
		&gt;
	}{
		my ($url, $description) = ($1, $2);
		unless (defined $description && $description ne '') {
			$description = $url;
		}
		'<a href="' . $url . '">' . $description . '</a>';
	}esgx;
	$string = &_whitespaces_to_xhtml($string);
	1 while $string =~ s{([*_])(.*?)\1}{
		my $tag = ($1 eq '*' ? 'strong' : 'em');
		'<' . $tag . '>' . $2 . '</' . $tag . '>';
	}esg;
	if (defined $quote_url_template) {
		$quote_url_template = &_text_to_xhtml($quote_url_template);
		$string =~ s{ (#(\d+))}{
			my ($text, $id) = ($1, $2);
			(my $url = $quote_url_template) =~ s/\0/$id/g;
			' <a href="' . $url . '">' . $text . '</a>';
		}eig;
	}
	return $string;
}

sub _quote_already_rated_text {
	my $self = shift;
	my $conf = $self->configuration();
	return $self->locale()->get_string('quote_already_rated');
}

sub _quote_rating_limit_text {
	my $self = shift;
	my $conf = $self->configuration();
	return $self->locale()->get_string(
		'quote_rating_limit_exceeded',
			$conf->get('general', 'rating_limit_count'),
			$conf->get('general', 'rating_limit_time'));
}

sub _format_date_time_rfc822 {
	my $timestamp = shift;
	my @parts = split /\s+/, gmtime($timestamp);
	return $parts[0] . ', ' . $parts[2] . ' ' . $parts[1] . ' ' . $parts[4]
		. ' ' . $parts[3] . ' +0000';
}

sub _format_date_time_iso8601 {
	my $timestamp = shift;
	my @time = gmtime($timestamp);
	return sprintf('%04d-%02d-%02dT%02d:%02d:%02dZ',
		1900 + $time[5], $time[4] + 1, $time[3],
		$time[2], $time[1], $time[0]);
}

sub _auto_link {
	my ($html, $no_antispam) = @_;
	return undef unless (defined $html);
	$no_antispam = 0 unless (defined $no_antispam);
	# &amp; is the only entity we allow in URLs, so we temporarily replace all
	# of them with null bytes
	$html =~ s/&amp;/\0/ig;
	$html =~ s{
		\b
		((?:https?|ftp|irc)://[^\s&<>()\[\]\{\}]+)
		|((?:mailto:)?
			(?:[a-z0-9._\-\+]+\@[a-z0-9][a-z0-9\-.]+\.[a-z0-9]+))
	}{
		my ($href, $text);
		if (defined $2) {
			$text = ($no_antispam ? $2 : &_hide_email($2));
			$href = 'mailto:' . $text;
		}
		else {
			$text = $href = $1;
		}
		'<a href="' . $href . '">' . $text . '</a>';
	}eigx;
	$html =~ s/\0/&amp;/g;
	return $html;
}

sub _spam_protect_email_addresses {
	my $html = shift;
	$html =~ s/((?:mailto:)?([\w\.\+]+\@\S+\.\w+))/&_hide_email($1)/eig;
	return $html;
}

sub _hide_email {
	my $email = shift;
	$email =~ s/(.)/'&#'.ord($1).';'/eg;
	return $email;
}

sub _format_news_body {
	my ($self, $body) = @_;
	$body = &_quick_style_to_xhtml(
		$body,
		$self->_quote_url("\0")
	);
}

sub _link_tags {
	my ($self, $quote) = @_;
	my $tags = $quote->get_tags();
	return [] unless (defined $tags && @$tags);
	my @out = ();
	foreach my $tag (@$tags) {
		my $title = $self->locale()->get_string('tag_link_description', $tag);
		push @out, {
			'TAG' => &_text_to_xhtml($tag),
			'URL' => &_text_to_xhtml($self->_tag_url($tag)),
			'LINK_DESCRIPTION' => &_text_to_xhtml($title)
		};
	}
	return \@out;
}

sub _captcha {
	my $self = shift;
	require Authen::Captcha;
	return new Authen::Captcha(
		'data_folder' => $self->param('captcha_information_path'),
		'output_folder' => $self->param('captcha_image_path'),
	);
}

sub _cgi_params {
	my $self = shift;
	return $self->{'cgi'}->param();
}

sub _cgi_param {
	my ($self, $param) = @_;
	return $self->{'cgi'}->param($param) || '';
}

sub _url_params {
	my $self = shift;
	return $self->{'cgi'}->url_param();
}

sub _url_param {
	my ($self, $param) = @_;
	return $self->{'cgi'}->url_param($param) || '';
}

sub _is_post {
	my $self = shift;
	return $self->_http_request_method() eq 'POST';
}

sub _http_request_method {
	my $self = shift;
	return uc $self->{'cgi'}->request_method();
}

sub _accepts {
	my $self = shift;
	my $type = lc shift;
	foreach my $a ($self->{'cgi'}->Accept()) {
		return 1 if (lc($a) eq $type);
	}
	return 0;
}

sub _session {
	my $self = shift;
	return $self->{'session'};
}

sub _feed_url {
	my ($self, $type) = @_;
	return ($self->param('enable_short_urls')
			? $self->_url($type)
			: $self->_url(ACTIONS->{'QUOTES_OF_THE_WEEK'}, undef,
				'output' => $type));
}

sub _quote_url {
	my ($self, $id) = @_;
	return ($self->param('enable_short_urls')
		? $self->_url() . $id
		: $self->_url(undef, undef, 'id' => $id));
}

sub _tag_url {
	my ($self, $tag) = @_;
	return $self->_url(ACTIONS->{'QUOTE_SEARCH'}, undef,
		'query' => 'tag:' . $tag);
}

sub _url {
	my ($self, $action, $admin, %params) = @_;
	my $string;
	if (%params) {
		require URI::Escape;
		$string = join '&', map {
			URI::Escape::uri_escape($_)
				. '=' . URI::Escape::uri_escape($params{$_})
		} keys %params;
	}
	my $url = &_text_to_xhtml($self->param('site_url')
		. ($self->param('enable_short_urls')
			? ($admin ? '/' . ACTIONS->{'ADMINISTRATION'} : '')
				. ($action ? '/' . $action : (!$admin ? '/' : ''))
				. (defined $string ? '?' . $string : '')
			: '/index.cgi?' . ($admin
				? 'action=' . ACTIONS->{'ADMINISTRATION'}
					. ($action
						? '&admin_action=' . $action
							. (defined $string ? '&' : '')
						: '')
				: ($action
					? 'action=' . $action . (defined $string ? '&' : '')
					: '')
				) . (defined $string ? $string : '')
			)
		);
}

sub _action {
	my $self = shift;
	return $self->_url_param('action') || $self->_cgi_param('action');
}

sub _admin_action {
	my $self = shift;
	return $self->_url_param('admin_action')
		|| $self->_cgi_param('admin_action');
}

sub _output_type {
	my $self = shift;
	return $self->_url_param('output') || $self->_cgi_param('output');
}

sub _id {
	my $self = shift;
	return ($self->_url_param('id') || $self->_cgi_param('id'));
}

sub _wants_xml {
	my $self = shift;
	return $self->_output_type() eq 'xml';
}

sub _feed_type {
	my $self = shift;
	my $type = $self->_output_type();
	return ($self->param('enable_feeds') && &_valid_feed_type($type)
		? $type : undef);
}

sub _valid_feed_type {
	my $type = shift;
	return (defined $type && ($type eq 'atom' || $type eq 'rss'));
}

sub _requires_session {
	my $page = shift;
	return ($page == Chirpy::UI::QUOTE_RATING_UP
		|| $page == Chirpy::UI::QUOTE_RATING_DOWN
		|| $page == Chirpy::UI::REPORT_QUOTE
		|| $page == Chirpy::UI::LOGIN
		|| $page == Chirpy::UI::LOGOUT
		|| $page == Chirpy::UI::ADMINISTRATION);
}

sub _requires_captcha {
	my $self = shift;
	return ($self->param('enable_captchas')
		&& !defined $self->get_logged_in_user_account());
}

1;

###############################################################################