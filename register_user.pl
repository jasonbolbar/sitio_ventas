#!/usr/bin/perl -w

use Modules::Http::Request;
use Modules::Authentication;
use Modules::Database::Querier;
use Modules::Http::Cookie;

main();

sub main
{
	%user = Modules::Http::Request::getRequestData('POST');
	%validUser = validateUser(%user);
	if ( $validUser{'valid'} )
	{
		%status = Modules::Database::Querier::do(
			'call register_user(?,?,?,?,?,?)',
			(
				$user{'full_name'},
				$user{'email'},
				$user{'phone'},
				$user{'address'},
				$user{'username'},
				$user{'psw'}
			)
		);
		if ($status{'status'}) {
			 Modules::Authentication::authenticateUser($user{'username'}, $user{'psw'});
		} else {
			Modules::Http::Request::redirectTo('/sign_in');
		}
	} else
	{
		Modules::Http::Cookie::setCookie('Error', $validUser{'errors'}, 5);
		Modules::Http::Request::redirectTo('/sign_in');
	}
}

sub validateUser {
	my (%user) = @_;
	$valid = 1;
	$errors = '';
	if ( $user{'full_name'} !~/[\D\W ]+/ || length $user{'full_name'} < 15 || length $user{'full_name'} > 35 ) 
	{
		$valid = 0;
		$errors .= 'Nombre completo incorrecto (entre 15 a 35 caracteres). ';
	}
	if ( $user{'email'} !~ /^[a-z0-9][a-z0-9.]+\@[a-z0-9.-]+$/ && length $user{'email'} > 35 ) 
	{
		$valid = 0;
		$errors .= 'Correo electrónico incorrecto (35 caracteres máximo, no sigue el standard). ';
	}
	if ( $user{'phone'} !~/[\d]/ || length $user{'phone'} > 11 || length $user{'phone'} < 8 )
	{
		$valid = 0;
		$errors .= 'Teléfono incorrecto (entre 8 a 11 caracteres, solo números). ';
	}
	if ( length $user{'address'} > 120 )
	{
		$valid = 0;
		$errors .= 'Dirección incorrecta (120 caracteres máximo). ';
	}
	if ( $user{'username'} !~/[a-z0-9]/ || length $user{'username'} > 20 || length $user{'username'} < 4 )
	{
		$valid = 0;
		$errors .= 'Nombre de usuario incorrecto (solo letras minusculas y números entre 4 a 20 caracteres). ';
	}
	if ( length $user{'psw'} > 15 || length $user{'psw'} < 8 )
	{
		$valid = 0;
		$errors .=  'Contraseña no valida (entre 8 a 15 caracteres). ';
	}
	if ( usernameExists($user{'username'}) )
	{
	    $valid = 0;
		$errors .=  'El nombre de usuario ya existe. ';	
	}
	return ( 'valid' => $valid, 'errors'=>$errors );
}

sub usernameExists {
	my ($username) = @_;
	%query = Modules::Database::Querier::execute(
		'select count(*) as user_count from users where username = ?', ($username));	
	return $query{'status'} ? $query{'rows'}[0]{'user_count'} > 0 : 1;
}