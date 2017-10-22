#!/usr/bin/perl -w

use Modules::Util;
use Modules::Http::Cookie;
use Modules::Http::Request;
use Modules::Database::Querier;	
use Modules::Renders::NavBar;
use Modules::Renders::Alert;

main();

sub main
{
	Modules::Http::Request::addHeader();
	$content = Modules::Util::getFile('templates/layout.html');
	$content = Modules::Renders::NavBar::render($content);
	$content = Modules::Renders::Alert::render($content);
	$content = Modules::Util::replace("<page-content>", Modules::Util::getFile('templates/table.html'), $content);
	$content = Modules::Util::replace("--title--", "Artículos", $content);
	$content = Modules::Util::replace("--subtitle--", "Artículos", $content);
	$content = Modules::Util::replace("--search-value--","", $content);

	my $rows;
	my %products = Modules::Database::Querier::execute('SELECT * FROM available_products;');

	if ($products{'status'} == 1 ) {
		my $row;

		if (@{$products{'rows'}} != 0) {
			foreach  $result (@{$products{'rows'}}){
				$row = Modules::Util::getFile('templates/table-row.html');
				$row = Modules::Util::replace('--name--', $result->{'name'}, $row);
				$row = Modules::Util::replace('--description--', $result->{'description'}, $row);
				$row = Modules::Util::replace('--price--', Modules::Util::currencyFormat($result->{'price'}), $row);
				$row = Modules::Util::replace('--product-id--', $result->{'id'}, $row);
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