#!/usr/bin/perl -w

use Modules::Util;
use Modules::Http::Cookie;
use Modules::Http::Request;

main();

sub main
{
	Modules::Http::Request::addHeader();
	$content = Modules::Util::getFile('templates/layout.html');
	$content = Modules::Util::replace("<nav-bar>", Modules::Util::getFile('templates/nav-bar.html') , $content);
	$content = Modules::Util::replace("<page-content>", Modules::Util::getFile('templates/table.html') , $content);
	$content = Modules::Util::replace("--title--", "Artículos", $content);
	$content = Modules::Util::replace("--subtitle--", "Artículos", $content);
	$content = Modules::Util::replace("--search-value--","", $content);

	my $rows = '';
	#my $sql = 'SELECT * FROM available_products;';
	#my $sth = $dbh->prepare($sql);
	#$sth->execute();
	#while (@data = $sth->fetchrow_array()) {

	#}
	$content = Modules::Util::replace("--rows--", $rows, $content);
	print $content;
}

