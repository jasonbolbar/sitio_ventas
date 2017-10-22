#!/usr/bin/perl -w
use Modules::Database::Querier;
use Modules::Authentication;

main();

sub main
{
	my $user_id = Modules::Authentication::getSessionUserId();
	if ($user_id) {

		my %cart = Modules::Database::Querier::execute('SELECT id FROM active_shopping_carts WHERE user_id = ?', $user_id);
		
		if ($cart{'status'} == 1 and @{$cart{'rows'}} != 0) {
			my $cart_id = $cart{'rows'}[0]->{'id'};
			
			my %products = Modules::Database::Querier::execute('SELECT * FROM shopping_cart_products WHERE cart_id = ?;', $cart_id);
			
			if ($products{'status'} == 1 and @{$products{'rows'}} != 0) {
				my $leftover;
				foreach $product (@{$products{'rows'}}) {
					if ($product->{'quantity'} > $product->{'in_stock'}) {
						Modules::Database::Querier::do('DELETE FROM items where cart_id = ? AND product_id = ?;', $cart_id, $product->{'id'});
					} else {
						$leftover = $product->{'in_stock'} - $product->{'quantity'};
						Modules::Database::Querier::do('UPDATE products SET quantity = ? WHERE id = ?;', $leftover, $product->{'id'});
					}
				}
				Modules::Database::Querier::do('UPDATE shopping_carts SET finished = 1 WHERE id = ?;', $cart_id);
				Modules::Http::Cookie::setCookie('Success', 'Productos comprados correctamente', 5);	
				Modules::Http::Request::redirectTo('/');
			}
		}
	}

}