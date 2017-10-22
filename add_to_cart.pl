#!/usr/bin/perl -w

use Modules::Http::Request;
use Modules::Http::Cookie;
use Modules::Database::Querier;
use Modules::Authentication;
main();

sub main
{

	if (Modules::Authentication::isUserAuthenticated() == 1)
	{
		%parameters = Modules::Http::Request::getRequestData();
		$product_id = $parameters{'product_id'};
		$user_id = Modules::Authentication::getSessionUserId();
		%query = Modules::Database::Querier::execute(
			'call add_product_to_cart(?,?)', 
			(
				$user_id,
				$product_id,
			)
		);
		if ($query{'status'})
		{
			if ($query{'rows'}[0]{'status'})
			{
				Modules::Http::Cookie::setCookie('Success', $query{'rows'}[0]{'message'} ,2);
			    Modules::Http::Request::redirectTo('/shoppings');
			} else
			{
				Modules::Http::Cookie::setCookie('Error', $query{'rows'}[0]{'message'} ,2);
			    Modules::Http::Request::redirectTo('/');
			}
		} else {
			Modules::Http::Cookie::setCookie('Error', 'Error al intentar agregar el producto al carrito de compras',2);
			Modules::Http::Request::redirectTo('/');
		}
	} else {
		Modules::Http::Cookie::setCookie('Error', 'Debe estar autenticado para realizar esta acción', 5);
		Modules::Http::Request::redirectTo('/');
	}

}