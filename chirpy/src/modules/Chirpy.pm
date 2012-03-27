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

Chirpy - Main coordination class

=head1 REQUIREMENTS

Chirpy! uses the UTF-8 character encoding, and because of that, I<Perl 5.8> is
required. A lot of systems still have Perl 5.6 and, unfortunately, Chirpy! will
not run there. This might change in future releases.

It also relies on a couple of Perl modules, most of which are part of standard
Perl distributions. The base classes require these modules:

 Carp
 Digest::MD5
 Encode
 POSIX
 Storable

Additionally, the default data manager and user interface classes have their
own requirements. Before using them, please consult
L<the data manager's requirements|Chirpy::DataManager::MySQL/REQUIREMENTS>
and L<the user interface's requirements|Chirpy::UI::WebApp/REQUIREMENTS>.

=head1 SYNOPSIS

 use Chirpy;
 
 chirpy();

 chirpy($configuration_file, $data_manager_type);
 
 $chirpy = new Chirpy();
 $chirpy->run();

 $chirpy = new Chirpy($configuration_file, $data_manager_type);
 $chirpy->run();

=head1 DESCRIPTION

This module is Chirpy!'s main coordination class and the only one that scripts
that use it should access directly. Everything else is part of the inner
workings of Chirpy!.

An instance of this module really represents an entire Chirpy! configuration,
along with everything it uses at runtime. This means that you can have several
instances of it simultaneously and exchange information between them.

=head1 USAGE

There are two ways to use the class:

=over 4

=item Procedural Interface

The easiest way is to just run the C<chirpy()> procedure, which is exported by
default. The code below will attempt to run Chirpy! with a configuration file
located at either of the default paths F<src/chirpy.ini> and F<chirpy.ini>,
relative to the current working directory.

 chirpy;

That's it! Now, if you wanted to specify your own configuration file, you would
just pass it as the first parameter, like so:
 
 chirpy('/home/joe/chirpy.ini');

The path can also be relative, but make sure the working directory is correct.

=item Object-Oriented Interface

As you may want to distinguish between different installations, you can have
several instances of this module in the same script. Instantiating the module
is a lot like invoking C<chirpy()>, except that it doesn't create and run the
user interface instance yet.

 $chirpy = new Chirpy();

 $chirpy = new Chirpy('/home/joe/chirpy.ini');

If you wanted to create and run the configured user interface, you would just:

 $chirpy->run();

Simple as that.

In addition, you can add a second parameter to the constructor to override the
data manager type specified in the configuration file, which can be useful for
migration:

 $chirpy_old = new Chirpy('/home/joe/chirpy.ini');
 $chirpy_new = new Chirpy('/home/joe/chirpy.ini', 'MyNewDataManager');

While the C<chirpy()> procedure also takes that parameter, I don't see any real
use for it.

Note that if you want to use the default configuration file path, but with an
alternate data manager, you just pass C<undef> as the first parameter:

 $chirpy = new Chirpy(undef, 'MyNewDataManager');

=back

=head1 CONFIGURATION FILE

A Chirpy! configuration file is a standard INI file, so it looks a little
something like this:

 [general]
 title=My Little QDB
 description=A place for my quotes
 locale=en-US
 ...

 [data]
 type=MySQL
 ...

Chirpy! adds a third level of parameter nesting to this format by separating
the class and parameter name by a dot. For instance, the password for the
MySQL data manager is stored like:

 [data]
 mysql.password=mypassword

Now, let's go over the default configuration values.

=head2 General Section

The C<general> section configures ... general settings!

=over 4

=item base_path

The local path (on the file system) where locales, templates, etc. are stored.
Do I<not> include a trailing slash.

=item title

The title of your QDB.

=item description

A brief description of the purpose of your QDB.

=item locale

The code of the locale to use.

=item rating_limit_count

=item rating_limit_time

Limit the maximum number of votes per time frame using these two parameters.
The former sets the maximum number, the latter sets the time period in seconds.

=item quote_score_calculation_mode

Since Chirpy! 0.3, quote scores, which are used to order the quotes for the Top
and Bottom Quotes pages, are calculated using the following formula:

           positive votes + 1
  score = --------------------
           negative votes + 1

This results in a fairly decent distribution. However, if you prefer the old
way, based on a quote's rating, i.e.

  rating = positive votes - negative votes

you can set C<quote_score_calculation_mode> to C<1>. Note that the default way
corresponds with a value of C<0>; this value may correspond with a different
formula in future releases.

=back

=head2 Data Section

The C<data> section configures everything related to the data manager, or the
backend, if you will.

This section only has one default parameter, namely C<type>. It contains the
name of the data manager to use. This will be translated to
C<Chirpy::DataManager::I<Name>>, so that module will need to be installed.

Apart from that, there are parameters specific to the data manager of your
choice. Please refer to its documentation for an explanation. If you use the
default data manager, L<MySQL|Chirpy::DataManager::MySQL>, you can find the
parameters in L<its documentation|Chirpy::DataManager::MySQL/CONFIGURATION>.

=head2 UI Section

The C<ui> section configures the frontend or user interface. It includes these
parameters by default:

=over 4

=item type

Similar to the C<type> parameter under the C<data> section, this one sets the
name of the user interface module and will be translated to
C<Chirpy::UI::I<Name>>.

=item date_time_format

The string that describes the format in which to display a date along with the
time. This string is passed to the C<strftime> method of
L<the POSIX module|POSIX>.

=item date_format

Similar to the above, but for dates only.

=item time_format

Similar to the above, but for times only.

=item use_gmt

Set this parameter to 0 if you wish to display times in local time instead of
Greenwich Mean Time. For GMT, set it to 1.

=item quotes_per_page

The maximum number of quotes to display per page.

=item recent_news_items

How many news items to display on the home page.

=item moderation_queue_public

Set this to C<1> if you want to make the list of unmoderated quotes available to
the public. To hide the list from everybody except moderators, set it to 0.

=item tag_cloud_logarithmic

Set this to C<1> if you want to determine the tag cloud's font sizes using a
logarithmic algorithm instead of a linear one. Most people will probably prefer
this, as it gives better results if some of the tags are used extremely often.

=back

Apart from that, there are parameters specific to the user interface of your
choice. Please refer to its documentation for an explanation. If you use the
default user interface, L<WebApp|Chirpy::UI::WebApp>, you can find the
parameters in L<its documentation|Chirpy::UI::WebApp/CONFIGURATION>.

=head1 AUTHOR

Tim De Pauw E<lt>ceetee@users.sourceforge.netE<gt>

=head1 SEE ALSO

L<Chirpy::DataManager>, L<Chirpy::UI>, L<Chirpy::Configuration>,
L<Chirpy::Locale>, L<http://chirpy.sourceforge.net/>

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

package Chirpy;

require 5.008;

use strict;
use warnings;
require Exporter;

BEGIN {
	use vars qw($VERSION @EXPORT @ISA $DEBUG $hires_timing);
	$VERSION = '';
	@ISA = qw(Exporter);
	@EXPORT = qw(chirpy);
	eval 'use Time::HiRes qw//';
	$DEBUG = 0;
	$hires_timing = 1 unless ($@);
}

use constant PRODUCT_NAME => 'Chirpy!';
use constant VERSION_STRING => 'v0.4-svn';
use constant FULL_PRODUCT_NAME => PRODUCT_NAME . ' ' . VERSION_STRING;
use constant URL => 'http://chirpy.sourceforge.net/';

use Chirpy::Configuration;
use Chirpy::Locale;

use Chirpy::Quote;
use Chirpy::NewsItem;
use Chirpy::Account;
use Chirpy::Event;

use constant USER_LEVELS => [
	Chirpy::Account::USER_LEVEL_9,
	Chirpy::Account::USER_LEVEL_6,
	Chirpy::Account::USER_LEVEL_3
];

use Carp qw/croak confess/;

sub new {
	my ($class, $configuration_file, $dm_override) = @_;
	my $st = ($hires_timing ? Time::HiRes::time() : undef);
	my $self = bless {}, $class;
	$self->{'start_time'} = $st;
	$self->{'debug_events'} = [] if ($DEBUG && $hires_timing);
	unless (defined $configuration_file) {
		foreach my $file (qw(src/chirpy.ini chirpy.ini)) {
			next unless (-f $file);
			$configuration_file = $file;
			last;
		}
		Chirpy::die('No valid configuration file found')
			unless (defined $configuration_file);
	}
	$self->mark_debug_event('Load configuration');
	my $configuration = new Chirpy::Configuration(
		defined $configuration_file ? $configuration_file : 'chirpy.ini');
	$self->mark_debug_event('Configuration loaded');
	$self->{'configuration'} = $configuration;
	$self->mark_debug_event('Load locale');
	my $locale = new Chirpy::Locale($configuration->get('general', 'base_path')
		. '/locales/' . $configuration->get('general', 'locale') . '.ini');
	$self->mark_debug_event('Locale loaded');
	$self->{'locale'} = $locale;
	my $locale_version = $locale->get_target_version();
	Chirpy::die('Locale outdated: wanted target version ' . $Chirpy::VERSION
		. ', got ' . $locale_version)
			unless ($locale_version ge $Chirpy::VERSION);
	my $dm_type = defined $dm_override
		? $dm_override : $configuration->get('data', 'type');
	$self->{'data_manager_type'} = $dm_type;
	my $dm_params = $configuration->get_parameter_hash('data', $dm_type);
	$self->mark_debug_event('Create data manager');
	my $dm = &_create_data_manager($dm_type, $dm_params);
	$self->mark_debug_event('Data manager created');
	$self->{'data_manager'} = $dm;
	my $ui_type = $configuration->get('ui', 'type');
	$self->{'ui_type'} = $ui_type;
	return $self;
}

sub run {
	my $self = shift;
	my $configuration = $self->configuration();
	my $ui_type = $self->{'ui_type'};
	my $ui_params = $configuration->get_parameter_hash('ui', $ui_type);
	$self->mark_debug_event('Create user interface');
	$self->{'ui'} = &_create_ui($ui_type, $self, $ui_params);
	$self->mark_debug_event('User interface created');
	$self->{'ui'}->run();
}

sub chirpy {
	new Chirpy(@_)->run();
}

sub configuration {
	my $self = shift;
	return $self->{'configuration'};
}

sub locale {
	my $self = shift;
	return $self->{'locale'};
}

sub get_parameter {
	my ($self, $name) = @_;
	return $self->{'data_manager'}->get_parameter($name);
}

sub set_parameter {
	my ($self, $name, $value) = @_;
	$self->{'data_manager'}->set_parameter($name, $value);
}

sub user_level_name {
	my ($self, $id) = @_;
	$self->locale->get_string('user_level_' . $id);
}

sub user_levels {
	return @{USER_LEVELS()};
}

sub get_quotes {
	my ($self, $start, $count, $sort) = @_;
	$self->mark_debug_event('Request quotes');
	return $self->_data_manager()->get_quotes({
		'approved' => 1,
		'sort'     => (defined $sort ? $sort : [ [ 'id', 1 ] ]),
		'first'    => $start,
		'count'    => (defined $count ? $count : $self->quotes_per_page())
	});
}

sub approved_quote_count {
	my $self = shift;
	return $self->_data_manager()->quote_count({ 'approved' => 1 });
}

sub unapproved_quote_count {
	my $self = shift;
	return $self->_data_manager()->quote_count({ 'approved' => 0 });
}

sub total_quote_count {
	my $self = shift;
	return $self->_data_manager()->quote_count();
}

sub get_matching_quotes {
	my ($self, $start, $queries, $tags) = @_;
	return $self->_data_manager()->get_quotes({
		'approved' => 1,
		'contains' => $queries,
		'sort'     => [ [ 'id', 1 ] ],
		'first'    => $start,
		'count'    => $self->quotes_per_page(),
		'tags'     => $tags
	});
}

sub get_quotes_of_the_week {
	my ($self, $start) = @_;
	return $self->_data_manager()->get_quotes({
		'approved' => 1,
		'since'    => time - 7 * 24 * 60 * 60,
		'sort'     => [ [ 'id', 1 ] ],
		'first'    => $start,
		'count'    => $self->quotes_per_page()
	});
}

sub get_quote {
	my ($self, $id) = @_;
	return undef unless (defined $id);
	my $quotes = $self->_data_manager()->get_quotes({
		'id'       => $id
	});
	return undef unless (defined $quotes);
	return $quotes->[0];
}

sub get_random_quotes {
	my $self = shift;
	return $self->_data_manager()->get_quotes({
		'approved' => 1,
		'count'    => $self->quotes_per_page(),
		'random'   => 1
	});
}

sub get_prandom_quotes {
        my $self = shift;
        return $self->_data_manager()->get_quotes({
                'approved' => 1,
                'count'    => $self->quotes_per_page(),
                'random'   => 1,
                'prandom'  => 1
        });
}

sub get_top_quotes {
	my ($self, $start) = @_;
	my $cm = $self->quote_score_calculation_mode();
	return $self->_data_manager()->get_quotes({
		'approved' => 1,
		'sort'     => [ [ ($cm == 1 ? 'rating' : 'score'), 1 ], [ 'id', 1 ] ],
		'first'    => $start,
		'count'    => $self->quotes_per_page()
	});
}

sub get_bottom_quotes {
	my ($self, $start) = @_;
	my $cm = $self->quote_score_calculation_mode();
	return $self->_data_manager()->get_quotes({
		'approved' => 1,
		'sort'     => [ [ ($cm == 1 ? 'rating' : 'score'), 0 ], [ 'id', 1 ] ],
		'first'    => $start,
		'count'    => $self->quotes_per_page()
	});
}

sub get_flagged_quotes {
	my ($self, $start) = @_;
	return $self->_data_manager()->get_quotes({
		'flagged' => 1,
		'sort'    => [ [ 'id', 1 ] ],
		'first'    => $start,
		'count'    => (defined $start ? $self->quotes_per_page() : undef)
	});
}

sub get_unapproved_quotes {
	my ($self, $start) = @_;
	return $self->_data_manager()->get_quotes({
		'approved' => 0,
		'sort'     => [ [ 'id', 1 ] ],
		'first'    => $start,
		'count'    => (defined $start ? $self->quotes_per_page() : undef)
	});
}

sub add_quote {
	my ($self, $body, $notes, $approved, $tags) = @_;
	my $quote = new Chirpy::Quote(
		undef,
		$body,
		$notes,
		0,
		0,
		undef,
		$approved,
		0,
		$tags
	);
	$self->_data_manager()->add_quote($quote);
	return $quote;
}

sub modify_quote {
	my ($self, $quote, $text, $notes, $tags) = @_;
	Chirpy::die('Not a Chirpy::Quote')
		unless (ref $quote eq 'Chirpy::Quote');
	$quote->set_body(Chirpy::Util::clean_up_submission($text));
	$quote->set_notes($notes
		? Chirpy::Util::clean_up_submission($notes)
		: undef);
	$quote->set_tags($tags) if (defined $tags);
	return $self->_data_manager->modify_quote($quote);
}

sub remove_quotes {
	my ($self, @ids) = @_;
	return $self->_data_manager()->remove_quotes(@ids);
}

sub increase_quote_rating {
	my ($self, $id, $revert) = @_;
	return undef unless (defined $id);
	my ($rating, $votes) = $self->_data_manager()
		->increase_quote_rating($id, $revert);
	return ($rating, $votes);
}

sub decrease_quote_rating {
	my ($self, $id, $revert) = @_;
	return undef unless (defined $id);
	my ($rating, $votes) = $self->_data_manager()
		->decrease_quote_rating($id, $revert);
	return ($rating, $votes);
}

sub get_tag_use_counts {
	my $self = shift;
	return $self->_data_manager()->get_tag_use_counts();
}

sub flag_quotes {
	my ($self, @ids) = @_;
	return $self->_data_manager()->flag_quotes(@ids);
}

sub unflag_quotes {
	my ($self, @ids) = @_;
	return $self->_data_manager()->unflag_quotes(@ids);
}

sub approve_quotes {
	my ($self, @ids) = @_;
	return $self->_data_manager()->approve_quotes(@ids);
}

sub get_news_item {
	my ($self, $id) = @_;
	return undef unless (defined $id);
	my $items = $self->_data_manager()->get_news_items({ 'id' => $id });
	return (defined $items ? $items->[0] : undef);
}

sub get_latest_news_items {
	my $self = shift;
	return $self->_data_manager()->get_news_items(
		{ 'count' => $self->configuration()->get('ui', 'recent_news_items') });
}

sub add_news_item {
	my ($self, $text, $author) = @_;
	my $item = new Chirpy::NewsItem(
		undef,
		Chirpy::Util::clean_up_submission($text),
		$author
	);
	$self->_data_manager()->add_news_item($item);
	return $item;
}

sub modify_news_item {
	my ($self, $item, $text, $poster) = @_;
	Chirpy::die('Not a Chirpy::NewsItem')
		unless (ref $item eq 'Chirpy::NewsItem');
	$item->set_body($text);
	$item->set_poster($poster);
	return $self->_data_manager()->modify_news_item($item);
}

sub remove_news_items {
	my ($self, @ids) = @_;
	return $self->_data_manager()->remove_news_items(@ids);
}

sub get_accounts {
	my $self = shift;
	return $self->_data_manager()->get_accounts();
}

sub get_accounts_by_level {
	my ($self, @levels) = @_;
	return $self->_data_manager()->get_accounts({ 'levels' => \@levels });
}

sub get_account_by_id {
	my ($self, $id) = @_;
	return undef unless (defined $id);
	my $accounts = $self->_data_manager()->get_accounts({ 'id' => $id });
	return (defined $accounts ? $accounts->[0] : undef);
}

sub get_account_by_username {
	my ($self, $username) = @_;
	my $accounts = $self->_data_manager()->get_accounts(
		{ 'username' => $username });
	return (defined $accounts ? $accounts->[0] : undef);
}

sub account_count {
	my $self = shift;
	return $self->_data_manager()->account_count();
}

sub account_count_by_level {
	my ($self, $level) = @_;
	return $self->_data_manager()->account_count({ 'levels' => [ $level ] });
}

sub username_exists {
	my ($self, $username) = @_;
	return $self->_data_manager()->username_exists($username);
}

sub add_account {
	my ($self, $username, $password, $level) = @_;
	my $account = new Chirpy::Account(
		undef,
		$username,
		Chirpy::Util::encrypt($password, $self->salt()),
		$level
	);
	$self->_data_manager()->add_account($account);
	return $account;
}

sub modify_account {
	my ($self, $account, $username, $password, $level) = @_;
	Chirpy::die('Not a Chirpy::Account')
		unless (ref $account eq 'Chirpy::Account');
	if (defined $username) {
		Chirpy::die('Invalid username')
			unless (Chirpy::Util::valid_username($username));
		$account->set_username($username);
	}
	if (defined $password) {
		Chirpy::die('Invalid password')
			unless (Chirpy::Util::valid_password($password));
		$account->set_password(Chirpy::Util::encrypt($password, $self->salt()));
	}
	if (defined $level) {
		$account->set_level($level);
	}
	return $self->_data_manager()->modify_account($account);
}

sub remove_accounts {
	my ($self, @ids) = @_;
	return $self->_data_manager()->remove_accounts(@ids);
}

sub log_event {
	my ($self, $code, $user, $data) = @_;
	return $self->_data_manager()->log_event(
		new Chirpy::Event(undef, undef, $code, $user, $data)
	);
}

sub get_events {
	my ($self, $start, $count, $desc, $code, $user, $data) = @_;
	$self->mark_debug_event('Request events');
	return $self->_data_manager()->get_events({
		'reverse' => $desc,
		'first'   => $start,
		'count'   => $count,
		'code'    => $code,
		'user'    => $user,
		'data'    => $data
	});
}

sub attempt_login {
	my ($self, $username, $password) = @_;
	my $account = $self->get_account_by_username($username);
	return undef unless (defined $account);
	return ($account->get_password() eq
				Chirpy::Util::encrypt($password, $self->salt())
			|| $account->get_password() eq Chirpy::Util::encrypt($password)
		? $account : undef);
}

sub quotes_per_page {
	my ($self, $value) = @_;
	$self->{'quotes_per_page'} = $value if ($value);
	return $self->{'quotes_per_page'} if (defined $self->{'quotes_per_page'});
	return $self->configuration()->get('ui', 'quotes_per_page');
}

sub quote_score_calculation_mode {
	my $self = shift;
	my $mode = $self->configuration()->get('general',
		'quote_score_calculation_mode');
	return (defined $mode && $mode == 1 ? 1 : 0);
}

sub salt {
	my $self = shift;
	my $salt = $self->configuration()->get('general', 'salt');
	return (defined $salt ? $salt : 'cH1rPy!');
}

sub timing_enabled {
	return $hires_timing;
}

sub start_time {
	my $self = shift;
	return $self->{'start_time'};
}

sub total_time {
	my $self = shift;
	return ($hires_timing
		? Time::HiRes::time() - $self->{'start_time'}
		: undef);
}

sub set_up {
	my ($self, $accounts, $news, $quotes) = @_;
	$self->_data_manager()->set_up($accounts, $news, $quotes);
}

sub remove {
	my $self = shift;
	$self->_data_manager()->remove();
}

sub die {
	my $message = shift;
	$message = 'Unknown error' unless (defined $message);
	if ($DEBUG) {
		confess $message;
	}
	else {
		croak $message;
	}
}

sub mark_debug_event {
	my ($self, $event) = @_;
	if (exists $self->{'debug_events'}) {
		my $now = Time::HiRes::time();
		push @{$self->{'debug_events'}}, [ $now, $event ];
	}
}

sub debug_events {
	my $self = shift;
	return $self->{'debug_events'};
}

sub _data_manager {
	my $self = shift;
	return $self->{'data_manager'};
}

sub _create_data_manager {
	my ($type, $params) = @_;
	my $dm;
	eval qq{
		use Chirpy::DataManager::$type;
		\$dm = new Chirpy::DataManager::$type(\$params);
	};
	Chirpy::die('Failed to load data manager "' . $type . '": ' . $@)
		if ($@ || !defined $dm);
	&_check_version($dm);
	return $dm;
}

sub _create_ui {
	my ($type, $parent, $params) = @_;
	my $ui;
	eval qq{
		use Chirpy::UI::$type;
		\$ui = new Chirpy::UI::$type(\$parent, \$params);
	};
	Chirpy::die('Failed to load UI "' . $type . '": ' . $@)
		if ($@ || !defined $ui);
	&_check_version($ui);
	return $ui;
}

sub _check_version {
	my $obj = shift;
	my $version = (defined $obj ? $obj->get_target_version() : undef);
	Chirpy::die(ref($obj) . ' incompatible: wanted target version '
		. $Chirpy::VERSION . ', got ' . $version)
			unless ($version eq $Chirpy::VERSION);
}

1;

###############################################################################
