#!/usr/bin/perl -w

use utils;

main();

sub main
{
	utils::addHeader();
	$content = utils::getTemplate('templates/layout.html');
	$content = utils::replace("<page-content>", utils::getTemplate('templates/search-no-results.html') , $content);
	$content = utils::replace("--title--", "Búsqueda", $content);
	$content = utils::replace("--subtitle--", "Resultados", $content);
	print $content;
}