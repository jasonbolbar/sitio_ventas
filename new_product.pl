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
		$content = Modules::Util::getFile('templates/layout.html');
		$content = Modules::Renders::NavBar::render($content);
		$content = Modules::Renders::Alert::render($content);
		$content = Modules::Util::replace("<page-content>", Modules::Util::getFile('templates/new-product.html') , $content);
		$content = Modules::Util::replace("--title--", "Nuevo Artículo", $content);
		$content = Modules::Util::replace("--subtitle--", "Vender producto", $content);
	} else 
	{
		Modules::Http::Request::redirectTo('/');
	}
	Modules::Http::Request::addHeader();
	print $content;
}