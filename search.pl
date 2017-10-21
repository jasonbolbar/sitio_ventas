#!/usr/bin/perl -w

use Modules::Util;
use Modules::Http::Request;
use Modules::Renders::NavBar;
main();

sub main
{
	Modules::Http::Request::addHeader();
	$query = getQuery();
	$content = Modules::Util::getFile('templates/layout.html');
	$content = Modules::Renders::NavBar::render($content);
	$content = Modules::Util::replace("<page-content>", Modules::Util::getFile('templates/search-no-results.html') , $content);
	$content = Modules::Util::replace("--title--", "Búsqueda", $content);
	$content = Modules::Util::replace("--subtitle--", "Resultados", $content);
	$content = Modules::Util::replace("--search-value--", "value = '$query'", $content);
	print $content;
}

sub getQuery 
{
	%parameters = Modules::Http::Request::getRequestData();
	return $parameters{'query'}
}