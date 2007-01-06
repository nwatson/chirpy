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

=item webapp.current_page_title

Translation of I<Current Page>, for a link to the current page in the event log
viewer.

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

=item webapp.minimum_tag_usage_count_title

The title for the tag cloud's slider label, i.e. "Minimum Quotes" followed by a
colon.

=item webapp.top_quote_prefix

The prefix for the "Top Quote" microsummary, i.e. "Top Quote" followed by a
colon.

=item webapp.bottom_quote_prefix

The prefix for the "Bottom Quote" microsummary, i.e. "Bottom Quote" followed by
a colon.

=item webapp.latest_quote_prefix

The prefix for the "Latest Quote" microsummary, i.e. "Latest Quote" followed by
a colon.

=item webapp.latest_unmoderated_quote_prefix

The prefix for the "Latest Unmoderated Quote" microsummary, i.e. "Latest
Unmoderated Quote" followed by a colon.

=back

=head1 TODO

Split into smaller modules, expose more methods, tons of optimizations.

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

$VERSION = '';
@ISA = qw(Chirpy::UI);

$TARGET_VERSION = '';

use Chirpy;
use Chirpy::UI;
use Chirpy::UI::WebApp::Session;

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
	'MODERATION_QUEUE' => 'queue',
	'SUBMIT_QUOTE' => 'submit',
	'ADMINISTRATION' => 'admin',
	'LOGIN' => 'login',
	'LOGOUT' => 'logout'
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
	'REMOVE_ACCOUNT' => 'accounts',
	'VIEW_EVENT_LOG' => 'log'
};

use constant STATUS_OK                     => 1;
use constant STATUS_ALREADY_RATED          => 2;
use constant STATUS_RATING_LIMIT_EXCEEDED  => 3;
use constant STATUS_QUOTE_NOT_FOUND        => 4;
use constant STATUS_SESSION_REQUIRED       => 5;

sub new {
	my $class = shift;
	my $self = $class->SUPER::new(@_);
	my $path = $self->_template_cache_path(1);
	$path = $self->_captcha_data_path(1);
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
	return $self->{'page'} if (exists $self->{'page'});
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
	$page = Chirpy::UI::START_PAGE unless (defined $page);
	$self->_provide_session_if_necessary($page);
	# XXX: This is sort of hackish. What to do?
	if (defined $self->_feed_type()) {
		my $quotes_per_feed = $self->param('quotes_per_feed');
		$quotes_per_feed = 50
			unless (defined $quotes_per_feed && $quotes_per_feed > 0);
		$self->parent()->quotes_per_page($quotes_per_feed);
	}
	elsif ($self->_wants_microsummary()
	&& $self->_page_offers_microsummary($page)) {
		$self->parent()->quotes_per_page(1);
	}
	$self->{'page'} = $page;
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
	return ([], []) unless (defined $query);
	my @queries = ();
	my @tags = ();
	while ($query =~ /"(.*?)"|(\S+)|"([^"]+)$/g) {
		my $literal = defined $1 ? $1 : $3;
		if (defined $literal) {
			push @queries, '*' . $literal . '*';
		}
		else {
			my $word = $2;
			if ($word =~ s/^tag://i) {
				push @tags, $word;
			}
			else {
				push @queries, '*' . $word . '*';
			}
		}
	}
	return (\@queries, \@tags);
}

sub get_submitted_quote {
	my $self = shift;
	if ($self->_requires_captcha()) {
		my $code = $self->_cgi_param('captcha_code');
		my $hash = $self->_cgi_param('captcha_hash');
		return undef unless (defined $code && defined $hash);
		my $captcha = $self->_captcha();
		my $result = $captcha->check_code($code, $hash);
		return undef if ($result <= 0);
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
	elsif ($self->_wants_microsummary()
	&& $self->_page_offers_microsummary($page)) {
		$self->_generate_microsummary(undef, $page);
	}
	else {
		my $name = &_get_page_name($page);
		my $title = $self->locale()->get_string($name);
		$self->_report_message(
			&_text_to_xhtml($title),
			$self->locale()->get_string('no_quotes'));
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
				'file_cache_dir' => $self->_template_cache_path(),
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
	elsif ($self->_wants_microsummary()
	&& $self->_page_offers_microsummary($page)) {
		$self->_generate_microsummary($quotes->[0], $page);
	}
	else {
		$self->_generate_xhtml($quotes, $page, $previous, $next);
	}
}

sub _generate_microsummary {
	my ($self, $quote, $page) = @_;
	my $locale = $self->locale();
	my $prefix;
	if ($page == Chirpy::UI::TOP_QUOTES) {
		$prefix = $locale->get_string('webapp.top_quote_prefix');
	}
	elsif ($page == Chirpy::UI::BOTTOM_QUOTES) {
		$prefix = $locale->get_string('webapp.bottom_quote_prefix');
	}
	elsif ($page == Chirpy::UI::MODERATION_QUEUE) {
		$prefix = $locale->get_string('webapp.latest_unmoderated_quote_prefix');
	}
	else {
		$prefix = $locale->get_string('webapp.latest_quote_prefix');
	}
	my $summary = $prefix . ' '
		. (defined $quote
			? $quote->get_id()
			: $locale->get_string('none'));
	# Don't serve Last-Modified here, since not everything is chronological
	$self->_maybe_gzip($summary, 'text/plain');
}

sub _generate_feed {
	my ($self, $quotes, $type, $page) = @_;
	my $date = $self->get_parameter('webapp.quote_feed_date');
	unless ($date) {
		if (@$quotes) {
			foreach my $quote (@$quotes) {
				my $d = $quote->get_date_submitted();
				$date = $d if (!defined($date) || $d > $date);
			}
		}
		else {
			$date = time;
		}
	}
	my $etag = sprintf('"%X"', $date);
	require HTTP::Date;
	my $ims = $self->{'cgi'}->http('If-Modified-Since');
	my $inm = $self->{'cgi'}->http('If-None-Match');
	if ((defined $ims || defined $inm)
	&& ((defined $ims && $date <= HTTP::Date::str2time($ims))
	|| (defined $inm && $etag eq $inm))) {
		print $self->{'cgi'}->header(-status => '304 Not Modified');
		return;
	}
	my $locale = $self->locale();
	my $conf = $self->configuration();
	my $site_title = &_text_to_xhtml(
		$conf->get('general', 'title'));
	my $page_title = &_text_to_xhtml(
		$self->locale()->get_string(&_get_page_name($page)));
	my $site_description = &_text_to_xhtml(
		$conf->get('general', 'description'));
	my $name = &_text_to_xhtml($self->param('webmaster_name'));
	my $email = &_hide_email($self->param('webmaster_email'));
	my $template = new HTML::Template(
		'filename' => $self->{'templates_path'}
			. '/feeds/' . ($type eq 'atom' ? 'atom10' : 'rss20') . '.xml',
		'die_on_bad_params' => 0,
		'global_vars' => 1,
		'file_cache' => 1,
		'file_cache_dir' => $self->_template_cache_path(),
		'file_cache_dir_mode' => 0777
	);
	my @quotes = ();
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
		my ($body, $notes, $tags) = $self->_format_quote($quote);
		push @quotes, {
			'QUOTE_TITLE' => &_text_to_xhtml(
				$locale->get_string('quote_title', $id)),
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
			'QUOTE_VOTE_COUNT' => $quote->get_vote_count(),
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
			},
			'QUOTE_IS_APPROVED' => $quote->is_approved(),
			'QUOTE_IS_FLAGGED' => $quote->is_flagged()
		};
	}
	my $act = $self->_action();
	$template->param(
		'SITE_TITLE' => $site_title,
		'PAGE_TITLE' => $page_title,
		'FEED_SUBTITLE' => $site_description,
		'FEED_URL' => $self->_feed_url($act, $type),
		'PAGE_URL' => $self->_url($act),
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
		-Last_Modified => HTTP::Date::time2str($date),
		-ETag => $etag);
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
			$locale->get_string('webapp.session_required')),
	);
	my $query;
	if ($page == Chirpy::UI::QUOTE_SEARCH) {
		$query = $self->_cgi_param('query');
		$template->param('SEARCH_QUERY' => &_text_to_xhtml($query));
	}
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
	my $vote_count_desc = &_text_to_xhtml(
		$locale->get_string('quote_vote_count_description'));
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
		'VOTE_COUNT_DESCRIPTION' => $vote_count_desc,
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
		my ($body, $notes, $tags) = $self->_format_quote($quote);
		$self->parent()->mark_debug_event('Quote body parsed');
		my $id = $quote->get_id();
		push @quotes_tmpl, {
			'ID' => $id,
			'TITLE' => &_text_to_xhtml(
				$locale->get_string('quote_title', $id)),
			'BODY' => $body,
			'NOTES' => $notes,
			'TAGS' => $tags,
			'NOTES_OR_TAGS' => (defined $notes || @$tags ? 1 : 0),
			'RATING_NUMBER' => $quote->get_rating(),
			'RATING_TEXT'
				=> Chirpy::Util::format_quote_rating($quote->get_rating()),
			'VOTE_COUNT' => $quote->get_vote_count(),
			'SUBMITTED_TEXT' => &_text_to_xhtml(
				$self->format_date_time($quote->get_date_submitted())),
			'IS_APPROVED' => $quote->is_approved(),
			'IS_FLAGGED' => $quote->is_flagged(),
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
				=> $quote->is_flagged() && $self->administration_allowed(
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
		my %query = (defined $query ? ('query' => $query) : ());
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
		$template->param('START_URL' => $self->_url(
				$self->_action(),
				undef,
				%query
			));
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
			$locale->get_string('search_for_quotes'))
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
		'TAGS' => \@tag_info,
		'USAGE_SLIDER_TITLE' => &_text_to_xhtml(
			$locale->get_string('webapp.minimum_tag_usage_count_title'))
	);
	$self->_output_template($template);
}

sub report_no_tagged_quotes {
	my $self = shift;
	$self->_report_error($self->locale()->get_string('no_tagged_quotes'));
}

sub provide_statistics {
	my ($self, $quotes_by_date,
		$quotes_by_hour, $quotes_by_weekday, $quotes_by_day, $quotes_by_month,
		$quotes_by_rating, $quotes_by_votes, $votes_by_rating) = @_;
	if ($self->statistics_update_allowed()) {
		$self->_output_xml('result');
		return;
	}
	my $template = $self->_load_template('statistics');
	my $locale = $self->locale();
	my @by_date = ();
	foreach my $line (@$quotes_by_date) {
		push @by_date, {
			'DATE' => $line->[0],
			'QUOTE_COUNT' => $line->[1]
		};
	}
	my @by_hour = ();
	foreach my $h (0..23) {
		push @by_hour, {
			'START_HOUR' => $h,
			'END_HOUR' => ($h == 23 ? 0 : $h + 1),
			'QUOTE_COUNT' => $quotes_by_hour->[$h]
		};
	}
	my @by_month = ();
	foreach my $month (0..11) {
		my ($short, $long) = $self->format_month($month);
		push @by_month, {
			'MONTH_NAME_SHORT' => $short,
			'MONTH_NAME' => $long,
			'QUOTE_COUNT' => $quotes_by_month->[$month]
		};
	}
	my @by_day = ();
	foreach my $day (0..30) {
		push @by_day, {
			'DAY' => $day + 1,
			'QUOTE_COUNT' => $quotes_by_day->[$day]
		};
	}
	my @by_weekday = ();
	my @days = qw(sunday monday tuesday wednesday thursday friday saturday);
	foreach my $d (0..6) {
		push @by_weekday, {
			'WEEKDAY' => $locale->get_string($days[$d]),
			'QUOTE_COUNT' => $quotes_by_weekday->[$d]
		};
	}
	my @by_rating = ();
	foreach my $line (@$quotes_by_rating) {
		push @by_rating, {
			'RATING' => Chirpy::Util::format_quote_rating($line->[0]),
			'QUOTE_COUNT' => $line->[1]
		};
	}
	my @by_votes = ();
	foreach my $line (@$quotes_by_votes) {
		push @by_votes, {
			'VOTE_COUNT' => $line->[0],
			'QUOTE_COUNT' => $line->[1]
		};
	}
	my @votes_by_rating = (
		{
			'RATING' => &_text_to_xhtml(
				$locale->get_string('quote_rating_up_short_title')),
			'VOTE_COUNT' => $votes_by_rating->[0]
		},
		{
			'RATING' => &_text_to_xhtml(
				$locale->get_string('quote_rating_down_short_title')),
			'VOTE_COUNT' => $votes_by_rating->[1]
		}
	);
	$template->param(
		'PAGE_TITLE' => &_text_to_xhtml(
			$locale->get_string('statistics')),
		'QUOTES_BY_DATE' => \@by_date,
		'QUOTES_BY_DATE_TITLE' => &_text_to_xhtml(
			$locale->get_string('quote_count_by_date')),
		'QUOTES_BY_HOUR' => \@by_hour,
		'QUOTES_BY_HOUR_TITLE' => &_text_to_xhtml(
			$locale->get_string('quote_count_by_hour')),
		'QUOTES_BY_MONTH' => \@by_month,
		'QUOTES_BY_MONTH_TITLE' => &_text_to_xhtml(
			$locale->get_string('quote_count_by_month')),
		'QUOTES_BY_DAY' => \@by_day,
		'QUOTES_BY_DAY_TITLE' => &_text_to_xhtml(
			$locale->get_string('quote_count_by_day')),
		'QUOTES_BY_WEEKDAY' => \@by_weekday,
		'QUOTES_BY_WEEKDAY_TITLE' => &_text_to_xhtml(
			$locale->get_string('quote_count_by_weekday')),
		'QUOTES_BY_RATING' => \@by_rating,
		'QUOTES_BY_RATING_TITLE' => &_text_to_xhtml(
			$locale->get_string('quote_count_by_rating')),
		'QUOTES_BY_VOTE_COUNT' => \@by_votes,
		'QUOTES_BY_VOTE_COUNT_TITLE' => &_text_to_xhtml(
			$locale->get_string('quote_count_by_vote_count')),
		'VOTES_BY_RATING' => \@votes_by_rating,
		'VOTES_BY_RATING_TITLE' => &_text_to_xhtml(
			$locale->get_string('vote_count_by_rating')),
		'UPDATE_URL'
			=> $self->_url(ACTIONS->{'STATISTICS'}, 0, 'update' => 1)
	);
	$self->_output_template($template);
}

sub report_statistics_unavailable {
	my $self = shift;
	$self->_report_error($self->locale()->get_string('statistics_unavailable'));
}

sub statistics_update_allowed {
	my $self = shift;
	return $self->_url_param('update');
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
			=> $self->administration_allowed(Chirpy::UI::MANAGE_UNAPPROVED_QUOTES),
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
		my $imgurl = $self->param('captcha_image_url');
		my $width = $self->param('captcha_character_width');
		my $height = $self->param('captcha_character_height');
		my $expire = $self->param('captcha_expiry_time');
		$imgurl = $self->param('site_url') . '/res/captcha'
			unless (defined $imgurl);
		$captcha->expire($expire) if ($expire);
		my $set_dimensions = ($width && $height);
		unless ($set_dimensions) {
			$width = 25;
			$height = 35;
		}
		if ($imgpath && -d $imgpath) {
			$captcha->images_folder($imgpath);
			if ($set_dimensions) {
				$captcha->width($width);
				$captcha->height($height);
			}
		}
		my $hash = $captcha->generate_code($length);
		$template->param(
			'USE_CAPTCHA' => 1,
			'CAPTCHA_HASH' => $hash,
			'CAPTCHA_IMAGE_URL' => &_text_to_xhtml($imgurl)
				. '/' . $hash . '.png',
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
		$self->_trigger_feed_update();
		$self->_report_message(
			$loc->get_string('quote_submitted_no_approval'),
			$loc->get_string('quote_submission_thanks_no_approval'));
	}
	else {
		$self->_report_message($loc->get_string('quote_submitted'),
			$loc->get_string('quote_submission_thanks'));
	}
}

sub quote_rating_confirmed {
	my $self = shift;
	return $self->_is_post();
}

sub request_quote_rating_confirmation {
	my ($self, $quote, $up, $revert) = @_;
	my $locale = $self->locale();
	my $action = 'quote_rating_' . ($up ? 'up' : 'down');
	$self->_confirmation_form(
		$self->_url($self->_action(), 0, 'id' => $quote->get_id()),
		1,
		$locale->get_string($action . '_description'),
		$locale->get_string($action . '_confirmation_request'),
		$quote);
}

sub confirm_quote_rating {
	my ($self, $id, $up, $new_rating, $new_vote_count) = @_;
	$self->_trigger_feed_update();
	if ($self->_wants_xml()) {
		$self->_output_xml('result', {
			'status' => STATUS_OK,
			'rating' => Chirpy::Util::format_quote_rating($new_rating),
			'votes' => $new_vote_count
		});
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
	my $self = shift;
	if ($self->_wants_xml()) {
		$self->_output_xml('result', { 'status' => STATUS_QUOTE_NOT_FOUND });
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
		$self->_output_xml('result', { 'status' => STATUS_ALREADY_RATED });
	}
	else {
		$self->_report_error($self->_quote_already_rated_text());
	}
}

sub report_quote_rating_limit_excess {
	my $self = shift;
	if ($self->_wants_xml()) {
		$self->_output_xml('result', { 'status' => STATUS_RATING_LIMIT_EXCEEDED });
	}
	else {
		$self->_report_error($self->_quote_rating_limit_text());
	}
}

sub quote_report_confirmed {
	my $self = shift;
	return $self->_is_post();
}

sub request_quote_report_confirmation {
	my ($self, $quote) = @_;
	my $locale = $self->locale();
	my $action = 'quote_report';
	$self->_confirmation_form(
		$self->_url($self->_action(), 0, 'id' => $quote->get_id()),
		1,
		$locale->get_string($action . '_description'),
		$locale->get_string($action . '_confirmation_request'),
		$quote);
}

sub confirm_quote_report {
	my $self = shift;
	$self->_trigger_feed_update();
	if ($self->_wants_xml()) {
		$self->_output_xml('result', { 'status' => STATUS_OK });
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
		$self->_output_xml('result', { 'status' => STATUS_QUOTE_NOT_FOUND });
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
	$self->_trigger_feed_update();
	$self->_output_administration_page(
		'quote_removed' => 1
	);
}

sub quote_removal_confirmed {
	my $self = shift;
	return $self->_cgi_param('confirm');
}

sub request_quote_removal_confirmation {
	my ($self, $quote) = @_;
	$self->_output_administration_page(
		'confirm_quote_removal' => $quote
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
	$self->_trigger_feed_update();
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
	if (@unflag || @remove) {
		$self->_trigger_feed_update();
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
	my %edited = ();
	my @params = $self->_cgi_params();
	foreach my $name (@params) {
		if ($name =~ /^(action|body|notes|tags)_(\d+)$/) {
			my ($type, $id) = ($1, $2);
			if ($type eq 'action') {
				my $action = $self->_cgi_param($name);
				next unless $action;
				if ($action == 1) {
					push @approve, $id;
				}
				elsif ($action == 2) {
					push @remove, $id;
				}
			}
			else {
				$edited{$id}{$type} = $self->_cgi_param($name);
			}
		}
	}
	# TODO: Make sure something changed.
	$self->_trigger_feed_update();
	return (\@approve, \@remove, \%edited);
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

sub _trigger_feed_update {
	my $self = shift;
	$self->set_parameter('webapp.quote_feed_date', time);
}

sub _confirmation_form {
	my ($self, $url, $post, $title, $text, $quote) = @_;
	my $template = $self->_load_template('confirm');
	my $locale = $self->locale();
	my $body;
	if (defined $quote) {
		$body = &_text_to_xhtml($quote->get_body());
		$body = ($self->configuration()->get('ui', 'webapp.enable_autolink')
			? &_auto_link($body)
			: &_spam_protect_email_addresses($body));
	}
	$template->param(
		'PAGE_TITLE' => &_text_to_xhtml($title),
		'URL' => &_text_to_xhtml($url),
		'POST_FORM' => $post,
		'CONFIRMATION_REQUEST' => &_text_to_xhtml($text),
		'CONFIRMATION_TEXT' => &_text_to_xhtml(
			$locale->get_string('ok')),
		'CANCELATION_TEXT' => &_text_to_xhtml(
			$locale->get_string('cancel')),
		'QUOTE_BODY' => (defined $body
			? $body
			: undef)
	);
	$self->_output_template($template);
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
	require Chirpy::UI::WebApp::Administration;
	my $adm = new Chirpy::UI::WebApp::Administration($self);
	$adm->output(%params);
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
				{ 'status' => STATUS_SESSION_REQUIRED });
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
	elsif ($page == Chirpy::UI::MODERATION_QUEUE) {
		return 'unmoderated_quotes';
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
	my ($self, $root, $data) = @_;
	$self->_print_http_header('text/xml');
	print '<?xml version="1.0" encoding="UTF-8"?>', $/;
	print &_to_xml($data, $root);
}

sub _to_xml {
	my ($elem, $key) = @_;
	my $content;
	if (!defined $elem) {
		$content = '';
	}
	elsif (my $ref = ref $elem) {
		if ($ref eq 'ARRAY') {
			return join('', map { &_to_xml($_, $key) } @$elem);
		}
		elsif ($ref eq 'HASH') {
			while (my ($key, $value) = each %$elem) {
				$content .= &_to_xml($value, $key);
			}
		}
		else {
			Chirpy::die('Serialization error');
		}
	}
	else {
		$content = $elem;
	}
	return '<' . $key . '>' . $content . '</' . $key . '>';
}

sub _load_template {
	my ($self, $name) = @_;
	my $template = new HTML::Template(
		'filename' => $self->{'templates_path'} . '/' . $name . '.html',
		'die_on_bad_params' => 0,
		'global_vars' => 1,
		'file_cache' => 1,
		'file_cache_dir' => $self->_template_cache_path(),
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
	my $accenc = $self->{'cgi'}->http('Accept-Encoding');
	if (!defined $self->parent()->debug_events()
	&& $self->param('enable_gzip')
	&& defined $accenc && $accenc =~ /\bgzip\b/i) {
		require Compress::Zlib;
		$self->_print_http_header($ctype,
			'Content-Encoding' => 'gzip', %headers);
		print Compress::Zlib::memGzip($content);
	}
	else {
		$self->_print_http_header($ctype, %headers);
		binmode(STDOUT, ':utf8');
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
	my $page = $self->get_current_page();
	if ($self->param('enable_feeds')) {
		my $page_feed = $self->_page_feed($page);
		if (defined $page_feed) {
			my $ft = &_text_to_xhtml(
				$locale->get_string(&_get_page_name($page_feed)));
			# TODO: Don't assume QotW is the default, perhaps make _page_feed
			# supply action
			my $action = ($page_feed == Chirpy::UI::QUOTES_OF_THE_WEEK
				? ACTIONS->{'QUOTES_OF_THE_WEEK'}
				: $self->_action());
			$template->param('FEEDS' => [
				{
					'FEED_URL' => $self->_feed_url($action, 'rss'),
					'FEED_TITLE' => $ft . ' (RSS 2.0)',
					'FEED_MIME_TYPE' => 'application/rss+xml'
				},
				{
					'FEED_URL' => $self->_feed_url($action, 'atom'),
					'FEED_TITLE' => $ft . ' (Atom 1.0)',
					'FEED_MIME_TYPE' => 'application/atom+xml'
				}
			]);
		}
	}
	if ($self->_page_offers_microsummary($page)) {
		$template->param('MICROSUMMARIES' => [
			{
				'MICROSUMMARY_URL' => $self->_microsummary_url($self->_action())
			}
		]);
	}
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
		$self->_resources_url()) });
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
	$template->param('MODERATION_QUEUE_PUBLIC' => 1)
		if ($self->moderation_queue_is_public());
	if (my $account = $self->get_logged_in_user_account()) {
		$template->param('LOGGED_IN' => 1);
		$template->param('LOGGED_IN_NOTICE' => &_text_to_xhtml(
			$locale->get_string(
				'logged_in_as', $account->get_username(),
				$self->parent()->user_level_name($account->get_level()))));
	}
	$template->param(
		'SEARCH_FORM_START' => '<form method="get" action="'
			. $self->_url(ACTIONS->{'QUOTE_SEARCH'})
			. '">',
		'SEARCH_FORM_END' => '</form>',
		'SEARCH_QUERY_LABEL' => &_text_to_xhtml(
			$locale->get_string('search_query_title')),
		'SUBMIT_SEARCH_LABEL' => &_text_to_xhtml(
			$locale->get_string('search_button_label'))
	);
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

sub _template_cache_path {
	my $self = shift;
	my $path = $self->configuration()->get('general', 'base_path')
		. '/cache/template';
	&_ensure_writable_directory($path);
	return $path;
}

sub _captcha_data_path {
	my $self = shift;
	my $path = $self->configuration()->get('general', 'base_path')
		. '/cache/captcha';
	&_ensure_writable_directory($path);
	return $path;
}

sub _ensure_writable_directory {
	my $path = shift;
	if (-e $path) {
		if (-d $path) {
			if (!-w $path) {
				chmod 0777, $path;
				if (!-w $path) {
					Chirpy::die('Directory "' . $path . '" not writable');
				}
			}
		}
		else {
			Chirpy::die('Path "' . $path . '" must be a directory');
		}
	}
	else {
		mkdir $path
			or die('Cannot create directory "' . $path . '": ' . $!);
	}
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
	$str =~ s|\r?\n([ \t]*)|"<br/>\n" . ('&#xA0;' x length($1))|eg;
	$str =~ s/([ \t]{2,})/'&#xA0;' x length($1)/eg;
	$str =~ s/^([ \t]+)/'&#xA0;' x length($1)/eg;
	$str =~ s/([ \t]+)$/'&#xA0;' x length($1)/eg;
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

# XXX: Move to Chirpy::Util?
sub _format_date_time_rfc822 {
	my $timestamp = shift;
	my @parts = split /\s+/, gmtime($timestamp);
	return $parts[0] . ', ' . $parts[2] . ' ' . $parts[1] . ' ' . $parts[4]
		. ' ' . $parts[3] . ' +0000';
}

# XXX: Move to Chirpy::Util?
sub _format_date_time_iso8601 {
	my $timestamp = shift;
	my @time = gmtime($timestamp);
	return sprintf('%04d-%02d-%02dT%02d:%02d:%02dZ',
		1900 + $time[5], $time[4] + 1, $time[3],
		$time[2], $time[1], $time[0]);
}

sub _format_quote {
	my ($self, $quote) = @_;
	my $body = &_text_to_xhtml($quote->get_body());
	my $notes = &_text_to_xhtml($quote->get_notes());
	my $tags = $self->_link_tags($quote);
	if ($self->configuration()->get('ui', 'webapp.enable_autolink')) {
		$body = &_auto_link($body);
		$notes = &_auto_link($notes);
	}
	else {
		$body = &_spam_protect_email_addresses($body);
		$notes = &_spam_protect_email_addresses($notes);
	}
	return ($body, $notes, $tags);
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
		|([a-z0-9._\-\+]+\@[a-z0-9][a-z0-9\-.]+\.[a-z0-9]+)
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
	$email =~ s{(.)}{
		my $n = ord $1;
		'&#' . (int rand 2 ? sprintf('x%X', $n) : $n) . ';';
	}eg;
	return $email;
}

sub _format_news_body {
	my ($self, $body) = @_;
	# TODO: Make all this a little more efficient
	$body = &_quick_style_to_xhtml(
		$body,
		$self->_quote_url("\0")
	);
	my @paragraphs = split(/(?:<\s*br\s*\/\s*>\s*){2,}/, $body);
	return join("\n", map { '<p>' . &_fix_xml($_) . '</p>' } @paragraphs);
}

sub _fix_xml {
	my $xml = shift;
	my @stack = ();
	my $out = '';
	while ($xml =~ s|^([^<]*)<\s*(/?)(\w*)(.*?)(/?)>||sg) {
		my ($text, $closing, $element, $attributes, $selfclosing)
			= ($1, $2, $3, $4, $5);
		if (length($selfclosing)) {
			$out .= $&;
		}
		elsif (!length($closing)) {
			push @stack, $element;
			$out .= $&;
		}
		elsif ($stack[-1] eq $element) {
			pop @stack;
			$out .= $text . '</' . $element . '>';
		}
		else {
			$out .= $text;
		}
	}
	$out .= $xml;
	while (my $element = pop @stack) {
		$out .= '</' . $element . '>'; 
	}
	return $out;
}

sub _link_tags {
	my ($self, $quote) = @_;
	my $tags = $quote->get_tags();
	return [] unless (defined $tags && @$tags);
	my @out = ();
	foreach my $tag (sort @$tags) {
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
	my $imgpath = $self->param('captcha_image_path');
	$imgpath = $self->configuration()->get('general', 'base_path')
		. '/../res/captcha' unless (defined $imgpath);
	return new Authen::Captcha(
		'data_folder' => $self->_captcha_data_path(),
		'output_folder' => $imgpath
	);
}

sub _cgi_params {
	my $self = shift;
	return $self->{'cgi'}->param();
}

sub _cgi_param {
	my ($self, $param) = @_;
	return $self->{'cgi'}->param($param);
}

sub _url_params {
	my $self = shift;
	return $self->{'cgi'}->url_param();
}

sub _url_param {
	my ($self, $param) = @_;
	return $self->{'cgi'}->url_param($param);
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

sub _resources_url {
	my $self = shift;
	return $self->param('resources_url') . '/themes/' . $self->param('theme');
}

sub _feed_url {
	my ($self, $action, $type) = @_;
	return ($self->param('enable_short_urls')
		# TODO: Update _url() for feeds
		? $self->_url($type . '/' . $action)
		: $self->_url($action, undef, 'output' => $type));
}

sub _microsummary_url {
	my ($self, $action) = @_;
	return ($self->param('enable_short_urls')
		# TODO: Update _url() for microsummaries
		? $self->_url('ms/' . $action)
		: $self->_url($action, undef, 'output' => 'ms'));
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
	my $id = $self->_url_param('id');
	$id = $self->_cgi_param('id') unless (defined $id);
	return undef unless (defined $id);
	return eval $id if ($id =~ /^0(?:x[0-9A-Fa-f]+|b[01]+)+$/);
	return $id;
}

sub _wants_microsummary {
	my $self = shift;
	my $ot = $self->_output_type();
	return (defined $ot && $ot eq 'ms');
}

sub _wants_xml {
	my $self = shift;
	my $ot = $self->_output_type();
	return (defined $ot && $ot eq 'xml');
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

sub _page_feed {
	my ($self, $page) = @_;
	if ($page == Chirpy::UI::START_PAGE
	|| $page == Chirpy::UI::QUOTE_BROWSER
	|| $page == Chirpy::UI::QUOTES_OF_THE_WEEK) {
		return Chirpy::UI::QUOTES_OF_THE_WEEK;
	}
	# TODO: Provide feeds for searches
	if ($page == Chirpy::UI::RANDOM_QUOTES
	|| $page == Chirpy::UI::TOP_QUOTES
	|| $page == Chirpy::UI::BOTTOM_QUOTES
	|| $page == Chirpy::UI::MODERATION_QUEUE) {
		return $page;
	}
	return undef;
}

sub _page_offers_microsummary {
	my ($self, $page) = @_;
	return ($page == Chirpy::UI::QUOTE_BROWSER
		|| $page == Chirpy::UI::TOP_QUOTES
		|| $page == Chirpy::UI::BOTTOM_QUOTES
		|| $page == Chirpy::UI::MODERATION_QUEUE
		|| $page == Chirpy::UI::QUOTES_OF_THE_WEEK);
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