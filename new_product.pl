#!/usr/bin/perl -w

use Modules::Util;
use Modules::Http::Request;

main();

sub main
{
	Modules::Http::Request::addHeader();
	$content = Modules::Util::getTemplate('templates/layout.html');
	$content = Modules::Util::replace("<nav-bar>", Modules::Util::getTemplate('templates/nav-bar.html') , $content);
	$content = Modules::Util::replace("<page-content>", Modules::Util::getTemplate('templates/new-product.html') , $content);
	$content = Modules::Util::replace("--title--", "Nuevo Artículo", $content);
	$content = Modules::Util::replace("--subtitle--", "Vender producto", $content);
	print $content;
}