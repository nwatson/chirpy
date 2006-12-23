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

Chirpy::UI - Abstract user interface class

=head1 TODO

A detailed description of this module's API will be available in a future
release. If you want to write your own user interface implementation, you could
try analyzing the source code of this module and its only implementation so
far, L<Chirpy::UI::WebApp>. I apologize for the inconvenience.

=head1 AUTHOR

Tim De Pauw E<lt>ceetee@users.sourceforge.netE<gt>

=head1 SEE ALSO

L<Chirpy::UI::WebApp>, L<Chirpy>, L<http://chirpy.sourceforge.net/>

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

package Chirpy::UI;

use strict;
use warnings;

use vars qw($VERSION);

$VERSION = '';

use Chirpy;
use Chirpy::Util;
use Chirpy::UpdateChecker;

use constant START_PAGE               =>  1;
use constant QUOTE_BROWSER            =>  2;
use constant SINGLE_QUOTE             =>  3;
use constant RANDOM_QUOTES            =>  4;
use constant TOP_QUOTES               =>  5;
use constant BOTTOM_QUOTES            =>  6;
use constant QUOTES_OF_THE_WEEK       =>  7;
use constant QUOTE_SEARCH             =>  8;
use constant TAG_CLOUD                =>  9;
use constant STATISTICS               => 10;
use constant SUBMIT_QUOTE             => 11;
use constant QUOTE_RATING_UP          => 12;
use constant QUOTE_RATING_DOWN        => 13;
use constant REPORT_QUOTE             => 14;
use constant LOGIN                    => 15;
use constant LOGOUT                   => 16;
use constant ADMINISTRATION           => 17;
use constant MODERATION_QUEUE         => 18;

use constant CHANGE_PASSWORD          => 100;
use constant MANAGE_UNAPPROVED_QUOTES => 110;
use constant MANAGE_FLAGGED_QUOTES    => 120;
use constant EDIT_QUOTE               => 130;
use constant REMOVE_QUOTE             => 131;
use constant ADD_NEWS                 => 140;
use constant EDIT_NEWS                => 141;
use constant REMOVE_NEWS              => 142;
use constant ADD_ACCOUNT              => 150;
use constant EDIT_ACCOUNT             => 151;
use constant REMOVE_ACCOUNT           => 152;
use constant CHECK_FOR_UPDATE         => 160;
use constant VIEW_EVENT_LOG           => 170;

use constant CURRENT_PASSWORD_INVALID => -1;
use constant NEW_PASSWORD_INVALID     => -2;
use constant PASSWORDS_DIFFER         => -3;

# TODO: make this easily configurable one day
use constant ADMIN_PERMISSIONS => {
	MANAGE_UNAPPROVED_QUOTES() => {
		Chirpy::Account::USER_LEVEL_3 => 1,
		Chirpy::Account::USER_LEVEL_6 => 1,
		Chirpy::Account::USER_LEVEL_9 => 1
	},
	MANAGE_FLAGGED_QUOTES() => {
		Chirpy::Account::USER_LEVEL_6 => 1,
		Chirpy::Account::USER_LEVEL_9 => 1
	},
	EDIT_QUOTE() => {
		Chirpy::Account::USER_LEVEL_6 => 1,
		Chirpy::Account::USER_LEVEL_9 => 1
	},
	REMOVE_QUOTE() => {
		Chirpy::Account::USER_LEVEL_6 => 1,
		Chirpy::Account::USER_LEVEL_9 => 1
	},
	ADD_NEWS() => {
		Chirpy::Account::USER_LEVEL_6 => 1,
		Chirpy::Account::USER_LEVEL_9 => 1
	},
	EDIT_NEWS() => {
		Chirpy::Account::USER_LEVEL_6 => 1,
		Chirpy::Account::USER_LEVEL_9 => 1
	},
	REMOVE_NEWS() => {
		Chirpy::Account::USER_LEVEL_6 => 1,
		Chirpy::Account::USER_LEVEL_9 => 1
	},
	VIEW_EVENT_LOG() => {
		Chirpy::Account::USER_LEVEL_9 => 1
	},
	ADD_ACCOUNT() => {
		Chirpy::Account::USER_LEVEL_9 => 1
	},
	EDIT_ACCOUNT() => {
		Chirpy::Account::USER_LEVEL_9 => 1
	},
	REMOVE_ACCOUNT() => {
		Chirpy::Account::USER_LEVEL_9 => 1
	},
	CHECK_FOR_UPDATE() => {
		Chirpy::Account::USER_LEVEL_9 => 1
	}
};

use constant STATISTICS_UPDATE_INTERVAL => 60 * 60;
use constant UPDATE_CHECK_INTERVAL => 7 * 24 * 60 * 60;

sub new {
	my ($class, $parent, $params) = @_;
	return bless {
		'parent' => $parent,
		'params' => $params
	}, $class;
}

sub run {
	my $self = shift;
	my $page = $self->get_current_page();
	if ($page == START_PAGE) {
		$self->welcome_user(
			$self->parent()->get_latest_news_items()
		);
	}
	elsif ($page == QUOTE_BROWSER) {
		my $start = $self->get_first_quote_index();
		$self->_browse_quotes_segmented(
			$page,
			$start,
			$self->parent()->get_quotes($start)
		);
	}
	elsif ($page == QUOTES_OF_THE_WEEK) {
		my $start = $self->get_first_quote_index();
		$self->_browse_quotes_segmented(
			$page,
			$start,
			$self->parent()->get_quotes_of_the_week($start),
		);
	}
	elsif ($page == QUOTE_SEARCH) {
		my $start = $self->get_first_quote_index();
		my ($queries, $tags) = $self->get_search_instruction();
		if (@$queries || @$tags) {
			$self->_browse_quotes_segmented(
				$page,
				$start,
				$self->parent()->get_matching_quotes($start, $queries, $tags)
			);
		}
		else {
			$self->provide_quote_search_interface();
		}
	}
	elsif ($page == SINGLE_QUOTE) {
		my $quote = $self->parent()->get_quote(
			$self->get_selected_quote_id());
		if (defined $quote && ($quote->is_approved() || $self->moderation_queue_is_public())) {
			$self->browse_quotes([ $quote ], $page);
		}
		else {
			$self->report_inexistent_quote();
		}
	}
	elsif ($page == RANDOM_QUOTES) {
		my $quotes = $self->parent()->get_random_quotes();
		(defined $quotes
			? $self->browse_quotes($quotes, $page)
			: $self->report_no_quotes_to_display($page));
	}
	elsif ($page == TOP_QUOTES) {
		my $start = $self->get_first_quote_index();
		$self->_browse_quotes_segmented(
			$page,
			$start,
			$self->parent()->get_top_quotes($start),
		);
	}
	elsif ($page == BOTTOM_QUOTES) {
		my $start = $self->get_first_quote_index();
		$self->_browse_quotes_segmented(
			$page,
			$start,
			$self->parent()->get_bottom_quotes($start),
		);
	}
	elsif ($page == MODERATION_QUEUE) {
		if ($self->moderation_queue_is_public()) {
			my $start = $self->get_first_quote_index();
			$self->_browse_quotes_segmented(
				$page,
				$start,
				$self->parent()->get_unapproved_quotes($start),
			);
		}
		else {
			$self->report_unknown_action();
		}
	}
	elsif ($page == SUBMIT_QUOTE) {
		my ($body, $notes, $tags) = $self->get_submitted_quote();
		if (defined $body && $body) {
			my $approved
				= $self->administration_allowed(Chirpy::UI::MANAGE_UNAPPROVED_QUOTES);
			$body = Chirpy::Util::clean_up_submission($body);
			$notes = (defined $notes
				? Chirpy::Util::clean_up_submission($notes)
				: undef);
			$tags = Chirpy::Util::parse_tags($tags);
			my $quote = $self->parent()->add_quote(
				$body,
				$notes,
				$approved,
				$tags
			);
			$self->confirm_quote_submission($approved);
			my $id = $quote->get_id();
			$self->_log_event(Chirpy::Event::ADD_QUOTE, {
				'id' => $id,
				'body' => $body,
				(defined $notes && length($notes) ? ('notes' => $notes) : ()),
				(@$tags ? ('tags' => join(' ', sort @$tags)) : ())
			});
			if ($approved) {
				$self->_log_event(Chirpy::Event::APPROVE_QUOTE,
					{ 'id' => $id });
			}
		}
		else {
			$self->provide_quote_submission_interface();
		}
	}
	elsif ($page == QUOTE_RATING_UP || $page == QUOTE_RATING_DOWN) {
		my $up = ($page == QUOTE_RATING_UP);
		my $id = $self->get_selected_quote_id();
		my $quote = $self->parent()->get_quote($id);
		if (defined $quote
		&& ($quote->is_approved() || $self->moderation_queue_is_public())) {
			my $last_rating = $self->_last_rating($id);
			if (($page == QUOTE_RATING_UP && $last_rating > 0)
			|| ($page == QUOTE_RATING_DOWN && $last_rating < 0)) {
				$self->report_quote_already_rated($id);
			}
			else {
				my ($history, $full) = $self->_rating_history();
				if (!$full) {
					if ($self->quote_rating_confirmed()) {
						$self->_rate_quote($id, $up, abs($last_rating), $history);
					}
					else {
						$self->request_quote_rating_confirmation(
							$quote, $up, abs($last_rating));
					}
				}
				else {
					$self->report_quote_rating_limit_excess();
				}
			}
		}
		else {
			$self->report_rated_quote_not_found();
		}
	}
	elsif ($page == REPORT_QUOTE) {
		my $id = $self->get_selected_quote_id();
		my $quote = $self->parent()->get_quote($id);
		if (defined $quote && $quote->is_approved()) {
			if ($self->quote_report_confirmed()) {
				$self->parent()->flag_quotes($id);
				$self->confirm_quote_report($id);
				$self->_log_event(Chirpy::Event::REPORT_QUOTE, { 'id' => $id });
			}
			else {
				$self->request_quote_report_confirmation($quote);
			}
		}
		else {
			$self->report_reported_quote_not_found();
		}
	}
	elsif ($page eq TAG_CLOUD) {
		my $tag_counts = $self->parent()->get_tag_use_counts();
		if (%$tag_counts) {
			$self->_provide_tag_cloud($tag_counts);
		}
		else {
			$self->report_no_tagged_quotes();
		}
	}
	elsif ($page eq STATISTICS) {
		$self->_provide_statistics();
	}
	elsif ($page == LOGIN) {
		if ($self->attempting_login()) {
			my ($username, $password)
				= $self->get_supplied_username_and_password();
			my $account = $self->parent()
				->attempt_login($username, $password);
			if (defined $account) {
				$self->set_logged_in_user($account->get_id());
				$self->confirm_login();
				$self->_log_event(Chirpy::Event::LOGIN_SUCCESS);
			}
			else {
				$self->report_invalid_login();
				$self->_log_event(Chirpy::Event::LOGIN_FAILURE,
					{ 'username' => $username });
			}
		}
		else {
			$self->provide_login_interface();
		}
	}
	elsif ($page == LOGOUT) {
		$self->set_logged_in_user(undef);
		$self->confirm_logout();
	}
	elsif ($page == ADMINISTRATION) {
		if (defined $self->get_logged_in_user_account()) {
			$self->_provide_administration_interface()
		}
		else {
			$self->provide_login_interface();
		}
	}
	else {
		$self->report_unknown_action();
	}
}

sub statistics_update_allowed {
	return 1;
}

sub _provide_administration_interface {
	my $self = shift;
	if ($self->configuration()->get('general', 'update_check')
	&& $self->administration_allowed(CHECK_FOR_UPDATE)) {
		$self->_maybe_check_for_update();
	}
	my $page = $self->get_current_administration_page() || 0;
	if ($page == CHANGE_PASSWORD) {
		my $user = $self->get_logged_in_user_account();
		if ($self->attempting_password_change()) {
			my ($current_password, $new_password, $repeat_password)
				= $self->get_supplied_passwords();
			if (!defined $self->parent()
				->attempt_login(
					$user->get_username(), $current_password)) {
						$self->provide_password_change_interface(
							CURRENT_PASSWORD_INVALID);
			}
			elsif (!Chirpy::Util::valid_password($new_password)) {
				$self->provide_password_change_interface(
					NEW_PASSWORD_INVALID);
			}
			elsif ($new_password ne $repeat_password) {
				$self->provide_password_change_interface(
					PASSWORDS_DIFFER);
			}
			else {
				$self->parent()->modify_account(
					$user, undef, $new_password);
				$self->confirm_password_change();
				$self->_log_event(Chirpy::Event::CHANGE_PASSWORD);
			}
		}
		else {
			$self->provide_password_change_interface();
		}
	}
	elsif ($page == MANAGE_UNAPPROVED_QUOTES) {
		if (!$self->administration_allowed($page)) {
			$self->report_administration_user_level_insufficient($page);
		}
		else {
			my ($approve, $remove, $edited)
				= $self->get_quote_approval_result();
			my @approve = (defined $approve && ref $approve eq 'ARRAY'
				? @$approve : ());
			my @remove = (defined $remove && ref $remove eq 'ARRAY'
				? @$remove : ());
			if (@approve) {
				$self->parent()->approve_quotes(@approve);
				foreach my $id (@approve) {
					if (exists $edited->{$id}) {
						my $quote = $self->parent()->get_quote($id);
						if (defined $quote) {
							my $body = $edited->{$id}->{'body'};
							my $notes = $edited->{$id}->{'notes'};
							my $tags = $edited->{$id}->{'tags'};
							if ($body) {
								$self->_modify_quote(
									$quote, $body, $notes, $tags);
							}
						}
					}
					$self->_log_event(Chirpy::Event::APPROVE_QUOTE,
						{ 'id' => $id });
				}
			}
			if (@remove) {
				$self->parent()->remove_quotes(@remove);
				foreach my $id (@remove) {
					$self->_log_event(Chirpy::Event::REMOVE_QUOTE,
						{ 'id' => $id });
				}
			}
			$self->provide_quote_approval_interface(
				@approve ? \@approve : undef,
				@remove ? \@remove : undef);
		}
	}
	elsif ($page == MANAGE_FLAGGED_QUOTES) {
		if (!$self->administration_allowed($page)) {
			$self->report_administration_user_level_insufficient($page);
		}
		else {
			my ($unflag, $remove) = $self->get_quote_flag_management_result();
			my @unflag = (defined $unflag && ref $unflag eq 'ARRAY'
				? @$unflag : ());
			my @remove = (defined $remove && ref $remove eq 'ARRAY'
				? @$remove : ());
			if (@unflag) {
				$self->parent()->unflag_quotes(@unflag);
				foreach my $id (@unflag) {
					$self->_log_event(Chirpy::Event::UNFLAG_QUOTE,
						{ 'id' => $id });
				}
			}
			if (@remove) {
				$self->parent()->remove_quotes(@remove);
				foreach my $id (@remove) {
					$self->_log_event(Chirpy::Event::REMOVE_QUOTE,
						{ 'id' => $id });
				}
			}
			$self->provide_quote_flag_management_interface(
				@unflag ? \@unflag : undef,
				@remove ? \@remove : undef);
		}
	}
	elsif ($page == EDIT_QUOTE) {
		if (!$self->administration_allowed($page)) {
			$self->report_administration_user_level_insufficient($page);
		}
		else {
			my $id = $self->get_quote_to_edit();
			if ($id) {
				my $quote = $self->parent()->get_quote($id);
				if (defined $quote && $quote->is_approved()) {
					my ($body, $notes, $tags)
						= $self->get_modified_quote_information();
					if ($body) {
						$self->_modify_quote($quote, $body, $notes, $tags);
						$self->confirm_quote_modification($quote);
					}
					else {
						$self->provide_quote_editing_interface($quote);
					}
				}
				else {
					$self->report_quote_to_edit_not_found();
				}
			}
			else {
				$self->provide_quote_selection_for_modification_interface();
			}
		}
	}
	elsif ($page == REMOVE_QUOTE) {
		if (!$self->administration_allowed($page)) {
			$self->report_administration_user_level_insufficient($page);
		}
		else {
			my $id = $self->get_quote_to_remove();
			if ($id) {
				my $quote = $self->parent()->get_quote($id);
				if (defined $quote && $quote->is_approved()) {
					if ($self->quote_removal_confirmed()) {
						$self->parent()->remove_quotes($id);
						$self->confirm_quote_removal();
						$self->_log_event(Chirpy::Event::REMOVE_QUOTE,
							{ 'id' => $id });
					}
					else {
						$self->request_quote_removal_confirmation($quote);
					}
				}
				else {
					$self->report_quote_to_remove_not_found();
				}
			}
			else {
				$self->provide_quote_selection_for_removal_interface();
			}
		}
	}
	elsif ($page == ADD_NEWS) {
		if (!$self->administration_allowed($page)) {
			$self->report_administration_user_level_insufficient($page);
		}
		else {
			if (my $news = $self->get_news_item_to_add()) {
				my $news = Chirpy::Util::clean_up_submission($news);
				my $item = $self->parent()->add_news_item(
					$news,
					$self->get_logged_in_user_account()
				);
				$self->confirm_news_submission($news);
				$self->_log_event(Chirpy::Event::ADD_NEWS, {
					'id' => $item->get_id(), 'body' => $news
				});
			}
			else {
				$self->provide_news_submission_interface();
			}
		}
	}
	elsif ($page == EDIT_NEWS) {
		if (!$self->administration_allowed($page)) {
			$self->report_administration_user_level_insufficient($page);
		}
		else {
			my $id = $self->get_news_item_to_edit();
			if ($id) {
				my $item = $self->parent()->get_news_item($id);
				if (defined $item) {
					my ($text, $poster_id) = $self->get_modified_news_item();
					if ($text) {
						my $old_body = $item->get_body();
						my $old_poster = $item->get_poster();
						$text = Chirpy::Util::clean_up_submission($text);
						$self->parent()->modify_news_item(
							$item,
							$text,
							$self->parent()->get_account_by_id($poster_id)
						);
						$self->confirm_news_item_modification();
						$self->_log_event(Chirpy::Event::EDIT_NEWS, {
							'id' => $id,
							($old_body ne $text ? ('new_body' => $text) : ()),
							(!defined $old_poster
								|| $old_poster->get_id() != $poster_id
								? ('new_poster' => $poster_id) : ())
						});
					}
					else {
						$self->provide_news_item_editing_interface($item);
					}
				}
				else {
					$self->report_news_item_to_edit_not_found();
				}
			}
			else {
				$self->provide_news_item_selection_for_modification_interface();
			}
		}
	}
	elsif ($page == REMOVE_NEWS) {
		if (!$self->administration_allowed($page)) {
			$self->report_administration_user_level_insufficient($page);
		}
		else {
			my $id = $self->get_news_item_to_remove();
			if ($id) {
				my $item = $self->parent()->get_news_item($id);
				if (defined $item) {
					$self->parent()->remove_news_items($id);
					$self->confirm_news_item_removal();
					$self->_log_event(Chirpy::Event::REMOVE_NEWS,
						{ 'id' => $id });
				}
				else {
					$self->report_news_item_to_remove_not_found();
				}
			}
			else {
				$self->provide_news_item_selection_for_removal_interface();
			}
		}
	}
	elsif ($page == ADD_ACCOUNT) {
		if (!$self->administration_allowed($page)) {
			$self->report_administration_user_level_insufficient($page);
		}
		else {
			my ($username, $password, $repeat_password, $level)
				= $self->get_account_information_to_add();
			if (defined $username) {
				if (!Chirpy::Util::valid_username($username)) {
					$self->report_invalid_new_username();
				}
				elsif ($self->parent()->username_exists($username)) {
					$self->report_new_username_exists();
				}
				elsif (!Chirpy::Util::valid_password($password)) {
					$self->report_invalid_new_password();
				}
				elsif ($password ne $repeat_password) {
					$self->report_different_new_passwords();
				}
				elsif ($level <= 0) {
					$self->report_invalid_new_user_level();
				}
				else {
					my $account = $self->parent()->add_account(
						$username, $password, $level);
					$self->confirm_account_creation();
					$self->_log_event(Chirpy::Event::ADD_ACCOUNT, {
						'id' => $account->get_id(),
						'username' => $username,
						'level' => $level
					});
				}
			}
			else {
				$self->provide_account_creation_interface();
			}
		}
	}
	elsif ($page == EDIT_ACCOUNT) {
		if (!$self->administration_allowed($page)) {
			$self->report_administration_user_level_insufficient($page);
		}
		else {
			my $id = $self->get_account_to_modify();
			if (defined $id) {
				my $account = $self->parent()->get_account_by_id($id);
				if (defined $account) {
					my ($username, $password, $repeat_password, $level)
						= $self->get_modified_account_information();
					if (defined $username
						&& !Chirpy::Util::valid_username($username)) {
							$self->report_invalid_modified_username();
					}
					elsif ($self->parent()->username_exists($username)) {
						$self->report_modified_username_exists();
					}
					elsif (defined $password
						&& !Chirpy::Util::valid_password($password)) {
							$self->report_invalid_modified_password();
					}
					elsif (defined $password
						&& $password ne $repeat_password) {
							$self->report_different_modified_passwords();
					}
					elsif (defined $level && $level <= 0) {
						$self->report_invalid_modified_user_level();
					}
					elsif (!defined $username && !defined $password
						&& !defined $level) {
							$self->report_modified_account_information_required();
					}
					else {
						my $old_username = $account->get_username();
						my $old_password = $account->get_password();
						my $old_level = $account->get_level();
						$self->parent()->modify_account(
							$account, $username, $password, $level);
						$self->confirm_account_modification();
						$self->_log_event(Chirpy::Event::EDIT_ACCOUNT, {
							'id' => $id,
							(defined $username && $old_username ne $username
								? ('new_username' => $username) : ()),
							(defined $level && $old_level != $level
								? ('new_level' => $level) : ()),
							(defined $password
								? ('password_changed' => 1) : ())
						});
					}
				}
				else {
					$self->report_account_to_modify_not_found();
				}
			}
			else {
				$self->provide_account_selection_for_modification_interface();
			}
		}
	}
	elsif ($page == REMOVE_ACCOUNT) {
		if (!$self->administration_allowed($page)) {
			$self->report_administration_user_level_insufficient($page);
		}
		else {
			my $parent = $self->parent();
			if ($parent->account_count() > 1) {
				my $id = $self->get_account_to_remove();
				if (defined $id) {
					my $account = $self->parent()->get_account_by_id($id);
					my $level = Chirpy::Account::USER_LEVEL_9;
					if ($account->get_level() == $level
						&& $parent->account_count_by_level($level) <= 1) {
							$self->report_last_owner_account_removal_error();
					}
					elsif (defined $account) {
						if ($account->get_id()
							== $self->get_logged_in_user_account()->get_id()) {
								$self->set_logged_in_user(undef);
						}
						my $username = $account->get_username();
						my $level = $account->get_level();
						$parent->remove_accounts($id);
						$self->confirm_account_removal();
						$self->_log_event(Chirpy::Event::REMOVE_ACCOUNT,
							{ 'id' => $id });
					}
					else {
						$self->report_account_to_remove_not_found();
					}
				}
				else {
					$self->provide_account_selection_for_removal_interface();
				}
			}
			else {
				$self->report_last_owner_account_removal_error();
			}
		}
	}
	else {
		$self->welcome_administrator();
	}
}

sub _maybe_check_for_update {
	my $self = shift;
	my $last_check = $self->get_parameter('last_update_check');
	my $now = time();
	my @update_info;
	my $update_check_error;
	if (!defined $last_check
	|| $last_check + UPDATE_CHECK_INTERVAL < $now) {
		$self->set_parameter('last_update_check', $now);
		my $upd_status = $self->_check_for_update();
		if (defined $upd_status) {
			if (ref $upd_status eq 'ARRAY') {
				$self->set_parameter('update_version', $upd_status->[0]);
				$self->set_parameter('update_released', $upd_status->[1]);
				$self->set_parameter('update_url', $upd_status->[2]);
				$self->set_parameter('update_version_current',
					$Chirpy::VERSION);
				@update_info = @$upd_status; 
			}
			else {
				$update_check_error = $upd_status;
			}
		}
	}
	else {
		my $version = $self->get_parameter('update_version');
		if ($version) {
			my $version_at_check
				= $self->get_parameter('update_version_current');
			if ($version_at_check == $Chirpy::VERSION) {
				my $date = $self->get_parameter('update_released');
				my $url = $self->get_parameter('update_url');
				@update_info = ($version, $date, $url);
			}
			else {
				$self->set_parameter('update_version', undef);
				$self->set_parameter('update_released', undef);
				$self->set_parameter('update_url', undef);
				$self->set_parameter('update_version_current', undef);
			}
		}
	}
	if (defined $update_check_error) {
		$self->update_check_error($update_check_error);
	}
	elsif (@update_info) {
		$self->update_available(@update_info);
	}
}

sub _check_for_update {
	my $self = shift;
	my $uc = new Chirpy::UpdateChecker($self);
	my $result = $uc->check_for_updates();
	return undef unless ($result);
	return $uc->get_error_message() if (ref $result ne 'ARRAY');
	return $result;
}

sub _browse_quotes_segmented {
	my ($self, $page, $start, $quotes, $leading, $trailing) = @_;
	if (defined $quotes) {
		my $per_page = $self->parent()->quotes_per_page();
		my ($previous, $next);
		if ($leading) {
			$previous = $start - $per_page;
			$previous = 0 if ($previous < 0);
		}
		if ($trailing) {
			$next = $start + $per_page;
		}
		$self->browse_quotes($quotes, $page, $previous, $next);
	}
	elsif ($page == QUOTE_SEARCH) {
		$self->report_no_search_results();
	}
	else {
		$self->report_no_quotes_to_display($page);
	}
}

sub _provide_tag_cloud {
	my ($self, $tag_counts) = @_;
	my $highest = 0;
	my $lowest = undef;
	foreach my $cnt (values %$tag_counts) {
		$lowest = $cnt if (!defined $lowest || $cnt < $lowest);
		$highest = $cnt if ($cnt > $highest);
	}
	my $difference = $highest - $lowest;
	my @tag_info = ();
	my $conf = $self->configuration();
	my @tags = $conf->get('ui', 'randomize_tag_cloud')
		? Chirpy::Util::shuffle_array(keys %$tag_counts)
		: sort keys %$tag_counts;
	my @tag_info_list;
	my $factor = $conf->get('ui', 'tag_cloud_percentage_delta') || 100;
	my $logarithmic = ($difference > 1
		&& $conf->get('ui', 'tag_cloud_logarithmic')); 
	$factor /= log($difference) if ($logarithmic);
	foreach my $tag (@tags) {
		my $cnt = $tag_counts->{$tag};
		my $delta;
		if (!$difference || $cnt == $lowest) {
			$delta = 0;
		}
		elsif ($logarithmic) {
			$delta = $factor * log($cnt - $lowest);
		}
		else {
			$delta = $factor * ($cnt - $lowest) / $difference;
		}
		$tag = [
			$tag,
			$cnt,
			sprintf('%.0f', 100 + $delta)
		];
	}
	$self->provide_tag_cloud(\@tags);
}

sub _provide_statistics {
	my $self = shift;
	my $stats;
	require Storable;
	my $file = $self->_statistics_cache_file();
	my $exists = (-e $file);
	my $tag_file = $file . '.tag';
	if ((!$exists || (
	$self->statistics_update_allowed()
	&& (stat($file))[9] + STATISTICS_UPDATE_INTERVAL < time
	)) && (!-e $tag_file
	# If the update seems to be taking longer than the update interval itself,
	# something probably went wrong. In this case, we just try again.
	|| (stat($tag_file))[9] + STATISTICS_UPDATE_INTERVAL < time)) {
		local *TAG;
		open(TAG, '>', $tag_file) and close(TAG);
		$stats = $self->_compute_statistics();
		if (defined $stats) {
			Storable::store($stats, $file);
		}
		unlink $tag_file;
	}
	elsif ($exists) {
		$stats = Storable::retrieve($file);
	}
	if (defined $stats) {
		$self->provide_statistics(@$stats);
	}
	else {
		$self->report_statistics_unavailable();
	}
}

sub _compute_statistics {
	my $self = shift;
	my $quotes = $self->parent()->get_quotes(0, 0, [ [ 'submitted', 0 ] ]);
	return undef unless (@$quotes);
	my $by_date = [];
	my $by_hour = &_init_array(0, 24);
	my $by_month = &_init_array(0, 12);
	my $by_day = &_init_array(0, 31);
	my $by_weekday = &_init_array(0, 7);
	my $by_rating = {};
	my $by_votes = {};
	my $votes_by_rating = [ 0, 0 ];
	my ($date, $weekday, $year, $month, $day, $prev_time);
	foreach my $quote (@$quotes) {
		my $time = $quote->get_date_submitted();
		my $d = $self->format_date($time);
		my @time = $self->get_time($time);
		if (!defined($date) || $d ne $date) {
			if (defined $prev_time) {
				$self->_pad_statistics($prev_time, $date, $d, $by_date);
			}
			$prev_time = $time;
			$date = $d;
			$day = $time[3] - 1;
			$month = $time[4];
			$year = $time[5];
			$weekday = $time[6];
		}
		&_add_statistic($date, 1, $by_date);
		$by_weekday->[$weekday]++;
		$by_day->[$day]++;
		$by_month->[$month]++;
		$by_hour->[$time[2]]++;
		my $rating = $quote->get_rating();
		my $votes = $quote->get_vote_count();
		$by_rating->{$rating}++;
		$by_votes->{$votes}++;
		my $votes_down = ($votes - $rating) / 2;
		my $votes_up = $votes - $votes_down;
		$votes_by_rating->[0] += $votes_up;
		$votes_by_rating->[1] += $votes_down;
	}
	return [
		$by_date, $by_hour, $by_weekday, $by_day, $by_month,
		&_to_sorted_array($by_rating, 1), &_to_sorted_array($by_votes, 0),
		$votes_by_rating
	];
}

sub _to_sorted_array {
	my ($hashref, $negative) = @_;
	my @keys = keys %$hashref;
	my $highest = shift @keys;
	$highest = abs $highest if ($negative);
	foreach my $k (@keys) {
		my $a = ($negative ? abs $k : $k);
		if ($a > $highest) {
			$highest = $a;
		}
	}
	my @res = ();
	for (my $i = ($negative ? - $highest : 0); $i <= $highest; $i++) {
		push @res, [ $i, $hashref->{$i} || 0 ];
	}
	return \@res;
}

sub _init_array {
	my ($value, $length) = @_;
	my @array = ();
	foreach (1..$length) {
		push @array, $value;
	}
	return \@array;
}

sub _add_statistic {
	my ($name, $value, $aref) = @_;
	if (@$aref && $aref->[scalar(@$aref) - 1]->[0] eq $name) {
		$aref->[scalar(@$aref) - 1]->[1] += $value;
	}
	else {
		push @$aref, [$name, $value];
	}
}

sub _pad_statistics {
	my ($self, $from, $from_date, $to, $by_date) = @_;
	while (1) {
		my ($next_date, $next_date_time)
			= $self->_next_date($from, $from_date);
		last if ($next_date eq $to);
		&_add_statistic($next_date, 0, $by_date);
		my @time = $self->get_time($next_date_time);
		$from = $next_date_time;
		$from_date = $next_date;
	}
}

sub _next_date {
	my ($self, $time, $date) = @_;
	while (1) {
		$time += 23 * 60 * 60;
		my $d = $self->format_date($time);
		next if ($d eq $date);
		return ($d, $time);
	}
}

sub _last_rating {
	my ($self, $id) = @_;
	my @list = $self->get_rated_quotes();
	foreach my $i (@list) {
		next unless (abs($i) == $id);
		return ($i < 0 ? -1 : 1);
	}
	return 0;
}

sub _rate_quote {
	my ($self, $id, $up, $revert, $history) = @_;
	my $parent = $self->parent();
	my ($new_rating, $new_vote_count);
	my @rated = $self->get_rated_quotes();
	if ($revert) {
		($new_rating, $new_vote_count) = ($up
			? $parent->increase_quote_rating($id, 1)
			: $parent->decrease_quote_rating($id, 1));
		@rated = grep { abs($_) != $id } @rated;
	}
	else {
		($new_rating, $new_vote_count) = ($up
			? $parent->increase_quote_rating($id)
			: $parent->decrease_quote_rating($id));
		$self->set_rating_history(@$history, time);
	}
	$self->set_rated_quotes(@rated, ($up ? $id : -$id));
	$self->confirm_quote_rating($id, $up, $new_rating, $new_vote_count);
	$self->_log_event(($up
			? Chirpy::Event::QUOTE_RATING_UP
			: Chirpy::Event::QUOTE_RATING_DOWN),
		{ 'id' => $id, 'new_rating' => $new_rating,
			($revert ? ('revert' => 1) : ()) });
}

sub _rating_history {
	my $self = shift;
	my $conf = $self->parent()->configuration();
	my $max_time = $conf->get('general', 'rating_limit_time');
	my $max_size = $conf->get('general', 'rating_limit_count');
	return undef if ($max_time <= 0 || $max_size <= 0);
	my $time = time;
	my $since = $time - $max_time;
	my @history = $self->get_rating_history();
	shift @history
		while (@history && $history[0] < $since);
	return (\@history, @history >= $max_size);
}

sub _modify_quote {
	my ($self, $quote, $body, $notes, $tags) = @_;
	my $id = $quote->get_id();
	$body = Chirpy::Util::clean_up_submission($body);
	$notes = Chirpy::Util::clean_up_submission($notes);
	$tags = Chirpy::Util::parse_tags($tags);
	my $old_body = $quote->get_body();
	my $old_notes = $quote->get_notes();
	my $old_tags = join('', sort @{$quote->get_tags()});
	$self->parent()->modify_quote($quote, $body, $notes, $tags);
	$tags = join(' ', sort @$tags);
	$self->_log_event(Chirpy::Event::EDIT_QUOTE, {
		'id' => $id,
		($old_body ne $body ? ('new_body' => $body) : ()),
		($old_notes ne $notes ? ('new_notes' => $notes) : ()),
		($old_tags ne $tags ? ('new_tags' => $tags) : ())
	});
}

sub _log_event {
	my ($self, $code, $params) = @_;
	$params = {} unless (defined $params);
	my $info = $self->get_user_information();
	while (my ($k, $v) = each %$info) {
		$params->{'user:' . $k} = $v;
	}
	$self->parent()->log_event(
		$code,
		$self->get_logged_in_user_account(),
		$params
	);
}

sub _statistics_cache_file {
	my $self = shift;
	return $self->configuration()->get('general', 'base_path')
		. '/cache/statistics';
}

sub moderation_queue_is_public {
	my $self = shift;
	return $self->configuration()->get('ui', 'moderation_queue_public');
}

sub get_news_posters {
	my $self = shift;
	return $self->parent()->get_accounts_by_level(
		keys %{ADMIN_PERMISSIONS->{ADD_NEWS()}});
}

sub get_logged_in_user_account {
	my $self = shift;
	my $id = $self->get_logged_in_user();
	return (defined $id
		? $self->parent()->get_account_by_id($id)
		: undef);
}

sub administration_allowed {
	my ($self, $action) = @_;
	return 0 unless exists ADMIN_PERMISSIONS->{$action};
	my $user = $self->get_logged_in_user_account();
	return 0 unless defined $user;
	my $level = $user->get_level();
	return ADMIN_PERMISSIONS->{$action}{$level};
}

sub get_parameter {
	my ($self, $name) = @_;
	return $self->parent()->get_parameter($name);
}

sub set_parameter {
	my ($self, $name, $value) = @_;
	$self->parent()->set_parameter($name, $value);
}

sub format_date_time {
	my ($self, $timestamp) = @_;
	return Chirpy::Util::format_date_time($timestamp,
		$self->configuration()->get('ui', 'date_time_format'),
		$self->configuration()->get('ui', 'use_gmt'));
}

sub format_date {
	my ($self, $timestamp) = @_;
	return Chirpy::Util::format_date_time($timestamp,
		$self->configuration()->get('ui', 'date_format'),
		$self->configuration()->get('ui', 'use_gmt'));
}

sub format_time {
	my ($self, $timestamp) = @_;
	return Chirpy::Util::format_date_time($timestamp,
		$self->configuration()->get('ui', 'time_format'),
		$self->configuration()->get('ui', 'use_gmt'));
}

sub format_month {
	my ($self, $month_id) = @_;
	my @months = qw(january february march april may june
		july august september october november december);
	my $l = $self->locale();
	my $month = $month_id % 100;
	my $year = $month_id - $month;
	my $m = $months[$month];
	my $suffix = ($year ? ' ' . (1900 + $year / 100) : '');
	my $long = $l->get_string($m) . $suffix;
	my $short = $l->get_string($m . '_short') . $suffix;
	return ($short, $long);
}

sub get_time {
	my ($self, $timestamp) = @_;
	return ($self->configuration()->get('ui', 'use_gmt')
		? gmtime($timestamp) : localtime($timestamp));
}

sub locale {
	my $self = shift;
	return $self->parent()->locale();
}

sub configuration {
	my $self = shift;
	return $self->parent()->configuration();
}

sub parent {
	my $self = shift;
	return $self->{'parent'};
}

sub param {
	my ($self, $name) = @_;
	return defined $self->{'params'} ? $self->{'params'}{$name} : undef;
}

*get_target_version = \&Chirpy::Util::abstract_method;

*get_current_page = \&Chirpy::Util::abstract_method;

*get_selected_quote_id = \&Chirpy::Util::abstract_method;

*get_first_quote_index = \&Chirpy::Util::abstract_method;

*get_search_instruction = \&Chirpy::Util::abstract_method;

*get_submitted_quote = \&Chirpy::Util::abstract_method;

*attempting_login = \&Chirpy::Util::abstract_method;

*get_supplied_username_and_password = \&Chirpy::Util::abstract_method;

*get_rating_history = \&Chirpy::Util::abstract_method;

*set_rating_history = \&Chirpy::Util::abstract_method;

*get_rated_quotes = \&Chirpy::Util::abstract_method;

*set_rated_quotes = \&Chirpy::Util::abstract_method;

*get_logged_in_user = \&Chirpy::Util::abstract_method;

*set_logged_in_user = \&Chirpy::Util::abstract_method;

*report_no_quotes_to_display = \&Chirpy::Util::abstract_method;

*report_unknown_action = \&Chirpy::Util::abstract_method;

*welcome_user = \&Chirpy::Util::abstract_method;

*browse_quotes = \&Chirpy::Util::abstract_method;

*provide_quote_search_interface = \&Chirpy::Util::abstract_method;

*provide_tag_cloud = \&Chirpy::Util::abstract_method;

*report_no_tagged_quotes = \&Chirpy::Util::abstract_method;

*provide_statistics = \&Chirpy::Util::abstract_method;

*report_statistics_unavailable = \&Chirpy::Util::abstract_method;

*report_no_search_results = \&Chirpy::Util::abstract_method;

*report_inexistent_quote = \&Chirpy::Util::abstract_method;

*provide_quote_submission_interface = \&Chirpy::Util::abstract_method;

*confirm_quote_submission = \&Chirpy::Util::abstract_method;

*confirm_quote_rating = \&Chirpy::Util::abstract_method;

*quote_rating_confirmed = \&Chirpy::Util::abstract_method;

*request_quote_rating_confirmation = \&Chirpy::Util::abstract_method;

*report_rated_quote_not_found = \&Chirpy::Util::abstract_method;

*report_quote_already_rated = \&Chirpy::Util::abstract_method;

*report_quote_rating_limit_excess = \&Chirpy::Util::abstract_method;

*confirm_quote_report = \&Chirpy::Util::abstract_method;

*quote_report_confirmed = \&Chirpy::Util::abstract_method;

*request_quote_report_confirmation = \&Chirpy::Util::abstract_method;

*report_reported_quote_not_found = \&Chirpy::Util::abstract_method;

*provide_login_interface = \&Chirpy::Util::abstract_method;

*report_invalid_login = \&Chirpy::Util::abstract_method;

*attempting_password_change = \&Chirpy::Util::abstract_method;

*get_supplied_passwords = \&Chirpy::Util::abstract_method;

*provide_password_change_interface = \&Chirpy::Util::abstract_method;

*confirm_password_change = \&Chirpy::Util::abstract_method;

*confirm_login = \&Chirpy::Util::abstract_method;

*confirm_logout = \&Chirpy::Util::abstract_method;

*get_current_administration_page = \&Chirpy::Util::abstract_method;

*welcome_administrator = \&Chirpy::Util::abstract_method;

*get_quote_to_remove = \&Chirpy::Util::abstract_method;

*confirm_quote_removal = \&Chirpy::Util::abstract_method;

*quote_removal_confirmed = \&Chirpy::Util::abstract_method;

*request_quote_removal_confirmation = \&Chirpy::Util::abstract_method;

*report_quote_to_remove_not_found = \&Chirpy::Util::abstract_method;

*provide_quote_selection_for_removal_interface
	= \&Chirpy::Util::abstract_method;

*get_quote_to_edit = \&Chirpy::Util::abstract_method;

*get_modified_quote_information = \&Chirpy::Util::abstract_method;

*confirm_quote_modification = \&Chirpy::Util::abstract_method;

*provide_quote_editing_interface = \&Chirpy::Util::abstract_method;

*report_quote_to_edit_not_found = \&Chirpy::Util::abstract_method;

*provide_quote_selection_for_modification_interface
	= \&Chirpy::Util::abstract_method;

*provide_quote_approval_interface = \&Chirpy::Util::abstract_method;

*get_quote_approval_result = \&Chirpy::Util::abstract_method;

*provide_quote_flag_management_interface = \&Chirpy::Util::abstract_method;

*get_quote_flag_management_result = \&Chirpy::Util::abstract_method;

*get_news_item_to_add = \&Chirpy::Util::abstract_method;

*confirm_news_submission = \&Chirpy::Util::abstract_method;

*provide_news_submission_interface = \&Chirpy::Util::abstract_method;

*get_news_item_to_edit = \&Chirpy::Util::abstract_method;

*get_modified_news_item = \&Chirpy::Util::abstract_method;

*confirm_news_item_modification = \&Chirpy::Util::abstract_method;

*report_news_item_to_edit_not_found = \&Chirpy::Util::abstract_method;

*provide_news_item_editing_interface = \&Chirpy::Util::abstract_method;

*provide_news_item_selection_for_modification_interface
	= \&Chirpy::Util::abstract_method;

*get_news_item_to_remove = \&Chirpy::Util::abstract_method;

*confirm_news_item_removal = \&Chirpy::Util::abstract_method;

*report_news_item_to_remove_not_found = \&Chirpy::Util::abstract_method;

*provide_quote_selection_for_removal_interface
	= \&Chirpy::Util::abstract_method;

*get_account_information_to_add = \&Chirpy::Util::abstract_method;

*report_invalid_new_username = \&Chirpy::Util::abstract_method;

*report_new_username_exists = \&Chirpy::Util::abstract_method;

*report_invalid_new_password = \&Chirpy::Util::abstract_method;

*report_different_new_passwords = \&Chirpy::Util::abstract_method;

*report_invalid_new_user_level = \&Chirpy::Util::abstract_method;

*confirm_account_creation = \&Chirpy::Util::abstract_method;

*provide_account_creation_interface = \&Chirpy::Util::abstract_method;

*get_account_to_modify = \&Chirpy::Util::abstract_method;

*get_modified_account_information = \&Chirpy::Util::abstract_method;

*report_invalid_modified_username = \&Chirpy::Util::abstract_method;

*report_modified_username_exists = \&Chirpy::Util::abstract_method;

*report_invalid_modified_password = \&Chirpy::Util::abstract_method;

*report_different_modified_passwords = \&Chirpy::Util::abstract_method;

*report_invalid_modified_user_level = \&Chirpy::Util::abstract_method;

*confirm_account_modification = \&Chirpy::Util::abstract_method;

*report_account_to_modify_not_found = \&Chirpy::Util::abstract_method;

*report_modified_account_information_required
	= \&Chirpy::Util::abstract_method;

*provide_account_selection_for_modification_interface
	= \&Chirpy::Util::abstract_method;

*get_account_to_remove = \&Chirpy::Util::abstract_method;

*confirm_account_removal = \&Chirpy::Util::abstract_method;

*report_account_to_remove_not_found = \&Chirpy::Util::abstract_method;

*provide_account_selection_for_removal_interface
	= \&Chirpy::Util::abstract_method;

*report_last_owner_account_removal_error = \&Chirpy::Util::abstract_method;

*get_user_information = \&Chirpy::Util::abstract_method;

*update_available = \&Chirpy::Util::abstract_method;

*update_check_error = \&Chirpy::Util::abstract_method;

1;

###############################################################################