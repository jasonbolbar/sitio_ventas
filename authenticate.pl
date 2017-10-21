#!/usr/bin/perl -w

use Modules::Http::Request;
use Modules::Authentication;

main();

sub main
{
	if (Modules::Authentication::isUserAuthenticated() == 1)
	{
		Modules::Http::Request::redirectTo('/');
	} else 
	{
		%credentials = Modules::Http::Request::getRequestData();
		Modules::Authentication::authenticateUser($credentials{'usrname'}, $credentials{'psw'});
	}
}