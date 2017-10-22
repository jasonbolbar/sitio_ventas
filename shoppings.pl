#!/usr/bin/perl -w

use Modules::Util;
use Modules::Http::Request;
use Modules::Renders::NavBar;
use Modules::Renders::Alert;
main();

sub main
{

    if (Modules::Authentication::isUserAuthenticated() == 1)
	{
		Modules::Http::Request::addHeader();
		$content = Modules::Util::getFile('templates/layout.html');
		$content = Modules::Renders::NavBar::render($content);
		$content = Modules::Renders::Alert::render($content);
		$content = Modules::Util::replace("<page-content>", Modules::Util::getFile('templates/shopping_cart.html') , $content);
		$content = Modules::Util::replace("--title--", "Carrito de Compras", $content);
		$content = Modules::Util::replace("--subtitle--", "Mis compras", $content);
		print $content;
	} else 
	{
		Modules::Http::Request::redirectTo('/');
	}
}