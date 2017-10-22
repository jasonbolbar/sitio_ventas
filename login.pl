#!/usr/bin/perl -w

use Modules::Util;
use Modules::Http::Request;
use Modules::Authentication;
use Modules::Renders::Alert;
main();

sub main
{
	if (Modules::Authentication::isUserAuthenticated() == 1)
	{
		Modules::Http::Cookie::setCookie('Error', 'Ya se encuentra autenticado', 5);
		Modules::Http::Request::redirectTo('/');
	} else 
	{
		Modules::Http::Request::addHeader();
		$content = Modules::Util::getFile('templates/layout.html');
		$content = Modules::Util::replace("<page-content>", Modules::Util::getFile('templates/login.html') , $content);
		$content = Modules::Renders::Alert::render($content);
		$content = Modules::Util::replace("--title--", "Autenticarse", $content);
		$content = Modules::Util::replace("--subtitle--", "", $content);
		print $content;
	}
}

