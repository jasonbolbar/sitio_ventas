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
		$user_id = Modules::Authentication::getSessionUserId();
		my %deleteQuery = Modules::Database::Querier::do(
			'DELETE FROM items WHERE user_id = ? and product_id = ?',
			($user_id,$params{'product_id'})
		);
		if ( $deleteQuery{'status'} )
		{
			Modules::Http::Cookie::setCookie('Success', 'Producto eliminado satisfactoriamente', 5);
		} else {
			Modules::Http::Cookie::setCookie('Error', 'Error al eliminar el producto', 5);
		}
		Modules::Http::Request::redirectTo('/shoppings');
	} else {
		Modules::Http::Cookie::setCookie('Error', 'Debe estar autenticado para realizar esta acción', 5);
		Modules::Http::Request::redirectTo('/');
	}
}