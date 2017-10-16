#!/usr/bin/perl -w

use utils;

main();

sub main
{
	utils::addHeader();
	$content = utils::getTemplate('templates/layout.html');
	$content = utils::replace("<page-content>", utils::getTemplate('templates/support.html') , $content);
	$content = utils::replace("--title--", "Ayuda", $content);
	$content = utils::replace("--subtitle--", "Consultas, retroalimentación y reclamos", $content);
	print $content;
}