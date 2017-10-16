#!/usr/bin/perl -w

use utils;
use Modules::Http::Request;
main();

sub main
{
	Modules::Http::Request::addHeader();
	$query = getQuery();
	$content = utils::getTemplate('templates/layout.html');
	$content = utils::replace("<page-content>", utils::getTemplate('templates/search-no-results.html') , $content);
	$content = utils::replace("--title--", "Búsqueda", $content);
	$content = utils::replace("--subtitle--", "Resultados", $content);
	$content = utils::replace("--search-value--", "value = '$query'", $content);
	print $content;
}

sub getQuery 
{
	%parameters = Modules::Http::Request::getRequestData();
	return $parameters{'query'}
}