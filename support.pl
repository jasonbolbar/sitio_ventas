#!/usr/bin/perl -w

use Modules::Util;
use Modules::Http::Request;

main();

sub main
{
	Modules::Http::Request::addHeader();
	$content = Modules::Util::getFile('templates/layout.html');
	$content = Modules::Util::replace("<nav-bar>", Modules::Util::getFile('templates/nav-bar.html') , $content);
	$content = Modules::Util::replace("<page-content>", Modules::Util::getFile('templates/support.html') , $content);
	$content = Modules::Util::replace("--title--", "Ayuda", $content);
	$content = Modules::Util::replace("--subtitle--", "Consultas, retroalimentación y reclamos", $content);
	print $content;
}