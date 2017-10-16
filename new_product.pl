#!/usr/bin/perl -w

use utils;

main();

sub main
{
	utils::addHeader();
	$content = utils::getTemplate('templates/layout.html');
	$content = utils::replace("<page-content>", utils::getTemplate('templates/new-product.html') , $content);
	$content = utils::replace("--title--", "Nuevo Artículo", $content);
	$content = utils::replace("--subtitle--", "Vender producto", $content);
	print $content;
}