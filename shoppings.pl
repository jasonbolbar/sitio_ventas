#!/usr/bin/perl -w

use Modules::Util;
use Modules::Http::Request;

main();

sub main
{
	Modules::Http::Request::addHeader();
	$content = Modules::Util::getTemplate('templates/layout.html');
	$content = Modules::Util::replace("<nav-bar>", Modules::Util::getTemplate('templates/nav-bar.html') , $content);
	$content = Modules::Util::replace("<page-content>", Modules::Util::getTemplate('templates/shopping_cart.html') , $content);
	$content = Modules::Util::replace("--title--", "Carrito de Compras", $content);
	$content = Modules::Util::replace("--subtitle--", "Mis compras", $content);
	print $content;
}