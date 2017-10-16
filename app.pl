#!/usr/bin/perl -w

use Modules::Util;
use Modules::Http::Cookie;
use Modules::Http::Request;

main();

sub main
{
	Modules::Http::Request::addHeader();
	$content = Modules::Util::getTemplate('templates/layout.html');
	$content = Modules::Util::replace("<nav-bar>", Modules::Util::getTemplate('templates/nav-bar.html') , $content);
	$content = Modules::Util::replace("<page-content>", Modules::Util::getTemplate('templates/table.html') , $content);
	$content = Modules::Util::replace("--title--", "Artículos", $content);
	$content = Modules::Util::replace("--subtitle--", "Artículos", $content);
	$content = Modules::Util::replace("--search-value--","", $content);
	print $content;
}

