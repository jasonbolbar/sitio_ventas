#!/usr/bin/perl -w

use utils;

main();

sub main
{
	utils::addHeader();
	$content = utils::getTemplate('templates/layout.html');
	$content = utils::replace("<page-content>", utils::getTemplate('templates/table.html') , $content);
	$content = utils::replace("--title--", "Artículos", $content);
	$content = utils::replace("--subtitle--", "Artículos", $content);
	print $content;
}

