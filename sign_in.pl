#!/usr/bin/perl -w

use utils;

main();

sub main
{
	utils::addHeader();
	$content = utils::getTemplate('templates/layout.html');
	$content = utils::replace("<page-content>", utils::getTemplate('templates/sign-in.html') , $content);
	$content = utils::replace("--title--", "Nuevo Usuario", $content);
	$content = utils::replace("--subtitle--", "Registrarse", $content);
	print $content;
}