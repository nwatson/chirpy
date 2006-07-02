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

=head1 NAME

Chirpy::UI::WebApp::Administration - Administration-section related routines
of L<Chirpy::UI::WebApp>

=head1 TODO

Make this template-based and avoid inline calls to parents.

=head1 AUTHOR

Tim De Pauw E<lt>ceetee@users.sourceforge.netE<gt>

=head1 SEE ALSO

L<Chirpy::UI::WebApp>, L<Chirpy::UI>, L<Chirpy>,
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

package Chirpy::UI::WebApp::Administration;

use strict;
use warnings;

use vars qw($VERSION);

$VERSION = '';

use Chirpy;
use Chirpy::UI::WebApp;
use Chirpy::Event;

sub new {
	my ($class, $parent) = @_;
	return bless { 'parent' => $parent }, $class;
}

sub parent {
	my $self = shift;
	return $self->{'parent'};
}

sub output {
	my ($self, %params) = @_;
	my $event_log_allowed = $self->parent()->administration_allowed(
		Chirpy::UI::VIEW_EVENT_LOG);
	if ($event_log_allowed && $self->parent()->_wants_xml()) {
		$self->_serve_event_log_table_data();
		return;
	}
	my $template = $self->parent()->_load_template('administration');
	my $locale = $self->parent()->locale();
	my ($upd_url, $upd_text);
	if (my $update = $self->parent()->{'available_update'}) {
		$template->param('UPDATE_AVAILABLE'
			=> &_text_to_xhtml($locale->get_string('update_available')));
		$template->param('UPDATE_AVAILABLE_TEXT' => &_text_to_xhtml(
			$locale->get_string('update_available_text',
			$update->[0], $update->[1])));
		$template->param('UPDATE_LINK_TEXT'
			=> &_text_to_xhtml($locale->get_string('update_link_text')));
		$template->param('UPDATE_URL' => &_text_to_xhtml($update->[2]));
	}
	elsif (my $errmsg = $self->parent()->{'update_check_error'}) {
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
			=> sub { return $self->get_approve_quotes_html(%params) },
		'APPROVE_QUOTES_ALLOWED'
			=> $self->parent()->administration_allowed(Chirpy::UI::MANAGE_UNAPPROVED_QUOTES),
		'APPROVE_QUOTES_NOT_ALLOWED_HTML'
			=> sub { return $self->get_access_disallowed_html() },
		'FLAGGED_QUOTES' => &_text_to_xhtml(
			$locale->get_string('flagged_quotes')),
		'FLAGGED_QUOTES_HTML'
			=> sub { return $self->get_flagged_quotes_html(%params) },
		'FLAGGED_QUOTES_ALLOWED'
			=> $self->parent()->administration_allowed(Chirpy::UI::MANAGE_FLAGGED_QUOTES),
		'FLAGGED_QUOTES_NOT_ALLOWED_HTML'
			=> sub { return $self->get_access_disallowed_html() },
		'MANAGE_QUOTES' => &_text_to_xhtml(
			$locale->get_string('manage_quotes')),
		'MANAGE_QUOTES_HTML'
			=> sub { return $self->get_manage_quotes_html(%params) },
		'MANAGE_QUOTES_ALLOWED'
			=> $self->parent()->administration_allowed(Chirpy::UI::EDIT_QUOTE)
				&& $self->parent()->administration_allowed(Chirpy::UI::REMOVE_QUOTE),
		'MANAGE_QUOTES_NOT_ALLOWED_HTML'
			=> sub { return $self->get_access_disallowed_html() },
		'MANAGE_NEWS' => &_text_to_xhtml(
			$locale->get_string('manage_news')),
		'MANAGE_NEWS_HTML'
			=> sub { return $self->get_manage_news_html(%params) },
		'MANAGE_NEWS_ALLOWED'
			=> $self->parent()->administration_allowed(Chirpy::UI::ADD_NEWS)
				&& $self->parent()->administration_allowed(Chirpy::UI::EDIT_NEWS)
				&& $self->parent()->administration_allowed(Chirpy::UI::REMOVE_NEWS),
		'MANAGE_NEWS_NOT_ALLOWED_HTML'
			=> sub { return $self->get_access_disallowed_html() },
		'MANAGE_ACCOUNTS' => &_text_to_xhtml(
			$locale->get_string('manage_accounts')),
		'MANAGE_ACCOUNTS_HTML'
			=> sub { return $self->get_manage_accounts_html(%params) },
		'VIEW_EVENT_LOG' => &_text_to_xhtml(
			$locale->get_string('view_event_log')),
		'VIEW_EVENT_LOG_ALLOWED'
			=> $event_log_allowed,
		'VIEW_EVENT_LOG_HTML'
			=> sub { return $self->get_event_log_html(%params) },
		'MANAGE_ACCOUNTS_ALLOWED'
			=> $self->parent()->administration_allowed(Chirpy::UI::ADD_ACCOUNT)
				&& $self->parent()->administration_allowed(Chirpy::UI::EDIT_ACCOUNT)
				&& $self->parent()->administration_allowed(Chirpy::UI::REMOVE_ACCOUNT),
		'MANAGE_ACCOUNTS_NOT_ALLOWED_HTML'
			=> sub { return $self->get_access_disallowed_html() },
		'CHANGE_PASSWORD' => &_text_to_xhtml(
			$locale->get_string('change_password')),
		'CHANGE_PASSWORD_HTML'
			=> sub { return $self->get_change_password_html(%params) },
		'ACTION_IS_' . $self->parent()->_admin_action() => 1
	);
	$self->parent()->_output_template($template);
}

sub get_approve_quotes_html {
	my ($self, %params) = @_;
	my $locale = $self->parent()->locale();
	my $quotes = $self->parent()->parent()->get_unapproved_quotes();
	if (defined $quotes) {
		my $html = '<script type="text/javascript" src="'
			. &_text_to_xhtml($self->parent()->_resources_url())
			. '/js/administration.js"></script>' . $/
			. '<form method="post" action="'
			. $self->parent()->_url(
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
				. ($self->parent()->moderation_queue_is_public()
					? '<span class="quote-rating">'
					. Chirpy::Util::format_quote_rating($quote->get_rating())
					. '</span>'
					. '<span class="quote-vote-count">/<span>'
					. $quote->get_vote_count()
					. '</span></span> '
					: '')
				. '<span class="quote-date">'
				. $self->parent()->format_date_time($quote->get_date_submitted())
				. '</span>' . $/
				. '<a href="javascript:editQuote(' . $id . ');" '
				. 'class="quote-edit" id="quote-edit-' . $id . '">['
				. &_text_to_xhtml($locale->get_string('edit'))
				. ']</a>'
				. '</h3>' . $/
				. '<div class="quote-data" id="quote-data-' . $id . '">' . $/
				. '<blockquote class="quote-body">' . $/
				. '<p id="quote-body-' . $id . '">' . &_text_to_xhtml($quote->get_body())
				. '</p>' . $/
				. '</blockquote>' . $/
				. (defined $notes || @$tags ?
				  '<div class="quote-footer">' . (defined $notes
					? '<div class="quote-notes">' . $/
						. '<p><em class="quote-notes-title">Notes:</em>' . $/
						. '<span id="quote-notes-' . $id . '">'
						. &_text_to_xhtml($notes)
						. '</span></p>' . $/
						. '</div>' . $/
					: '')
				. (@$tags
					? '<div class="quote-tags">' . $/
						. '<p><em class="quote-tags-title">'
						. &_text_to_xhtml(
							$locale->get_string('quote_tags_title'))
						. '</em>' . $/
						. '<span id="quote-tags-' . $id . '">'
						. &_text_to_xhtml(join(' ', @$tags))
						. '</span></p>' . $/
						. '</div>' . $/
					: '')
				  . '</div>' : '')
				. '</div>' . $/
				. '</div>' . $/
				. '<div class="approval-options">' . $/
				. '<input type="radio" class="approve-do-nothing-rb" name="action_' . $id
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
			. '" id="approve-reset-button" onclick="'
			. 'var a = document.getElementsByTagName(\'input\'); '
			. 'for (var i = 0; i &lt; a.length; i++) '
			. 'if (a[i].className == \'approve-do-nothing-rb\') a[i].checked = true; '
			. 'return false;" />' . $/
			. '</div>' . $/
			. '</form>';
		return $html;
	}
	else {
		return '<p>' . &_text_to_xhtml(
			$locale->get_string('no_unapproved_quotes')) . '</p>';
	}
}

sub get_flagged_quotes_html {
	my ($self, %params) = @_;
	my $locale = $self->parent()->locale();
	my $quotes = $self->parent()->parent()->get_flagged_quotes();
	if (defined $quotes) {
		my $html = '<form method="post" action="'
			. $self->parent()->_url(
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
				. '<span class="quote-rating">'
					. Chirpy::Util::format_quote_rating($quote->get_rating())
					. '</span>'
					. '<span class="quote-vote-count">/<span>'
					. $quote->get_vote_count()
					. '</span></span> '
				. '<span class="quote-date">'
				. $self->parent()->format_date_time($quote->get_date_submitted())
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

sub get_manage_quotes_html {
	my ($self, %params) = @_;
	my $locale = $self->parent()->locale();
	if (my $quote = $params{'edit_quote'}) {
		my $notes = $quote->get_notes();
		my $tags = $quote->get_tags();
		return '<div id="edit-quote-form">' . $/
			. '<form method="post" action="'
			. $self->parent()->_url(
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
		. $self->parent()->_url(undef, 1)
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

sub get_manage_news_html {
	my ($self, %params) = @_;
	my $locale = $self->parent()->locale();
	if (my $item = $params{'edit_news_item'}) {
		my $html = '<div id="edit-news-item-form">' . $/
			. '<form method="post" action="'
			. $self->parent()->_url(
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
		my $posters = $self->parent()->parent()->get_news_posters();
		if (defined $posters) {
			foreach my $account (@$posters) {
				my $p = $item->get_poster();
				my $level = $account->get_level();
				$html .= '<option value="' . $account->get_id() . '"'
					. (defined $p && $account->get_id() == $p->get_id()
						? ' selected="selected"' : '')
					. ' class="user-level-' . $level . '">'
					. $account->get_username()
					. ' &lt;' . $self->parent()->parent()->user_level_name($level)
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
		. $self->parent()->_url(
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

sub get_manage_accounts_html {
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
		. $self->parent()->_url(
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
	my $users = $self->parent()->parent()->get_accounts();
	if (defined $users) {
		foreach my $user (@$users) {
			$html .= '<option value="' . $user->get_id()
				. '" class="user-level-' . $user->get_level()
				. '">' . $user->get_username() . ' &lt;'
				. &_text_to_xhtml(
					$self->parent()->parent()->user_level_name($user->get_level()))
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
	foreach my $level ($self->parent()->parent()->user_levels()) {
		$html .= '<option value="' . $level . '" class="user-level-'
			. $level . '">' . &_text_to_xhtml(
				$self->parent()->parent()->user_level_name($level))
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

sub get_event_log_html {
	my $self = shift;
	my $locale = $self->parent()->locale();
	my $resurl = $self->parent()->_resources_url();
	my $url = $self->parent()->_url(
		Chirpy::UI::WebApp::ADMIN_ACTIONS->{'VIEW_EVENT_LOG'},
		1);
	$url .= ($url =~ /\?/ ? '&' : '?');
	my $html = '<script type="text/javascript" src="'
		. $resurl . '/js/ajax.js"></script>' . $/
		. '<script type="text/javascript" src="'
		. $resurl . '/js/administration.js"></script>' . $/
		. '<script type="text/javascript">' . $/
		. 'var eventLogURL = "' . $url . '";' . $/
		. 'var eventLogLocale = new Array();' . $/;
	foreach my $col (qw(id date username event empty)) {
		$html .= 'eventLogLocale["' . $col . '"] = "'
			.  &_text_to_xhtml($locale->get_string($col)) . '";' . $/;
	}
	$html .= 'eventLogLocale["previous"] = "' . &_text_to_xhtml(
		$locale->get_string('webapp.previous_page_title')) . '";' . $/
		. 'eventLogLocale["next"] = "' . &_text_to_xhtml(
		$locale->get_string('webapp.next_page_title')) . '";' . $/
		. 'eventLogLocale["loading"] = "' . &_text_to_xhtml(
		$locale->get_string('processing')) . '";' . $/
		. 'eventLogLocale["guest"] = "' . &_text_to_xhtml(
		$locale->get_string('guest')) . '";' . $/;
	foreach my $id (qw/code data/) {
		my $val = $self->parent()->_cgi_param($id);
		next unless (defined $val);
		$html .= 'eventLogURLParam["' . $id . '"] = "'
			. &_text_to_xhtml($val) . '";' . $/;
	}
	$html .= '</script>' . $/
		. '<div id="event-log-placeholder"></div>';
	return $html;
}

sub _serve_event_log_table_data {
	my $self = shift;
	my $locale = $self->parent()->locale();
	my $count = $self->parent()->_cgi_param('count');
	$count = (defined $count ? int $count : undef);
	my $start = $self->parent()->_cgi_param('start');
	$start = 0 unless (defined $start && $start >= 0);
	my $desc = ($self->parent()->_cgi_param('asc') ? 0 : 1);
	my $user = $self->parent()->_cgi_param('user');
	$user = undef if (defined $user && $user !~ /^\d+$/);	
	my $event = $self->parent()->_cgi_param('code');
	$event = undef if (defined $event && $event !~ /^\d+$/);
	my $filter = $self->parent()->_cgi_param('data');
	if (defined $filter && $filter =~ /^([^=]+)=(.*)$/s) {
		$filter = { $1 => $2 };
	}
	else {
		$filter = undef;
	}
	my ($events, $leading, $trailing) = $self->parent()->parent()->get_events(
		$start, $count, $desc, $event, $user, $filter);
	my @events = ();
	foreach my $event (@$events) {
		my $id = $event->get_id();
		my $date = $self->parent()->format_date_time($event->get_date());
		my $user = $event->get_user();
		my $username;
		if (defined $user) {
			my $acct = $self->parent()->parent()->get_account_by_id($user);
			if (defined $acct) {
				$username = $acct->get_username();
			}
		}
		my $description = Chirpy::Event::translate_code($event->get_code());
		my $data = $event->get_data();
		my $result = {
			'id' => $id,
			'date' => $date,
			(defined $username ? ('username' => $username) : ()),
			'userid' => (defined $user ? $user : 0),
			'description' => $description,
			'code' => $event->get_code()
		};
		my @data = ();
		foreach my $key (sort keys %$data) {
			my $value = $data->{$key};
			push @data, {
				'name' => &_text_to_xhtml($key),
				'value' => &_text_to_xhtml($value)
			};
		}
		$result->{'data'} = \@data;
		push @events, $result;
	}
	$self->parent()->_output_xml('result', {
		'event' => \@events,
		($leading ? ('leading' => 'true') : ()),
		($trailing ? ('trailing' => 'true') : ())
	});
}

sub get_access_disallowed_html {
	my $self = shift;
	return '<p id="insufficient-administrator-privileges-notification">'
		. &_text_to_xhtml($self->parent()->locale()->get_string(
			'insufficient_administrative_privileges'))
		. '</p>';
}

sub get_change_password_html {
	my ($self, %params) = @_;
	my $locale = $self->parent()->locale();
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
		. $self->parent()->_url(Chirpy::UI::WebApp::ADMIN_ACTIONS->{'CHANGE_PASSWORD'}, 1)
		. '">' . $/
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

*_text_to_xhtml = \&Chirpy::UI::WebApp::_text_to_xhtml;

1;

###############################################################################