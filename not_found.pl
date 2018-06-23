#!/usr/bin/perl -w

use Modules::Http::Request;
main();

sub main
{
	print("Status: 404 Not Found\n");
	Modules::Http::Request::addHeader();
	print "<title> No está disponible </title>";
	print "<h1> ($ENV{'REQUEST_METHOD'}) $ENV{'REQUEST_URI'} No está disponible </h1>";
}