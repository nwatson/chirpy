<?
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

###############################################################################
# chirpy_rqms_import.php                                                      #
# Imports data from an existing RQMS installation into Chirpy!                #
###############################################################################

###############################################################################
# CONFIGURATION                                                               #
###############################################################################

// Chirpy!'s table prefix: same as in the configuration.
$chirpy_table_prefix = 'chirpy_';

// Set this to false to keep this script from emptying Chirpy!'s tables first.
// This can be useful if you want to import your Rash installation's quotes
// AFTER using Chirpy! for a while. Note that setting this option to true will
// copy Rash's quote IDs, which can be useful if you want to keep existing
// links intact, while a value of false will not guarantee that.
$clear_chirpy_tables = true;

// Rash only saves the date of news items, not the time. To compensate, time
// is set to midnight in your time zone. Enter your time zone here. This needs
// to be a time zone that Perl's strtotime() function can understand, or the
// script will not work properly. Both GMT offsets like ‘+0200’ (no colon!)
// and zones like ‘CET’ should be supported.
$timezone = 'GMT';

###############################################################################
# DO NOT TOUCH ANYTHING BELOW THIS LINE                                       #
###############################################################################

require('config.php');

set_magic_quotes_runtime(0);
error_reporting(E_ALL);

header('Content-Type: text/plain; charset=UTF-8');

log_event('Connecting to ‘' . $hostname . '’ …', true);
mysql_connect($hostname, $username, $dbpasswd)
	or die('Database connection failed: ' . mysql_error());

log_event('Accessing database ‘' . $dbname . '’ …', true);
mysql_select_db($dbname)
	or die('Failed to select database: ' . mysql_error());

if ($clear_chirpy_tables) {
	log_event('Clearing Chirpy!’s tables …');
	clear_table($chirpy_table_prefix . 'accounts');
	clear_table($chirpy_table_prefix . 'news');
	clear_table($chirpy_table_prefix . 'quotes');
	log_event('Tables cleared', true);
}

log_event('Importing user information …');
$users_result = mysql_query('SELECT * FROM `' . $rashusers . '`')
	or die('Error retrieving user information: ' . mysql_error());
$count_users = 0;
while ($row = mysql_fetch_array($users_result)) {
	$count_users++;
	mysql_query('INSERT INTO `' . $chirpy_table_prefix . 'accounts`'
		. ' (`username`, `password`, `level`)'
		. ' VALUES ("' . $row['user'] . '", "' . $row['password'] . '", '
		. convert_level($row['level']) . ')')
			or die('Error importing user information: ' . mysql_error());
}
log_event('Users imported: ' . $count_users, true);
mysqL_free_result($users_result);

log_event('Importing news items …');
$news_result = mysql_query('SELECT * FROM `' . $newstable . '`')
	or die('Error retrieving news: ' . mysql_error());
$count_news = 0;
while ($row = mysql_fetch_array($news_result)) {
	$count_news++;
	$date = date_to_timestamp($row['date']);
	if ($date <= 0)
		die('Unable to convert ‘' + $row['date'] + '’ into a UNIX timestamp');
	mysql_query('INSERT INTO `' . $chirpy_table_prefix . 'news`'
		. ' (`body`, `date`)'
		. ' VALUES ("' . addslashes(decode_html($row['news']))
		. '", FROM_UNIXTIME(' . $date . '))')
			or die('Error importing news item: ' . mysql_error());
}
log_event('News items imported: ' . $count_news, true);
mysqL_free_result($news_result);

log_event('Importing quotes …');
$quotes_result = mysql_query('SELECT * FROM `' . $quotetable . '`')
	or die('Error retrieving quotes: ' . mysql_error());
$count_quotes = 0;
while ($row = mysql_fetch_array($quotes_result)) {
	$count_quotes++;
	mysql_query('INSERT INTO `' . $chirpy_table_prefix . 'quotes` ('
		. ($clear_chirpy_tables ? '`id`, ' : '')
		. '`body`, `rating`, `submitted`, `approved`, `flagged`)'
		. ' VALUES ('
		. ($clear_chirpy_tables ? $row['id'] . ', ' : '')
		. '"' . addslashes(decode_html($row['quote']))
		. '", ' . $row['rating']
		. ', FROM_UNIXTIME(' . $row['date'] . ')'
		. ', ' . ($row['approve'] ? 1 : 0)
		. ', ' . ($row['check'] ? 0 : 1) . ')')
			or die('Error importing quote: ' . mysql_error());
}
log_event('Quotes imported: ' . $count_quotes, true);
mysqL_free_result($quotes_result);

log_event('Importing unverified quotes …');
$unverified_quotes_result = mysql_query('SELECT * FROM `' . $subtable . '`')
	or die('Error retrieving unverified quotes: ' . mysql_error());
$count_unverified_quotes = 0;
while ($row = mysql_fetch_array($unverified_quotes_result)) {
	$count_unverified_quotes++;
	mysql_query('INSERT INTO `' . $chirpy_table_prefix . 'quotes`'
		. ' (`body`, `submitted`)'
		. ' VALUES ("' . decode_html($row['quote'])
		. '", FROM_UNIXTIME(' . time() . '))')
			or die('Error importing unverified quote: ' . mysql_error());
}
log_event('Unverified quotes imported: ' . $count_unverified_quotes, true);
mysqL_free_result($unverified_quotes_result);

log_event('Closing database connection …', true);
mysql_close();

log_event('Import finished!');

function clear_table ($name) {
	mysql_query('TRUNCATE TABLE `' . $name . '`')
		or die('Error clearing table ‘' . $name . '’: ' . mysql_error());
	mysql_query('ALTER TABLE`' . $name . '` AUTO_INCREMENT = 1')
		or die('Error resetting auto-increment index for table ‘' . $name
			. '’: ' . mysql_error());
}

function convert_level ($level) {
	return ($level && $level >= 1 && $level <= 3 ? (4 - $level) * 3 : 0);
}

function decode_html ($text) {
	return html_entity_decode(
		preg_replace('|\s*<\s*br\s*/?\s*>\s*|', "\n", $text));
}

function date_to_timestamp ($date) {
	global $timezone;
	$date .= ' 00:00 ' . $timezone;
	return strtotime($date);
}

function log_event ($text, $end_segment) {
	echo $text . "\r\n";
	if ($end_segment) echo "\r\n";
}

###############################################################################
?>