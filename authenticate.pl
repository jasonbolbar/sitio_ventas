#!/usr/bin/perl -w

use Modules::Http::Request;

main();

sub main
{
	Modules::Http::Request::redirectTo('/');
}