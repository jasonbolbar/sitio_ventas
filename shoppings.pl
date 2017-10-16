#!/usr/bin/perl -w

use utils;

main();

sub main
{
	utils::addHeader();
	$content = utils::getTemplate('templates/layout.html');
	$content = utils::replace("<page-content>", utils::getTemplate('templates/shopping_cart.html') , $content);
	$content = utils::replace("--title--", "Carrito de Compras", $content);
	$content = utils::replace("--subtitle--", "Mis compras", $content);
	print $content;
}