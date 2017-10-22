#!/usr/bin/perl -w
use Modules::Http::Request;
use Modules::Database::Querier;
use Modules::Authentication;

main();

sub main
{
	my %params = Modules::Http::Request::getRequestData('POST');
	my $user_id = Modules::Authentication::getSessionUserId();
	%validMessage = validateMessage(%params, $user_id);
	$user_id = $user_id ? $user_id : 0;
	if ( $validMessage{'valid'} )
	{
		my %row = Modules::Database::Querier::execute(
			'CALL send_message(?, ?, ?, ?, ?);', 
			$user_id, $params{'message'}, $params{'name'}, $params{'email'}, $params{'phone'}
		);

		if ($row{'status'}) {
			Modules::Http::Cookie::setCookie('Success', 'Mensaje enviado con exito', 5);
			Modules::Http::Request::redirectTo('/');
		} else {
			Modules::Http::Cookie::setCookie('Error', "Error al enviar el mensaje, $row{'message'}", 5);
		    Modules::Http::Request::redirectTo('/support');
		}
    }else
	{
		Modules::Http::Cookie::setCookie('Error', $validMessage{'errors'}, 5);
		Modules::Http::Request::redirectTo('/support');
	}
}

sub validateMessage {
	my (%message, $user_id) = @_;
	$valid = 1;
	$errors = '';
	if (!user_id){
		if ( $message{'name'} !~/[\D\W ]+/ || length $message{'name'} < 15 || length $message{'name'} > 35 ) 
		{
			$valid = 0;
			$errors .= 'Nombre completo incorrecto (entre 15 a 35 caracteres). ';
		}
		if ( $message{'email'} !~ /^[a-z0-9][a-z0-9.]+\@[a-z0-9.-]+$/ && length $message{'email'} > 35 ) 
		{
			$valid = 0;
			$errors .= 'Correo electrónico incorrecto (35 caracteres máximo, no sigue el standard). ';
		}
		if ( $message{'phone'} !~/[\d]/ || length $message{'phone'} > 11 || length $message{'phone'} < 8 )
		{
			$valid = 0;
			$errors .= 'Teléfono incorrecto (entre 8 a 11 caracteres, solo números). ';
		}
	}
	if ( length $message{'message'} > 120 || length $message{'message'} < 5 )
	{
		$valid = 0;
		$errors .= 'Mensaje incorrecto (entre 5 y 120 caracteres). ';
	}
	return ( 'valid' => $valid, 'errors'=>$errors );
}