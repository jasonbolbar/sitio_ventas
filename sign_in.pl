#!/usr/bin/perl -w

use Modules::Util;
use Modules::Http::Request;

main();

sub main
{
	Modules::Http::Request::addHeader();
	$content = Modules::Util::getTemplate('templates/layout.html');
	$content = Modules::Util::replace("<page-content>", Modules::Util::getTemplate('templates/sign-in.html') , $content);
	$content = Modules::Util::replace("--title--", "Nuevo Usuario", $content);
	$content = Modules::Util::replace("--subtitle--", "Registrarse", $content);
	print $content;
}