#!/usr/bin/perl -w

use Modules::Util;
use Modules::Http::Request;
use Modules::Database::Querier;
use Modules::Authentication;

main();

sub main
{
	if (Modules::Authentication::isUserAuthenticated() == 1)
	{
		my %params = Modules::Http::Request::getRequestData();
		$cart_id = getUserCart();
		if ($cart_id != 0)
		{
			my %deleteQuery = Modules::Database::Querier::do(
				'DELETE FROM items WHERE cart_id = ? and product_id = ?',
				($cart_id,$params{'product_id'})
			);
			if ( $deleteQuery{'status'} )
			{
				Modules::Http::Cookie::setCookie('Success', 'Producto eliminado satisfactoriamente', 5);
			} else {
				Modules::Http::Cookie::setCookie('Error', 'Error al eliminar el producto', 5);
			}
			Modules::Http::Request::redirectTo('/shoppings');
		} else {
			Modules::Http::Cookie::setCookie('Error', 'Error al eliminar el producto, parece que el carrito no existe', 5);
		    Modules::Http::Request::redirectTo('/shoppings');
		}
	} else {
		Modules::Http::Cookie::setCookie('Error', 'Debe estar autenticado para realizar esta acción', 5);
		Modules::Http::Request::redirectTo('/');
	}
}

sub getUserCart
{
	my($user_id) = @_;
	%cartQuery = Modules::Database::Querier::execute(
		'select id as cart_id from active_shopping_carts where user_id = ? limit 1',
		(Modules::Authentication::getSessionUserId())
	);
	return $cartQuery{'status'} ? $cartQuery{'rows'}[0]{'cart_id'} : 0;
}