#!/usr/bin/perl

use utils;

main();

sub main
{
	utils::addHeader();
	$content = utils::getTemplate('templates/layout.html');
	$content = utils::replace("<product-table>", utils::getTemplate('templates/table.html') , $content);
	$content = utils::replace("--title--", "Productos", $content);
	print $content;
}

