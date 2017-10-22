#!/usr/bin/perl -w

use Modules::Util;
use Modules::Http::Request;
use Modules::Renders::NavBar;
use Modules::Database::Querier;

main();

sub main
{
	Modules::Http::Request::addHeader();
	$query = getQuery();
	$content = Modules::Util::getFile('templates/layout.html');
	$content = Modules::Renders::NavBar::render($content);
	$content = Modules::Util::replace("<page-content>", Modules::Util::getFile('templates/table.html') , $content);
	$content = Modules::Util::replace("--title--", "Búsqueda", $content);
	$content = Modules::Util::replace("--subtitle--", "Resultados", $content);
	$content = Modules::Util::replace("--search-value--", "value = '$query'", $content);

	my $rows;
	my %products = Modules::Database::Querier::execute('CALL search_products(?);', $query);

	if ($products{'status'} == 1 ) {
		my $row;

		if (@{$products{'rows'}} != 0) {
			foreach  $result (@{$products{'rows'}}){
				$row = Modules::Util::getFile('templates/table-row.html');
				$row = Modules::Util::replace('--name--', $result->{'name'}, $row);
				$row = Modules::Util::replace('--description--', $result->{'description'}, $row);
				$row = Modules::Util::replace('--price--', $result->{'price'}, $row);

				$rows .= $row;
			}
		} else {
			$rows = Modules::Util::getFile('templates/search-no-results.html');
		}
	} else {	
		$rows = Modules::Util::getFile('templates/search-no-results.html');
	}

	$content = Modules::Util::replace("<rows>", $rows, $content);

	print $content;
}

sub getQuery 
{
	%parameters = Modules::Http::Request::getRequestData();
	return $parameters{'query'}
}