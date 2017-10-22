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

		$content = Modules::Util::replace("<cart-rows>", Modules::Util::getFile('templates/cart-row.html') , $content);

		my $user_id = Modules::Authentication::getSessionUserId();
		my %cart = Modules::Database::Querier::::execute('SELECT id FROM active_shopping_carts WHERE user_id = ?', $user_id);
		
		if ($cart{'status'} = 1 and @{$cart{'rows'}} != 0) {
			my $rows;
			my $cart_id = $cart['id'];
			my %products = Modules::Database::Querier::::execute('SELECT * FROM shopping_cart_products WHERE cart_id = ?;', $cart_id);

			if ($products{'status'} == 1 and @{$products{'rows'}} != 0) {
				my $row;
				my $no_product = '<span class="w3-tag w3-red w3-round">Agotado!</span>';
				foreach  $result (@{$products{'rows'}}){
					$row = Modules::Util::getFile('templates/cart-row.html');
					$row = Modules::Util::replace('--name--', $result->{'name'}, $row);
					$row = Modules::Util::replace('--quantity--', $result->{'quantity'}, $row);
					if ($product->{'in_stock'} == 0) {
						$row = Modules::Util::replace('--price--', $no_product, $row);
					} else {
						$row = Modules::Util::replace('--price--', $result->{'price'}, $row);
					}
					$row = Modules::Util::replace('--product-id--', $result->{'id'}, $row);
					$rows .= $row;
				}
				
			} else {	
				$rows = Modules::Util::getFile('templates/search-no-results.html');
			}

			$content = Modules::Util::replace("<rows>", $rows, $content);
		}

		print $content;
	} else 
	{
		Modules::Http::Cookie::setCookie('Error', 'Debe estar autenticado para acceder a esta sección', 5);
		Modules::Http::Request::redirectTo('/');
	}
}