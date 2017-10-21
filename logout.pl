#!/usr/bin/perl -w

use Modules::Http::Request;
use Modules::Authentication;

main();

sub main
{
	if (Modules::Authentication::isUserAuthenticated() == 1)
	{
		Modules::Authentication::logout();
	}
	Modules::Http::Request::redirectTo('/');
}