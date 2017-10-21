#!/usr/bin/perl -w

use Modules::Http::Request;
use Modules::Authentication;

main();

sub main
{
	%credentials = Modules::Http::Request::getRequestData();
	Modules::Authentication::authenticateUser($credentials{'usrname'}, $credentials{'psw'});
}