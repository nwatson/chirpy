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

Chirpy::DataManager - Abstract data manager class

=head1 IMPLEMENTATION

This section should tell you just about everything you need to know if you want
to write your own Chirpy! data manager.

First of all, it must be a class that extends this abstract class, and it must
have something along the lines of

  use vars qw($VERSION @ISA);
  $VERSION = '0.2';
  @ISA = qw(Chirpy::DataManager);

All you need to do then, really, is implement this class's abstract methods.
Unfortunately, there are quite a few of them. However, a lot of them are fairly
trivial, as you will quickly learn. All of them are object methods.

=head2 Compatibility

=over 4

=item get_target_version()

The return value of this function is compared to Chirpy!'s version. If the
version numbers do not match, execution will be aborted. Hence, it needs to be
exactly the same as the version of Chirpy! the data manager was built for.

=back

=head2 Parameters

=over 4

=item get_parameter($name)

Gets the value of a persistent parameter.

=item set_parameter($name, $value)

Sets the value of a persistent parameter.

=back

=head2 Installation & Removal

=over 4

=item set_up($accounts, $news, $quotes)

Called at installation time, this method should create all necessary resources
to use the data manager. For instance, if the module uses a database, this
method should create the necessary tables in it.

In addition, the method takes 3 arguments, each either an array reference or
C<undef>. They represent the initial data to be stored in the installation.
C<$accounts> holds instances of L<Chirpy::Account>, C<$news> instances of
L<Chirpy::NewsItem> and C<$quotes> instances of L<Chirpy::Quote>.

=item remove()

The exact opposite of the C<set_up()> method. Removes all applicable data.

=back

=head2 Quotes

=over 4

=item get_quotes($options)

Accepts C<$options>, a reference to a hash containing parameters defining the
output, or C<undef>.

In a scalar context, returns a reference to an array of matching quotes (as
instances of L<Chirpy::Quote>), or C<undef> if there are no matches. Otherwise,
returns that array, along with 2 boolean values. The first is true if there
are quotes I<before> the start of the results, the second is true if there are
quotes I<after> the end of the results.

The option hash may contain any of the keys below. If multiple keys are
present, the properties they imply must I<all> apply to the resulting quotes.

=over 8

=item id

ID of the quote to retrieve.

=item contains

Reference to an array of strings to find in either the quote body or notes.

=item tags

Reference to an array of tags, any of which must be a tag of the quote.

=item approved

Boolean value indicating the I<approved> status of the quote. Note that a false
value implies that the quotes must not be approved, while C<undef> cannot
affect the results.

=item flagged

Boolean value indicating the I<flagged> status of the quote. Note that a false
value implies that the quotes must not be flagged, while C<undef> cannot
affect the results.

=item since

UNIX timestamp representing the earliest date allowed for the date when quotes
were submitted.

=item sort

Properties of the quote to sort on, represented as a two-dimensional array
reference. Here is an example:

 [ [ 'rating', 0 ], [ 'id', 1 ] ]

The boolean value is true if the results should be in descending order. Hence,
the sorting instruction above means the data manager should sort by rating
first, in ascending order. If the ratings are equal, then it should sort by ID,
in descending order.

The possible properties to sort on are C<id>, C<rating>, C<approved> and
C<flagged>. It is assumed that sorting on the date when the quote was submitted
has the same effect as sorting on quote ID.

=item random

Boolean value indicating if results should be randomly selected. Overrides the
"sort" option.

=item first

The number of the first result to return, 0 being the first in the result list.

=item count

The number of quotes to maximally return.

=back

=item quote_count($options)

Returns the number of quotes in the database, either approved, unapproved, or
both. Optionally accepts C<$options>, a reference to a hash of parameters
defining which quotes are to be counted. Currently, C<$options> may contain only
one parameter, namely C<approved>. If C<approved> is undefined, all quotes are
included in the count; if it is a true value, only approved quotes are included,
and vice versa.

=item add_quote($quote)

Adds the L<Chirpy::Quote|Chirpy::Quote> C<$quote> to the collection. Returns
the quote's newly assigned ID.

The properties to be saved by this method are I<body>, I<notes>, I<approved>
and I<tags>.

=item modify_quote($quote)

Updates the L<Chirpy::Quote|Chirpy::Quote> C<$quote> in the collection. Returns
a true value on success.

The properties to be saved by this method are I<body> and I<notes>.

=item remove_quote($quote)

Removes the L<Chirpy::Quote|Chirpy::Quote> C<$quote> from the collection.
Returns a true value on success.

=item remove_quotes(@ids)

Removes all quotes whose ID is in C<@ids> from the collection. Returns the
number of removed quotes.

=item increase_quote_rating($id)

Increases the rating of quote number C<$id> by 1. Returns the new rating.

=item decrease_quote_rating($id)

Decreases the rating of quote number C<$id> by 1. Returns the new rating.

=item get_tag_use_counts()

Returns a reference to a hash, mapping tags to the number of times they were
used.

=item approve_quotes(@ids)

Sets the quotes associated with an ID in C<@ids> to I<approved>. Returns the
number of affected quotes.

=item unflag_quotes(@ids)

Sets the quotes associated with an ID in C<@ids> to I<unflagged>. Returns the
number of affected quotes.

=back

=head2 News Items

=over 4

=item get_news_items($options)

Retrieves news items, a lot like L<get_quotes()|/get_quotes($options)>
retrieves quotes. The possible options are now:

=over 8

=item id

ID of the news item to retrieve.

=item count

Maximum number of news items returned.

=back

Resulting news items are always sorted by date, newest first.

The function returns a reference to an array of instances of
L<Chirpy::NewsItem>, or C<undef> if no matching news items were found.

=item add_news_item($news_item)

Adds the L<Chirpy::NewsItem|Chirpy::NewsItem> C<$news_item> to the collection.
Returns the news item's newly assigned ID.

The properties to be saved by this method are I<body> and I<poster>. I<poster>
may be C<undef> if the poster is unknown.

=item modify_news_item($news_item)

Updates the L<Chirpy::NewsItem|Chirpy::NewsItem> C<$news_item> in the
collection. Returns a true value on success.

The properties to be saved by this method are I<body> and I<poster>. I<poster>
may be C<undef> if the poster is unknown.

=item remove_news_item($news_item)

Removes the L<Chirpy::NewsItem|Chirpy::NewsItem> C<$news_item> from the
collection. Returns a true value on success.

=item remove_news_items(@ids)

Removes all news items whose ID is in C<@ids> from the collection. Returns the
number of removed news items.

=back

=head2 User Accounts

=over 4

=item get_accounts($options)

Retrieves accounts, a lot like L<get_quotes()|/get_quotes($options)> retrieves
quotes and L<get_news_items()|/get_news_items($options)> retrieves news items.
The possible options are now:

=over 8

=item id

ID of the account to retrieve.

=item username

User name of the account to retrieve.

=item levels

Reference to an array containing allowed user levels.

=back

Resulting accounts are always sorted by user level, highest first, then by user
name.

The function returns a reference to an array of instances of
L<Chirpy::Account>, or C<undef> if no matching accounts were found.

=item add_account($account)

Adds the L<Chirpy::Account|Chirpy::Account> C<$account> to the collection.
Returns the account's newly assigned ID.

The properties to be saved by this method are I<username>, I<password> and
I<level>.

=item modify_account($account)

Updates the L<Chirpy::Account|Chirpy::Account> C<$account> in the collection.
Returns a true value on success.

The properties to be saved by this method are I<username>, I<password> and
I<level>.

=item remove_account($account)

Removes the L<Chirpy::Account|Chirpy::Account> C<$account> from the collection.
Returns a true value on success.

Note that upon removal of an account, news items associated with it must be
kept, but their author becomes unknown.

=item remove_accounts(@ids)

Removes all accounts whose ID is in C<@ids> from the collection. Returns the
number of removed accounts.

Note that upon removal of an account, news items associated with it must be
kept, but their author becomes unknown.

=item username_exists($username)

Returns a true value if the given username exists in the collection.

=item account_count($params)

Returns the current number of accounts. Takes an optional hash reference to
retrieval options. For now, it can only contain the key C<levels>, whose value
is a reference to an array of user levels. If this key is set, the function
returns the number of accounts with any of those levels.

=back

=head2 Logging

=over 4

=item log_event($event)

Logs the L<Chirpy::Event|Chirpy::Event> C<$event>. Returns a true value on
success.

The properties to be saved by this method are I<code>, I<user> and I<data>.

=back

=head2 Sessions

I<This step is optional.>

In addition, you may want to provide compatibility with
L<Chirpy::UI::WebApp|Chirpy::UI::WebApp>'s session manager by making your data
manager class extend L<Chirpy::UI::WebApp::Session::DataManager> as well.
Please check L<its documentation|Chirpy::UI::WebApp::Session::DataManager> for
instructions.

=head1 AUTHOR

Tim De Pauw E<lt>ceetee@users.sourceforge.netE<gt>

=head1 SEE ALSO

L<Chirpy::Quote>, L<Chirpy::NewsItem>, L<Chirpy::Account>, L<Chirpy::Event>,
L<Chirpy::DataManager::MySQL>, L<Chirpy::UI::WebApp::Session::DataManager>,
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

package Chirpy::DataManager;

use strict;
use warnings;

use vars qw($VERSION);

$VERSION = '0.2';

use Chirpy::Util 0.2;

sub new {
	my ($class, $params) = @_;
	return bless {
		'params' => $params
	}, $class;
}

sub param {
	my ($self, $name) = @_;
	return defined $self->{'params'} ? $self->{'params'}{$name} : undef;
}

*get_target_version = \&Chirpy::Util::abstract_method;

*set_up = \&Chirpy::Util::abstract_method;

*remove = \&Chirpy::Util::abstract_method;

*get_quote = \&Chirpy::Util::abstract_method;

*quote_count = \&Chirpy::Util::abstract_method;

*get_quotes = \&Chirpy::Util::abstract_method;

*add_quote = \&Chirpy::Util::abstract_method;

*modify_quote = \&Chirpy::Util::abstract_method;

*increase_quote_rating = \&Chirpy::Util::abstract_method;

*decrease_quote_rating = \&Chirpy::Util::abstract_method;

*get_tag_use_counts = \&Chirpy::Util::abstract_method;

*approve_quotes = \&Chirpy::Util::abstract_method;

*flag_quotes = \&Chirpy::Util::abstract_method;

*unflag_quotes = \&Chirpy::Util::abstract_method;

*remove_quote = \&Chirpy::Util::abstract_method;

*remove_quotes = \&Chirpy::Util::abstract_method;

*get_news_items = \&Chirpy::Util::abstract_method;

*add_news_item = \&Chirpy::Util::abstract_method;

*modify_news_item = \&Chirpy::Util::abstract_method;

*remove_news_item = \&Chirpy::Util::abstract_method;

*remove_news_items = \&Chirpy::Util::abstract_method;

*get_accounts = \&Chirpy::Util::abstract_method;

*add_account = \&Chirpy::Util::abstract_method;

*modify_account = \&Chirpy::Util::abstract_method;

*remove_account = \&Chirpy::Util::abstract_method;

*remove_accounts = \&Chirpy::Util::abstract_method;

*username_exists = \&Chirpy::Util::abstract_method;

*account_count = \&Chirpy::Util::abstract_method;

*log_event = \&Chirpy::Util::abstract_method;

*get_parameter = \&Chirpy::Util::abstract_method;

*set_parameter = \&Chirpy::Util::abstract_method;

1;

###############################################################################