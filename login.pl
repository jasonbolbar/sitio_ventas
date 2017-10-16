#!/usr/bin/perl -w

use utils;
use Modules::Http::Request;
main();

sub main
{
	Modules::Http::Request::addHeader();
	$content = utils::getTemplate('templates/login.html');
	print $content;
}

