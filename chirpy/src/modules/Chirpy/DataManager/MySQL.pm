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

Chirpy::DataManager::MySQL - Data manager class, based on a MySQL backend

=head1 REQUIREMENTS

Apart from a proper Chirpy! installation, this module requires the following
Perl modules:

 Data::Dumper
 DBD::mysql
 DBI

In addition, it needs access to a server running MySQL version 4.1 or higher.

=head1 CONFIGURATION

This module uses the following values from your configuration file:

=over 4

=item mysql.hostname

The name of the server to use. In most cases, this will be C<localhost>.

=item mysql.port

The port on which the MySQL server accepts connections. The default is C<3306>.

=item mysql.username

The username to use for MySQL connections.

=item mysql.password

The password to use for MySQL connections. Note that this password is readable
if the user gains access to the file, and while Chirpy! takes precautions to
make the configuration file inaccessible, it is also your responsibility to
make sure that no one finds your password.

=item mysql.database

The name of the MySQL database where Chirpy! will store its data. 

=item mysql.prefix

If your host only allows one database, Chirpy! can prefix its table names with
a custom prefix, so you can easily distinguish them. For instance, if you set
this value to C<chirpy_>, the tables will be called C<chirpy_quotes>,
C<chirpy_news>, etc.

=back

=head1 SESSIONS

This class fully implements L<Chirpy::UI::WebApp::Session::DataManager>, which
allows L<Chirpy::UI::WebApp> to use sessions.

=head1 AUTHOR

Tim De Pauw E<lt>ceetee@users.sourceforge.netE<gt>

=head1 SEE ALSO

L<Chirpy::DataManager>, L<Chirpy::UI::WebApp::Session::DataManager>, L<Chirpy>,
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

package Chirpy::DataManager::MySQL;

use strict;
use warnings;

use vars qw($VERSION $TARGET_VERSION @ISA);

$VERSION = '0.2';
@ISA = qw(Chirpy::DataManager Chirpy::UI::WebApp::Session::DataManager);

$TARGET_VERSION = 0.2;

use Chirpy 0.2;

use Chirpy::DataManager 0.2;
use Chirpy::UI::WebApp::Session::DataManager 0.2;

use Chirpy::Quote 0.2;
use Chirpy::Account 0.2;
use Chirpy::NewsItem 0.2;

use DBI;

use Data::Dumper;
$Data::Dumper::Indent = 0;
$Data::Dumper::Terse = 1;

sub new {
	my $class = shift;
	my $self = $class->SUPER::new(@_);
	my $dbh = DBI->connect('DBI:mysql:database=' . $self->param('database')
		. ($self->param('hostname')
			? ';host=' . $self->param('hostname')
			: '')
		. ($self->param('port') ? ';port=' . $self->param('port') : ''),
		$self->param('username'), $self->param('password'));
	Chirpy::die('Failed to connect to database: ' . DBI->errstr())
		unless (defined $dbh);
	$dbh->do('SET NAMES utf8');
	$self->{'dbh'} = $dbh;
	$self->{'prefix'} = $self->param('prefix');
	return bless($self, $class);
}

sub get_target_version {
	return $TARGET_VERSION;
}

sub DESTROY {
	my $self = shift;
	my $handle = $self->handle();
	return unless (defined $handle);
	$handle->disconnect();
}

sub set_up {
	my ($self, $accounts, $news, $quotes) = @_;
	my $prefix = $self->table_name_prefix();
	my $handle = $self->handle();
	$handle->do(q|
			CREATE TABLE `| . $prefix . q|accounts` (
				`id` int unsigned NOT NULL auto_increment,
				`username` varchar(32) NOT NULL,
				`password` varchar(32) NOT NULL,
				`level` tinyint(1) unsigned NOT NULL,
				PRIMARY KEY (`id`),
				UNIQUE KEY `username` (`username`)
			) TYPE=MyISAM DEFAULT CHARSET=utf8
		|) or Chirpy::die('Cannot create account table: ' . DBI->errstr());
	$handle->do(q|
			CREATE TABLE `| . $prefix . q|news` (
				`id` int unsigned NOT NULL auto_increment,
				`body` text NOT NULL,
				`poster` int unsigned default NULL,
				`date` timestamp NOT NULL default CURRENT_TIMESTAMP,
				PRIMARY KEY (`id`)
			) TYPE=MyISAM DEFAULT CHARSET=utf8
		|) or Chirpy::die('Cannot create news table: ' . DBI->errstr());
	$handle->do(q|
			CREATE TABLE `| . $prefix . q|quotes` (
				`id` int unsigned NOT NULL auto_increment,
				`body` text NOT NULL,
				`notes` text,
				`rating` int NOT NULL,
				`submitted` timestamp NOT NULL default CURRENT_TIMESTAMP,
				`approved` tinyint(1) unsigned NOT NULL,
				`flagged` tinyint(1) unsigned NOT NULL,
				PRIMARY KEY (`id`)
			) TYPE=MyISAM DEFAULT CHARSET=utf8
		|) or Chirpy::die('Cannot create quote table: ' . DBI->errstr());
	$handle->do(q|
			CREATE TABLE `| . $prefix . q|tags` (
				`id` int unsigned NOT NULL auto_increment,
				`tag` varchar(255) NOT NULL,
				PRIMARY KEY (`id`),
				INDEX (`tag`)
			) TYPE=MyISAM DEFAULT CHARSET=utf8
		|) or Chirpy::die('Cannot create tag table: ' . DBI->errstr());
	$handle->do(q|
			CREATE TABLE `| . $prefix . q|quote_tag` (
				`quote_id` int unsigned NOT NULL,
				`tag_id` int unsigned NOT NULL,
				INDEX (`quote_id`),
				INDEX (`tag_id`)
			) TYPE=MyISAM DEFAULT CHARSET=utf8
		|) or Chirpy::die('Cannot create quote tag table: ' . DBI->errstr());
	$handle->do(q|
			CREATE TABLE `| . $prefix . q|log` (
				`id` int unsigned NOT NULL auto_increment,
				`date` timestamp NOT NULL default CURRENT_TIMESTAMP,
				`code` int unsigned NOT NULL,
				`user` int unsigned,
				`data` text,
				PRIMARY KEY (`id`)
			) TYPE=MyISAM DEFAULT CHARSET=utf8
		|) or Chirpy::die('Cannot create log table: ' . DBI->errstr());
	$handle->do(q|
			CREATE TABLE `| . $prefix . q|sessions` (
				`id` varchar(32) NOT NULL,
				`data` text NOT NULL,
				UNIQUE KEY `id` (`id`)
			) TYPE=MyISAM DEFAULT CHARSET=utf8
		|) or Chirpy::die('Cannot create session table: ' . DBI->errstr());
	$handle->do(q|
			CREATE TABLE `| . $prefix . q|vars` (
				`name` VARCHAR(32) NOT NULL,
				`value` VARCHAR(255) NOT NULL,
				PRIMARY KEY (`name`)
			) TYPE=MyISAM DEFAULT CHARSET=utf8
		|) or Chirpy::die('Cannot create variable table: ' . DBI->errstr());
	if (defined $accounts) {
		foreach my $account (@$accounts) {
			$self->add_account($account);
		}
	}
	if (defined $news) {
		foreach my $item (@$news) {
			$self->add_news_item($item);
		}
	}
	if (defined $quotes) {
		foreach my $quote (@$quotes) {
			$self->add_quote($quote);
		}
	}
}

sub remove {
	my ($self, $accounts, $news, $quotes) = @_;
	my $prefix = $self->table_name_prefix();
	my $handle = $self->handle();
	$handle->do('DROP TABLE ' . $prefix . 'accounts')
		or Chirpy::die('Cannot remove account table: ' . DBI->errstr());
	$handle->do('DROP TABLE ' . $prefix . 'news')
		or Chirpy::die('Cannot remove news table: ' . DBI->errstr());
	$handle->do('DROP TABLE ' . $prefix . 'quotes')
		or Chirpy::die('Cannot remove quote table: ' . DBI->errstr());
	$handle->do('DROP TABLE ' . $prefix . 'log')
		or Chirpy::die('Cannot remove log table: ' . DBI->errstr());
	$handle->do('DROP TABLE ' . $prefix . 'sessions')
		or Chirpy::die('Cannot remove session table: ' . DBI->errstr());
}

sub get_quotes {
	my ($self, $params) = @_;
	$params = {} unless (ref $params eq 'HASH');
	my $query = 'SELECT `q`.`id` AS `id`, `body`, `notes`, `rating`,'
		. ' UNIX_TIMESTAMP(`submitted`) AS `submitted`, `approved`, `flagged`'
		. ' FROM `' . $self->table_name_prefix() . 'quotes` AS `q`';
	my @par = ();
	my @cond = ();
	if (defined $params->{'flagged'}) {
		push @cond, '`flagged` '
			. ($params->{'flagged'} ? '<>' : '=') . ' 0';
	}
	if (defined $params->{'approved'}) {
		push @cond, '`approved` '
			. ($params->{'approved'} ? '<>' : '=') . ' 0';
	}
	if (defined $params->{'contains'} && @{$params->{'contains'}}) {
		foreach my $q (@{$params->{'contains'}}) {
			my $query = '%' . $q . '%';
			push @cond, '(`body` LIKE ? OR `notes` LIKE ?)';
			push @par, $query, $query;
		}
	}
	if (defined $params->{'tags'} && @{$params->{'tags'}}) {
		$query .= ' JOIN `' . $self->table_name_prefix() . 'quote_tag` AS `qt`'
			. ' ON `q`.`id` = `qt`.`quote_id`'
			. ' JOIN `' . $self->table_name_prefix() . 'tags` AS `t`'
			. ' ON `qt`.`tag_id` = `t`.`id`';
		my @tags = @{$params->{'tags'}};
		push @cond, '`tag` IN (?' . (',?' x (scalar(@tags) - 1)) . ')';
		push @par, @tags;
	}
	if (defined $params->{'since'}) {
		push @cond, '`submitted` > FROM_UNIXTIME(?)';
		push @par, $params->{'since'};
	}
	if (defined $params->{'id'}) {
		push @cond, '`id` = ?';
		push @par, $params->{'id'};
		delete $params->{'first'};
		delete $params->{'sort'};
	}
	if (@cond) {
		$query .= ' WHERE ' . join(' AND ', @cond);
	}
	if ($params->{'random'}) {
		$query .= ' ORDER BY RAND()';
	}
	elsif (ref $params->{'sort'} eq 'ARRAY') {
		$query .= ' ORDER BY ' . join(', ', map {
				'`q`.`' . $_->[0] . '`' . ($_->[1] ? ' DESC' : '')
			} @{$params->{'sort'}});
	}
	my $per_page;
	my $leading;
	if (defined $params->{'id'}) {
		$query .= ' LIMIT 1';
	}
	elsif ($params->{'count'}) {
		$query .= ' LIMIT ';
		if ($params->{'first'}) {
			$leading = 1;
			$query .= '?,';
			push @par, $params->{'first'};
		}
		$query .= '?';
		push @par, $params->{'count'} + 1;
		$per_page = $params->{'count'};
	}
	my $sth = $self->handle()->prepare($query);
	$self->_db_error() unless (defined $sth);
	my $rows = $sth->execute(@par);
	$self->_db_error() unless (defined $rows);
	my $trailing;
	my @result = ();
	while (my $row = $sth->fetchrow_hashref()) {
		if ($per_page && @result >= $per_page) {
			$trailing = 1;
			last;
		}
		push @result, new Chirpy::Quote(
			$row->{'id'}, Chirpy::Util::decode_utf8($row->{'body'}),
			Chirpy::Util::decode_utf8($row->{'notes'}),
			$row->{'rating'}, $row->{'submitted'},
			$row->{'approved'}, $row->{'flagged'},
			$self->_quote_tags($row->{'id'})
		);
	}
	my $result = (@result ? \@result : undef);
	return ($result, $leading, $trailing) if (wantarray);
	return $result;
}

sub quote_count {
	my ($self, $params) = @_;
	$params = {} unless (ref $params eq 'HASH');
	my $appr = $params->{'approved'};
	return $self->_execute_scalar('SELECT COUNT(*) FROM `'
		. $self->table_name_prefix() . 'quotes`'
		. (defined $appr ? ' WHERE `approved` = ' . ($appr ? '1' : '0') : ''));
}

sub add_quote {
	my ($self, $quote) = @_;
	$self->_do('INSERT INTO `' . $self->table_name_prefix() . 'quotes`'
		. ' (`body`, `notes`, `approved`)'
		. ' VALUES (?, ?, ?)',
		$quote->get_body(),
		$quote->get_notes(),
		$quote->get_approved() || 0);
	my $id = $self->handle()->{'mysql_insertid'};
	$self->_tag($id, $quote->get_tags());
	return $id;
}

sub modify_quote {
	my ($self, $quote) = @_;
	Chirpy::die('Not a Chirpy::Quote')
		unless (ref $quote eq 'Chirpy::Quote');
	my $result = $self->_do('UPDATE `' . $self->table_name_prefix() . 'quotes`'
		. ' SET `body` = ?, `notes` = ? WHERE `id` = ?',
		$quote->get_body(), $quote->get_notes(), $quote->get_id());
	$self->_replace_tags($quote->get_id(), $quote->get_tags());
	return $result;
}

sub increase_quote_rating {
	my ($self, $id) = @_;
	$self->_do('UPDATE `' . $self->table_name_prefix() . 'quotes`'
		. ' SET `rating` = `rating` + 1 WHERE `id` = ' . $id . ' LIMIT 1')
			or return undef;
	return $self->_get_quote_rating($id);
}

sub decrease_quote_rating {
	my ($self, $id) = @_;
	$self->_do('UPDATE `' . $self->table_name_prefix() . 'quotes`'
		. ' SET `rating` = `rating` - 1 WHERE `id` = ' . $id . ' LIMIT 1')
			or return undef;
	return $self->_get_quote_rating($id);
}

sub get_tag_use_counts {
	my $self = shift;
	my $query = 'SELECT `tag`, COUNT(`tag_id`) AS `cnt`'
		. ' FROM `' . $self->table_name_prefix() . 'quote_tag` AS `qt`'
		. ' JOIN `' . $self->table_name_prefix() . 'tags` AS `t`'
			. ' ON `qt`.`tag_id` = `t`.`id`'
		. ' GROUP BY `tag`';
	my $sth = $self->handle()->prepare($query);
	$self->_db_error() unless (defined $sth);
	my $rows = $sth->execute();
	$self->_db_error() unless (defined $rows);
	my %result = ();
	while (my $row = $sth->fetchrow_hashref()) {
		$result{$row->{'tag'}} = $row->{'cnt'};
	}
	return \%result;
}

sub approve_quotes {
	my ($self, @ids) = @_;
	return undef unless (@ids);
	return $self->_do('UPDATE `' . $self->table_name_prefix() . 'quotes`'
		. ' SET `approved` = 1 WHERE `id` IN ('
		. join(',', map { int } @ids) . ') LIMIT ' . scalar @ids);
}

sub flag_quotes {
	my ($self, @ids) = @_;
	return undef unless (@ids);
	return $self->_do('UPDATE `' . $self->table_name_prefix() . 'quotes`'
		. ' SET `flagged` = 1 WHERE `id` IN ('
		. join(',', map { int } @ids) . ') LIMIT ' . scalar @ids);
}

sub unflag_quotes {
	my ($self, @ids) = @_;
	return undef unless (@ids);
	return $self->_do('UPDATE `' . $self->table_name_prefix() . 'quotes`'
		. ' SET `flagged` = 0 WHERE `id` IN ('
		. join(',', map { int } @ids) . ') LIMIT ' . scalar @ids);
}

sub remove_quote {
	my ($self, $quote) = @_;
	Chirpy::die('Not a Chirpy::Quote')
		unless (ref $quote eq 'Chirpy::Quote');
	my $id = quote->get_id();
	$self->_untag_all($id);
	return $self->_do('DELETE FROM `' . $self->table_name_prefix() . 'quotes`'
		. ' WHERE `id` = ' . $id
		. ' LIMIT 1');
}

sub remove_quotes {
	my ($self, @ids) = @_;
	return undef unless (@ids);
	$self->_untag_all(@ids);
	return $self->_do('DELETE FROM `' . $self->table_name_prefix() . 'quotes`'
		. ' WHERE `id` IN (' . join(',', map { int } @ids) . ')'
		. ' LIMIT ' . scalar @ids);
}

sub get_news_items {
	my ($self, $params) = @_;
	my $query = 'SELECT N.id, N.body, N.poster, '
		. 'UNIX_TIMESTAMP(N.date) AS `date`, A.username '
		. 'FROM `' . $self->table_name_prefix() . 'news` N'
		. ' LEFT JOIN `' . $self->table_name_prefix() . 'accounts` A'
		. ' ON N.poster = A.id';
	my @par = ();
	if ($params->{'id'}) {
		$query .= ' WHERE N.id = ?';
		push @par, $params->{'id'};
		$params->{'count'} = 1;
	}
	$query .= ' ORDER BY `date` DESC';
	if ($params->{'count'}) {
		$query .= ' LIMIT ?';
		push @par, $params->{'count'};
	}
	my $sth = $self->handle()->prepare($query);
	$self->_db_error() unless (defined $sth);
	my $rows = $sth->execute(@par);
	$self->_db_error() unless (defined $rows);
	my @result = ();
	while (my $row = $sth->fetchrow_hashref()) {
		my $item = new Chirpy::NewsItem(
			$row->{'id'}, Chirpy::Util::decode_utf8($row->{'body'}),
			($row->{'username'}
				? new Chirpy::Account($row->{'poster'}, $row->{'username'})
				: undef),
			$row->{'date'}
		);
		push @result, $item;
	}
	return (@result ? \@result : undef);
}

sub add_news_item {
	my ($self, $news) = @_;
	Chirpy::die('Not a Chirpy::NewsItem')
		unless (ref $news eq 'Chirpy::NewsItem');
	my $poster = $news->get_poster();
	$self->_do('INSERT INTO `' . $self->table_name_prefix() . 'news`'
		. ' (`body`, `poster`)'
		. ' VALUES (?, ?)',
		$news->get_body(), (defined $poster ? $poster->get_id() : undef),
		$news->get_date());
	my $id = $self->handle()->{'mysql_insertid'};
	return $id;
}

sub modify_news_item {
	my ($self, $item) = @_;
	Chirpy::die('Not a Chirpy::NewsItem')
		unless (ref $item eq 'Chirpy::NewsItem');
	my $poster = $item->get_poster();
	return $self->_do('UPDATE `' . $self->table_name_prefix() . 'news`'
		. ' SET `body` = ?, `poster` = ? WHERE `id` = ? LIMIT 1',
		$item->get_body(), (defined $poster ? $poster->get_id() : undef),
		$item->get_id());
}

sub remove_news_item {
	my ($self, $item) = @_;
	Chirpy::die('Not a Chirpy::NewsItem')
		unless (ref $item eq 'Chirpy::NewsItem');
	return $self->_do('DELETE FROM `' . $self->table_name_prefix() . 'news`'
		. ' WHERE `id` = ' . $item->get_id()
		. ' LIMIT 1');
}

sub remove_news_items {
	my ($self, @ids) = @_;
	return undef unless (@ids);
	return $self->_do('DELETE FROM `' . $self->table_name_prefix() . 'news`'
		. ' WHERE `id` IN (' . join(',', map { int } @ids) . ')'
		. ' LIMIT ' . scalar @ids);
}

sub get_accounts {
	my ($self, $params) = @_;
	$params = {} unless (ref $params eq 'HASH');
	my $query = 'SELECT * FROM `' . $self->table_name_prefix() . 'accounts`';
	my @cond = ();
	my @par = ();
	if (ref $params->{'levels'} eq 'ARRAY') {
		push @cond, '`level` IN (' . join (',', @{$params->{'levels'}}) . ')';
	}
	if ($params->{'id'}) {
		push @cond, '`id` = ?';
		push @par, $params->{'id'};
	}
	if ($params->{'username'}) {
		push @cond, '`username` = ?';
		push @par, $params->{'username'};
	}
	if (@cond) {
		$query .= ' WHERE ' . join(' AND ', @cond);
	}
	$query .= ' ORDER BY `level` DESC, `username`';
	my $sth = $self->handle()->prepare($query);
	$self->_db_error() unless (defined $sth);
	my $rows = $sth->execute(@par);
	$self->_db_error() unless (defined $rows);
	my @result = ();
	while (my $row = $sth->fetchrow_hashref()) {
		push @result, new Chirpy::Account(
			$row->{'id'}, $row->{'username'}, $row->{'password'},
			$row->{'level'}
		);
	}
	return (@result ? \@result : undef);
}

sub add_account {
	my ($self, $user) = @_;
	$self->_do('INSERT INTO `' . $self->table_name_prefix() . 'accounts`'
		. ' (`username`, `password`, `level`) VALUES (?, ?, ?)',
		$user->get_username(), $user->get_password(), $user->get_level());
	my $id = $self->handle()->{'mysql_insertid'};
	return $id;
}

sub modify_account {
	my ($self, $account) = @_;
	Chirpy::die('Not a Chirpy::Account')
		unless (ref $account eq 'Chirpy::Account');
	return $self->_do('UPDATE `' . $self->table_name_prefix() . 'accounts`'
		. ' SET `username` = ?, `password` = ?, `level` = ?'
		. ' WHERE `id` = ? LIMIT 1',
		$account->get_username(), $account->get_password(),
		$account->get_level(), $account->get_id());
}

sub remove_account {
	my ($self, $account) = @_;
	Chirpy::die('Not a Chirpy::Account')
		unless (ref $account eq 'Chirpy::Account');
	$self->_do('UPDATE `' . $self->table_name_prefix()
		. 'news` SET `poster` = NULL WHERE `poster` = ' . $account->get_id()
		. ' LIMIT 1');
	return $self->_do('DELETE FROM `' . $self->table_name_prefix()
		. 'accounts` WHERE `id` = ' . $account->get_id()
		. ' LIMIT 1');
}

sub remove_accounts {
	my ($self, @ids) = @_;
	return undef unless (@ids);
	my $ids = join(',', map { int } @ids);
	my $num = scalar @ids;
	$self->_do('UPDATE `' . $self->table_name_prefix()
		. 'news` SET `poster` = NULL WHERE `poster` IN (' . $ids . ')'
		. ' LIMIT ' . $num);
	return $self->_do('DELETE FROM `' . $self->table_name_prefix()
		. 'accounts` WHERE `id` IN (' . $ids . ')'
		. ' LIMIT ' . $num);
}

sub username_exists {
	my ($self, $username) = @_;
	return $self->_do('SELECT `id` FROM `' . $self->table_name_prefix()
		. 'accounts` WHERE `username` = ? LIMIT 1', $username) ? 1 : 0;
}

sub account_count {
	my ($self, $params) = @_;
	$params = {} unless (ref $params eq 'HASH');
	return $self->_execute_scalar('SELECT COUNT(*) FROM `'
		. $self->table_name_prefix() . 'accounts`'
		. (defined $params->{'levels'}
			? ' WHERE `level` IN (' . join(',', @{$params->{'levels'}}) . ')'
			: ''));
}

sub log_event {
	my ($self, $event) = @_;
	Chirpy::die('Not a Chirpy::Event')
		unless (ref $event eq 'Chirpy::Event');
	my $user = $event->get_user();
	$self->_do('INSERT INTO `' . $self->table_name_prefix() . 'log`'
		. ' (`code`, `user`, `data`)'
		. ' VALUES (?, ?, ?)',
		$event->get_code(),
		(defined $user ? $user->get_id() : undef),
		&_serialize($event->get_data()));
	my $id = $self->handle()->{'mysql_insertid'};
	$event->set_id($id);
	return $id;
}

sub add_session {
	my ($self, $id, $data) = @_;
	my $string = &_serialize($data);
	$self->_do('INSERT INTO `' . $self->table_name_prefix() . 'sessions`'
		. ' (`id`, `data`) VALUES (?, ?)', $id, $string);
}

sub get_sessions {
	my ($self, @ids) = @_;
	my $query = 'SELECT `id`, `data` FROM `' . $self->table_name_prefix()
		. 'sessions`';
	$query .= ' WHERE `id` IN (?' . (',?' x (scalar(@ids) - 1)) . ')'
		. ' LIMIT ' . scalar(@ids) if (@ids);
	my $sth = $self->handle()->prepare($query);
	$self->_db_error() unless (defined $sth);
	my $rows = $sth->execute(@ids);
	$self->_db_error() unless (defined $rows);
	my @results = ();
	while (my $row = $sth->fetchrow_hashref()) {
		push @results, &_unserialize($row->{'data'});
	}
	return @results;
}

sub modify_session {
	my ($self, $id, $data) = @_;
	my $string = &_serialize($data);
	my $sql = 'UPDATE `' . $self->table_name_prefix()
		. 'sessions` SET `data` = ? WHERE `id` = ? LIMIT 1';
	$self->_do($sql, $string, $id);
}

sub remove_sessions {
	my ($self, @ids) = @_;
	return unless (@ids);
	$self->_do('DELETE FROM `' . $self->table_name_prefix() . 'sessions`'
		. ' WHERE `id` IN (?' . (',?' x (scalar(@ids) - 1)) . ')'
		. ' LIMIT ' . scalar(@ids), @ids);
}

sub last_session_cleanup {
	my ($self, $timestamp) = @_;
	unless (defined $timestamp) {
		return $self->_execute_scalar('SELECT `value` FROM `'
			. $self->table_name_prefix() . 'vars`'
			. ' WHERE `name` = ?', 'last_session_cleanup');
	}
	my $res = $self->_do('UPDATE `' . $self->table_name_prefix() . 'vars`'
		. ' SET `value` = ?'
		. ' WHERE `name` = ? LIMIT 1',
			$timestamp, 'last_session_cleanup');
	unless ($res) {
		$self->_do('INSERT INTO `' . $self->table_name_prefix() . 'vars`'
			. ' (`name`, `value`) VALUES (?, ?)',
			'last_session_cleanup', $timestamp);
	}
}

sub handle {
	my $self = shift;
	return $self->{'dbh'};
}

sub table_name_prefix {
	my $self = shift;
	return $self->{'prefix'};
}

sub _quote_tags {
	my ($self, $quote_id, $mode) = @_;
	$mode = 0 unless (defined $mode);
	my $cols = ($mode == 2 ? '`tag`, `id`' : ($mode == 1 ? '`id`' : '`tag`'));
	my $query = 'SELECT ' .$cols
		. ' FROM `' . $self->table_name_prefix() . 'tags` AS `t`'
		. ' JOIN `' . $self->table_name_prefix() . 'quote_tag` AS `qt`'
			. ' ON `t`.`id` = `qt`.`tag_id`'
		. ' WHERE `quote_id` = ?';
	my $sth = $self->handle()->prepare($query);
	$self->_db_error() unless (defined $sth);
	my $rows = $sth->execute($quote_id);
	$self->_db_error() unless (defined $rows);
	if ($mode == 2) {
		my %result = ();
		while (my $row = $sth->fetchrow_arrayref()) {
			$result{$row->[0]} = $row->[1];
		}
		return \%result;
	}
	my @result = ();
	while (my $row = $sth->fetchrow_arrayref()) {
		push @result, $row->[0];
	}
	return \@result;
}

sub _tag {
	my ($self, $quote_id, $tags) = @_;
	return unless (@$tags);
	foreach my $tag (@$tags) {
		my $tag_id = $self->_tag_id($tag);
		unless (defined $tag_id) {
			$tag_id = $self->_create_tag($tag);
		}
		$self->_do('INSERT INTO `' . $self->table_name_prefix() . 'quote_tag`'
			. ' (`quote_id`, `tag_id`) VALUES (?, ?)', $quote_id, $tag_id);
	}
}

sub _untag {
	my ($self, $quote_id, $tag_ids) = @_;
	my $cnt = scalar @$tag_ids;
	return unless ($cnt);
	$self->_do('DELETE FROM `' . $self->table_name_prefix() . 'quote_tag`'
		. ' WHERE `quote_id` = ? AND `tag_id` IN (?' . (',?' x ($cnt - 1)) . ')'
		. ' LIMIT ' . $cnt, $quote_id, @$tag_ids);
}

sub _untag_all {
	my ($self, @quote_ids) = @_;
	foreach my $id (@quote_ids) {
		$self->_do('DELETE FROM `' . $self->table_name_prefix() . 'quote_tag`'
			. ' WHERE `quote_id` = ?', $id);
	}
	$self->_clean_up_tags();
}

sub _tag_id {
	my ($self, $tag) = @_;
	return $self->_execute_scalar('SELECT `id` FROM `'
		. $self->table_name_prefix() . 'tags` WHERE `tag` = ? LIMIT 1', $tag);
}

sub _create_tag {
	my ($self, $tag) = @_;
	$self->_do('INSERT INTO `' . $self->table_name_prefix() . 'tags`'
		. ' (`tag`) VALUES (?)', $tag);
	return $self->handle()->{'mysql_insertid'};
}

sub _replace_tags {
	my ($self, $quote_id, $new_tags) = @_;
	my $old_tags = $self->_quote_tags($quote_id, 2);
	my @add = ();
	foreach my $tag (@$new_tags) {
		if (exists $old_tags->{$tag}) {
			delete $old_tags->{$tag};
		}
		else {
			push @add, $tag;
		}
	}
	my @remove = values %$old_tags;
	$self->_untag($quote_id, \@remove);
	$self->_clean_up_tags();
	$self->_tag($quote_id, \@add);
}

sub _clean_up_tags {
	my $self = shift;
	$self->_do('DELETE FROM `' . $self->table_name_prefix() . 'tags`'
		. ' WHERE `id` NOT IN ('
		. 'SELECT `tag_id` FROM `' . $self->table_name_prefix() . 'quote_tag`'
		. ')');
}

sub _get_quote_rating {
	my ($self, $id) = @_;
	my $sth = $self->handle()->prepare('SELECT `rating`'
		. ' FROM `' . $self->table_name_prefix() . 'quotes`'
		. ' WHERE `id` = ' . $id . ' LIMIT 1');
	$self->_db_error() unless (defined $sth);
	my $rows = $sth->execute();
	$self->_db_error() unless (defined $rows);
	my @row = $sth->fetchrow_array();
	return $row[0];
}

sub _do {
	my ($self, $query, @params) = @_;
	my $rows = $self->handle()->do($query, undef, @params);
	$self->_db_error() unless (defined $rows);
	return ($rows eq '0E0' ? 0 : $rows);
}

sub _execute_scalar {
	my ($self, $query, @params) = @_;
	my $sth = $self->handle()->prepare($query);
	$self->_db_error() unless (defined $sth);
	my $rows = $sth->execute(@params);
	$self->_db_error() unless (defined $rows);
	my @row = $sth->fetchrow_array();
	return (scalar(@row) ? $row[0] : undef);
}

sub _serialize {
	return Dumper(@_);
}

sub _unserialize {
	my $string = shift;
	return (defined $string ? eval $string : undef);
}

sub _db_error {
	my $self = shift;
	my $msg = $self->handle()->errstr();
	Chirpy::die($msg);
}

1;

###############################################################################