#!/usr/bin/perl -w
use Modules::Database::Querier;

main();

sub main
{
	my $cart_id = getCartID();
	
	my $products_in_cart = Modules::Database::Querier::::execute('SELECT * FROM shopping_cart_products WHERE cart_id = ?;', $cart_id);
	
	if ($products{'status'} == 1 and @{$products{'rows'}} != 0) {
		foreach $product in (@{$products_in_cart{'rows'}}) {
			if ($product->{'quantity'} > $product->{'in_stock'}) {
				Modules::Database::Querier::do('DELETE FROM items where cart_id = ? AND product_id = ?;', $cart_id, $product->{'id'});
			} else {
				$leftover = $product->{'in_stock'} - $product->{'quantity'};
				Modules::Database::Querier::do('UPDATE products SET quantity = ? WHERE id = ?;', $leftover, $product->{'id'});
			}
		}
		Modules::Database::Querier::do('UPDATE shopping_carts SET finished = 0 WHERE id = ?;', $cart_id);
		Modules::Http::Cookie::setCookie('Success', 'Productos comprados correctamente', 5);	
		Modules::Http::Request::redirectTo('/');
	}

}

sub getCartID 
{
	%parameters = Modules::Http::Request::getRequestData('POST');
	return $parameters{'id'};
}