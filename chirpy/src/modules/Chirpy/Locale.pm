###############################################################################
# Chirpy! v0.3, a quote management system                                     #
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

Chirpy::Locale - Represents a locale

=head1 SYNOPSIS

 $locale = new Chirpy::Locale('/path/to/locale.ini');

 $value = $locale->get_string($name);
 $value = $locale->get_string($name, @params);

 $target_version = $locale->get_target_version();
 $full_name = $locale->get_full_name();
 $version = $locale->get_version();
 $author_hash_ref = $locale->get_author_information();

=head1 CREATING LOCALES

Locales are INI files with two sections, one with information about the locale
and one with the localized strings. It is recommended that you use the language
code as the filename, e.g. F<it.ini> for I<Italian> or F<fr-CA.ini> for
I<French/Canada>.

=head2 Information Section

Information about the locale is stored in the INI file's C<properties> section.
Locales use the following values for storing information about the locale:

=over 4

=item chirpy_version

The version of Chirpy! that the locale was made for.

=item full_name

The full name of the locale. Usually, this is the name of the locale language.

=item version

The version number of the locale. You can use any version number scheme you
like, but make sure people can distinguish between versions easily.

=item author_name

Your full name.

=item author_email

The e-mail address where people can contact you.

=item author_uri

The URL to your homepage, if any.

=back

=head2 Strings Section

The localized strings are stored in the INI file's C<strings> section. Mocales
must define the strings listed below. For examples, please consult
F<en-US.ini>, the I<U.S. English> locale, bundled with Chirpy! by default.

Note that locales may contain extra strings which are specific to a user
interface class. These must be prepended by the name of the class and a dot.
The default L<Chirpy::UI::WebApp|Chirpy::UI::WebApp> class requires a few
strings already, which are listed under
L<Locale Strings|Chirpy::UI::WebApp/LOCALE STRINGS> in its documentation.

=over 4

=item error_title

Title used for errors.

=item quote_browser

Translation of I<Quote Browser>, for the title of that section or links to it.

=item random_quotes

Translation of I<Random Quotes>, for the title of that section or links to it.

=item view_quote

Translation of I<View Quote>, for the title of that section or links to it.

=item top_quotes

Translation of I<Top Quotes>, for the title of that section or links to it.

=item bottom_quotes

Translation of I<Bottom Quotes>, for the title of that section or links to it.

=item quotes_of_the_week

Translation of I<Quotes of the Week>, for the title of that section or links to
it.

=item search_for_quotes

Translation of I<Search for Quotes>, for the title of that section or links to
it.

=item tag_cloud

Translation of I<Tag Cloud>, for the title of that section or links to it.

=item statistics

Translation of I<Statistics>, for the title of that section or links to it.

=item administration

Translation of I<Administration>, for the title of that section or links to it.

=item edit_quote

Translation of I<Edit Quote>, for the title of that section or links to it.

=item remove_quote

Translation of I<Remove Quote>, for the title of that section or links to it.

=item welcome

Generic translation of the string I<Welcome>.

=item latest_news

Translation of I<Latest News>, for the title of the list of recent news items.

=item unknown_action

Text describing that the action the user requested is unknown, for error
messages.

=item no_quotes

Text describing that there aren't any quotes to display.

=item quote_browser_description

Brief description of what the quote browser does, for tooltips and such.

=item quote_browser_short_title

Abbreviated version of I<Quote Browser>, for use in compact menus.

=item random_quotes_description

Brief description of what the list of random quotes does, for tooltips and
such.

=item random_quotes_short_title

Abbreviated version of I<Random Quotes>, for use in compact menus.

=item top_quotes_description

Brief description of what the list of top quotes does, for tooltips and such.

=item top_quotes_short_title

Abbreviated version of I<Top Quotes>, for use in compact menus.

=item bottom_quotes_description

Brief description of what the list of bottom quotes does, for tooltips and
such.

=item bottom_quotes_short_title

Abbreviated version of I<Bottom Quotes>, for use in compact menus.

=item quotes_of_the_week_description

Brief description of what the list of quotes of the week does, for tooltips and
such.

=item quotes_of_the_week_short_title

Abbreviated version of I<Quotes of the Week>, for use in compact menus.

=item quote_search_description

Brief description of what the quote search does, for tooltips and such.

=item quote_search_short_title

Abbreviated version of I<Quote Search>, for use in compact menus.

=item tag_cloud_description

Brief description of what the tag cloud is, for tooltips and such.

=item tag_cloud_short_title

Abbreviated version of I<Tag Cloud>, for use in compact menus.

=item statistics_description

Brief description of what the statistics do, for tooltips and such.

=item submit_quote_description

Brief description of what the quote submission interface does, for tooltips
and such.

=item submit_quote_short_title

Abbreviated version of I<Submit Quote>, for use in compact menus.

=item administration_description

Brief description of what the administration interface does, for tooltips and
such.

=item administration_short_title

Abbreviated version of I<Administration>, for use in compact menus.

=item login_description

Brief description of what the login interface does, for tooltips and such.

=item login_short_title

Abbreviated version of I<Log In>, for use in compact menus.

=item logout_description

Brief description of what the logout interface does, for tooltips and such.

=item logout_short_title

Abbreviated version of I<Log Out>, for use in compact menus.

=item quote_report_description

Brief description of what reporting quotes is, for tooltips and such.

=item quote_rating_up_description

Brief description of what increasing a quote's rating is, for tooltips and
such.

=item quote_rating_down_description

Brief description of what decreasing a quote's rating is, for tooltips and
such.

=item quote_rating_description

Brief description of what the quote's rating is, for tooltips and such.

=item quote_date_description

Brief description of what the date when the quote was submitted is, for
tooltips and such.

=item quote_edit_description

Brief description of what editing the quote does, for tooltips and such.

=item quote_remove_description

Brief description of what removing the quote does, for tooltips and such.

=item quote_notes_title

Title of the notes section in the quote list, followed by a colon.

=item quote_tags_title

Title of the tags section in the quote list, followed by a colon.

=item no_tagged_quotes

Message displayed instead of the tag cloud when no quotes have been tagged.

=item statistics_unavailable

Generic message, displayed when statistics are unavailable. Usually, this means
there are no quotes in the database, but this may change.

=item statistics_short_title

Abbreviated version of I<Statistics>, for use in compact menus.

=item quote_count_by_date

Title of the I<Number of Quotes by Date> section in the statistics.

=item quote_count_by_year_month

Title of the I<Number of Quotes by Year and Month> section in the statistics.

=item quote_count_by_hour

Title of the I<Number of Quotes by Hour> section in the statistics.

=item quote_count_by_month

Title of the I<Number of Quotes by Month> section in the statistics.

=item quote_count_by_day

Title of the I<Number of Quotes by Day of the Month> section in the statistics.

=item quote_count_by_week_day

Title of the I<Number of Quotes by Week Day> section in the statistics.

=item tag_link_description

Description text for the link to the list of quotes with the current tag.
C<%1%> is replaced with the tag.

=item search_query_title

Title of the query field on the search interface, followed by a colon.

=item search_button_label

Label text for the button that initiates searches.

=item search_results

Translation of I<Search Results>, for the title of that section or links to it.

=item submit_quote

Translation of I<Submit Quote>, for the title of that section or links to it.

=item submission_title

Directions telling the user to enter his quote in the input field that follows
the text.

=item notes_title

Directions telling the user to optionally enter notes about the quote in the
input field that follows the text.

=item submit_button_label

Label text for the button that submits the newly entered quote.

=item submit_button_label_no_approval

Label text for the button that submits the newly entered quote, suggesting that
the quote will be immediately added without approval, since the user has that
privilege.

=item quote_submitted

Title for the interface stating that the quote has been submitted.

=item quote_submitted_no_approval

Title for the interface stating that the quote has been submitted and approval
is not necessary. Something like I<Quote Added> is appropriate.

=item quote_submission_thanks

Message thanking the user for the submitted quote and explaining that it will
now be reviewed before it is added.

=item quote_submission_thanks_no_approval

Message thanking the user for the submitted quote and explaining that it has
been added without the need for approval.

=item approve_quotes

Translation of I<Approve Quotes>, for titles and labels in the administrative
interface.

=item flagged_quotes

Translation of I<Flagged Quotes>, for titles and labels in the administrative
interface.

=item manage_news

Translation of I<Manage News>, for titles and labels in the administrative
interface.

=item manage_quotes

Translation of I<Manage Quotes>, for titles and labels in the administrative
interface.

=item add_news

Translation of I<Add News>, for titles and labels in the administrative
interface.

=item edit_news

Translation of I<Edit News>, for titles and labels in the administrative
interface.

=item remove_news

Translation of I<Remove News>, for titles and labels in the administrative
interface.

=item manage_accounts

Translation of I<Manage Accounts>, for titles and labels in the administrative
interface.

=item no_unapproved_quotes

Message describing that there are currently no quotes waiting for approval.

=item no_flagged_quotes

Message describing that there are currently no quotes that are flagged.

=item quote_rating_up_short_title

Short label text for the link that increases the quote's rating, e.g. I<Up>.

=item quote_rating_down_short_title

Short label text for the link that decreases the quote's rating, e.g. I<Down>.

=item report_quote_short_title

Short label text for the link that reports the quote, e.g. I<Report>.

=item edit

Generic translation of I<Edit>, which can be used for links to edit quotes,
news items, etc.

=item remove

Generic translation of I<Remove>, which can be used for links to remove quotes,
news items, etc.

=item unflag

Text for the link that removes the report for the quote.

=item flagged

Text that indicates that the quote has been reported in the past.

=item quote_removal_confirmation

Question that asks the user if he is sure that he would like to remove the
quote.

=item news_removal_confirmation

Question that asks the user if he is sure that he would like to remove the news
item.

=item quote_rating_increased

Title for the interface stating that the quote's rating has been increased.

=item quote_rating_decreased

Title for the interface stating that the quote's rating has been decreased.

=item quote_rating_thanks

Message confirming that the user's vote has been processed, used for both
positive and negative votes.

=item quote_reported

Title for the interface stating that the quote has been reported.

=item quote_report_thanks

Message confirming that the quote has been reported.

=item quote_already_rated

Error message stating that the user can only rate the same quote once per
session and that he has already rated the selected quote.

=item quote_rating_limit_exceeded

Error message stating that the user has exceeded the maximum number of votes
allowed. C<%1%> is replaced with the maximum number of votes, C<%2%> with the
number of seconds in the time frame for that maximum.

=item login_title

Title of the login interface.

=item invalid_login_title

Title of the interface stating that logging in has failed.

=item username_title

Title of the field where the user inputs his username, followed by a colon.

=item password_title

Title of the field where the user inputs his password, followed by a colon.

=item login_button_label

Label of the button that submits the login information the user has entered.

=item invalid_login_instructions

Error message stating that the credentials the user has entered are incorrect,
with the additional information that the password is case-sensitive, while the
username is not.

=item logged_in_as

Message stating that the user is logged in. C<%1%> is replaced with the user's
username, C<%2%> with his user level.

=item change_password

Translation of I<Change Password>, for titles and labels in the administrative
interface.

=item error

Generic translation of the string I<Error>.

=item processing

Generic translation of the string I<Processing>, used for operations that may
take a while.

=item timed_out

Generic translation of the string I<Timed Out>, used for operations that have
failed to complete.

=item no_search_results

Title of the interface stating that there are no search results.

=item no_search_results_text

Message explaining that none of the quotes match the search query.

=item quote_not_found

Title of the interface stating that the requested quote was not found.

=item quote_not_found_text

Message explaining that the quote ID the user has provided does not exist.

=item rated_quote_not_found_text

Message explaining that the quote the user is trying to rate does not exist.

=item reported_quote_not_found_text

Message explaining that the quote the user is trying to report does not exist.

=item user_level_3

Title of the user level with numeric ID 3.

=item user_level_6

Title of the user level with numeric ID 6.

=item user_level_9

Title of the user level with numeric ID 9.

=item password_changed

Title of the interface stating that the user's password has been changed.

=item password_changed_text

Message stating that the user's password has been changed, reminding him to
keep it in a safe place.

=item current_password_title

Title of the field where the user inputs his current password, followed by a
colon.

=item new_password_title

Title of the field where the user inputs his new password, followed by a colon.

=item repeat_new_password_title

Title of the field where the user inputs his new password again for
verification, followed by a colon.

=item change_password_button_label

Label of the button that submits the user's new password.

=item change_password_current_password_invalid_text

Error message stating that the user failed to enter his current password.

=item change_password_new_password_invalid_text

Error message stating that the new password the user has entered is invalid.

=item change_password_passwords_differ_text

Error message stating that the new password the user has entered does not match
the verification entry.

=item do_nothing

Generic translation of the string I<Do Nothing>, useful for the quote approval
and report review interfaces.

=item approve_unapproved_quote

Text for the option that approves the new quote in the approval interface.

=item discard_unapproved_quote

Text for the option that removes the new quote in the approval interface.

=item update_database

Generic translation of the string I<Update Database>, useful for the quote
approval and report review interfaces.

=item reset_form

Generic translation of the string I<Reset Form>, useful for various form-based
interfaces.

=item keep_flagged_quote

Text for the option that keeps the flagged quote in the report review
interface.

=item remove_flagged_quote

Text for the option that removes the flagged quote in the report review
interface.

=item quote_removed

Text confirming that the selected quote has been removed.

=item quote_to_edit_not_found

Error message stating that the quote the user tried to edit could not be found.

=item quote_to_remove_not_found

Error message stating that the quote the user tried to remove could not be
found.

=item quote_modified

Message confirming that the user's modifications to the quote have been saved.

=item quote_id_title

Title text for a quote ID input field, followed by a colon.

=item save_quote

Label text for the button that saves modifications to the quote.

=item go

Generic translation of the string I<Go>.

=item news_item_added

Message confirming that the submitted news item has been added.

=item news_item_modified

Message confirming that the modifications to the news item have been saved.

=item news_item_to_edit_not_found

Error message stating that the news item the user tried to edit was not found.

=item news_item_removed

Message confirming that the news item has been removed.

=item news_item_to_remove_not_found

Error message stating that the news item the user tried to remove was not
found.

=item new_news_item_title

Title text for the new news item input field, followed by a colon.

=item add_news_item

Label text for the button that adds the newly entered news item.

=item news_poster_title

Title text for the poster selection field upon modification of a news item,
followed by a colon.

=item save_news_item

Label text for the button that saves modifications to a news item.

=item account_to_modify_not_found

Error message stating that the account the user tried to modify could not be
found.

=item account_to_remove_not_found

Error message stating that the account the user tried to remove could not be
found.

=item last_owner_account_removal_error

Error message stating that there must be at least one account with the maximum
user level, and therefore, the selected account cannot be removed.

=item modified_account_information_required

Error message stating that the user failed to enter any updated account
information for the selected account.

=item invalid_username

Error message stating the username the user has entered is invalid.

=item username_exists

Error message stating the username the user has entered already exists.

=item invalid_password

Error message stating the password the user has entered is invalid.

=item different_passwords

Error message stating the password and confirmation the user has entered are
not equal.

=item invalid_user_level

Error message stating the user level the user has selected is invalid.

=item account_removed

Message confirming that the account has been removed.

=item account_modified

Message confirming that the account has been modified.

=item account_created

Message confirming that the account has been created.

=item new_account

Generic translation of the string I<New Account>.

=item new_username_title

Title for the field where the user enters the username for the account he is
adding, followed by a colon.

=item new_password_title

Title for the field where the user enters the password for the account he is
adding, followed by a colon.

=item repeat_new_password_title

Title for the field where the user enters the password for the account he is
adding again for confirmation, followed by a colon.

=item new_user_level_title

Title for the field where the user selects the user level for the account he is
adding, followed by a colon.

=item update_accounts

Label for the button that processes changes to the account overview.

=item remove_account

Label for the button that removes the selected account.

=item no_change

Generic translation of the string I<No Change>.

=item unknown

Generic translation of the string I<Unknown>.

=item account_removal_confirmation

Question confirming that the user is sure he wishes to remove the selected
account.

=item insufficient_administrative_privileges

Error message displayed when the user attempts to access an administration
interface he is not allowed to use.

=item update_available

Title for the message indicating that a new version of Chirpy! is available.

=item update_available_text

Text giving basic information about a Chirpy! update. C<%1%> is replaced with
the version number C<%2%> with the release date.

=item update_link_text

Text for a link to an available update. Usually something along the lines of
"Click here for more information."

=item update_check_failed

Title for the message indicating that checking for updates has failed.

=item update_check_failed_text

Message explaining that Chirpy! failed to check for updates, and indicating
that an error report follows.

=item sunday

=item monday

=item tuesday

=item wednesday

=item thursday

=item friday

=item saturday

The full names of the days of the week.

=item january

=item february

=item march

=item april

=item may

=item june

=item july

=item august

=item september

=item october

=item november

=item december

The full names of the months of the year.

=item january_short

=item february_short

=item march_short

=item april_short

=item may_short

=item june_short

=item july_short

=item august_short

=item september_short

=item october_short

=item november_short

=item december_short

The names of the months of the year, abbreviated however feels natural.

=back

=head1 TODO

The list of strings needs some organization and some of the identifier names
should probably be revised. Sorry for the inconvenience.

=head1 AUTHOR

Tim De Pauw E<lt>ceetee@users.sourceforge.netE<gt>

=head1 SEE ALSO

L<Chirpy::Util::IniFile>, L<Chirpy>,
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

package Chirpy::Locale;

use strict;
use warnings;

use vars qw($VERSION @ISA);

$VERSION = '0.3';
@ISA = qw(Chirpy::Util::IniFile);

use Chirpy 0.3;
use Chirpy::Util::IniFile 0.3;

sub new {
	my ($class, $file) = @_;
	return $class->SUPER::new($file);
}

sub get_string {
	my ($self, $name, @vars) = @_;
	my $string = $self->SUPER::get('strings', $name) or return '';
	$string =~ s/\%(\d+)\%/$vars[$1 - 1] || ''/eg;
	return $string;
}

sub get_target_version {
	my $self = shift;
	return $self->get('properties', 'chirpy_version');
}

sub get_full_name {
	my $self = shift;
	return $self->get('properties', 'full_name');
}

sub get_version {
	my $self = shift;
	return $self->get('properties', 'version');
}

sub	get_author_information {
	my $self = shift;
	return {
		'name' => $self->get('properties', 'author_name'),
		'email' => $self->get('properties', 'author_email'),
		'uri' => $self->get('properties', 'author_uri')
	};
}

1;

###############################################################################