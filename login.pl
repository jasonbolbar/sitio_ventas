#!/usr/bin/perl

use utils;

main();

sub main
{
	utils::addHeader();
	$content = utils::getTemplate('templates/login.html');
	print $content;
}
