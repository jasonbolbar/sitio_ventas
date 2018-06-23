use strict;
use Modules::Http::Request;
use Modules::Database::Querier;
use Modules::Http::Cookie;
package Modules::Authentication;

use constant MAX_SESSION_AGE => 3600;
use constant MAX_ERROR_COOKIE_AGE => 2;

sub authenticateUser
{
	my ($username, $password) = @_;
	my %authentication = Modules::Database::Querier::execute(
		'call authenticate_user(?,?,?,?,?)',
		(
			$username,
			$password,
			MAX_SESSION_AGE,
			browserName(),
			ipAddress()
		)
	);
	if ( $authentication{'status'} == 1 )
	{
		if  ( $authentication{'rows'}[0]{'authenticated'} == 1 )
		{
			Modules::Http::Cookie::setCookie('session_id',$authentication{'rows'}[0]{'session_id'}, MAX_SESSION_AGE);
			Modules::Http::Cookie::setCookie('Success', 'Sesión iniciada correctamente', MAX_ERROR_COOKIE_AGE);	
			Modules::Http::Request::redirectTo('/');
		} else
		{
			Modules::Http::Cookie::setCookie('Error', 'Usuario y contraseña incorrecta',MAX_ERROR_COOKIE_AGE);
			Modules::Http::Request::redirectTo('/login');
		}
	} else
	{
		Modules::Http::Cookie::setCookie('Error', 'Ya existe una sesión activa para este usuario. Intentelo mas tarde',MAX_ERROR_COOKIE_AGE);
		Modules::Http::Request::redirectTo('/login');
	}
}

sub isUserAuthenticated
{
	my $session_id = Modules::Http::Cookie::getCookie('session_id');
	my %authenticated = Modules::Database::Querier::execute(
		'call is_authenticated(?,?,?)',
		(
			$session_id,
			browserName(),
			ipAddress()
		)
	);
	return $authenticated{'status'} ? $authenticated{'rows'}[0]{'authenticated'} : 0;
}

sub getSessionUserId {
	my $session_id = Modules::Http::Cookie::getCookie('session_id');
	my %userQuery = Modules::Database::Querier::execute(
		'select user_id from sessions where session_id = ? and expires_at > now() limit 1',( $session_id )
	);
	$userQuery{'status'} ? $userQuery{'rows'}[0]{'user_id'} : 0;
}

sub logout
{
	my $session_id = Modules::Http::Cookie::getCookie('session_id');
	my %logoutStatus = Modules::Database::Querier::do(
		'call logout(?)',
		(
			$session_id
		)
	);
	if ( $logoutStatus{'status'})
	{
		Modules::Http::Cookie::setCookie('session_id','DESTROYED', MAX_SESSION_AGE);
		Modules::Http::Cookie::setCookie('Success', 'Sesión finalizada correctamente', MAX_ERROR_COOKIE_AGE);	
	}
}

sub browserName {
	return $ENV{"HTTP_USER_AGENT"};
}

sub ipAddress {
	return $ENV{"REMOTE_ADDR"};
}
1;