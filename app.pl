#!/usr/bin/perl -w

use utils;
use Modules::Http::Cookie;
use Modules::Http::Request;

main();

sub main
{
	Modules::Http::Request::addHeader();
	$content = utils::getTemplate('templates/layout.html');
	$content = utils::replace("<page-content>", utils::getTemplate('templates/table.html') , $content);
	$content = utils::replace("--title--", "Artículos", $content);
	$content = utils::replace("--subtitle--", "Artículos", $content);
	$content = utils::replace("--search-value--","", $content);
	print $content;
}

