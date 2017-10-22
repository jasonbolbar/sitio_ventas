#!/usr/bin/perl -w

use Modules::Util;
use Modules::Http::Request;
use Modules::Database::Querier;
use Modules::Authentication;

main();

sub main
{
	my %product = Modules::Http::Request::getRequestData('POST');
	%validProduct = validateProduct(%product);
	if ( $validProduct{'valid'} )
	{
		my $user_id = Modules::Authentication::getSessionUserId();
		my $sql = "INSERT INTO products (user_id, name, price, description, quantity) VALUES (?, ?, ?, ?, ?);";
		my %row = Modules::Database::Querier::execute($sql, $user_id, $product{'name'}, $product{'price'}, $product{'description'}, $product{'quantity'});

		if ($row{'status'} == 0) {
			Modules::Http::Cookie::setCookie('Error', 'Error al intentar agregar el producto', 5);
		    Modules::Http::Request::redirectTo('/new_product');
		} else {
		 	Modules::Http::Cookie::setCookie('Success', 'Producto Agregado Satisfactoriamente', 5);	
		   	Modules::Http::Request::redirectTo('/');
		}
	} else
	{
		Modules::Http::Cookie::setCookie('Error', $validProduct{'errors'}, 5);
		Modules::Http::Request::redirectTo('/new_product?alert=error');
	}
}

sub validateProduct {
	my (%product) = @_;
	$valid = 1;
	$errors = '';
	if ( length $product{'name'} < 5 || length $product{'name'} > 40 ) 
	{
		$valid = 0;
		$errors .= 'Nombre del producto incorrecto (entre 5 a 40 caracteres). ';
	}
	if ( $product{'price'} !~ /[0-9.]+/ ) 
	{
		$valid = 0;
		$errors .= 'Precio incorrecto (solo se permite números, requerido). ';
	}
	if ( length $product{'description'} > 120  )
	{
		$valid = 0;
		$errors .= 'Descripción incorrecta (120 caracteres máximo). ';
	}
	if (  $product{'quantity'} > 10 || $product{'quantity'} < 1 )
	{
		$valid = 0;
		$errors .= 'Se debe tener entre 1 a 10 unidades de este producto. ';
	}
	
	return ( 'valid' => $valid, 'errors'=>$errors );
}