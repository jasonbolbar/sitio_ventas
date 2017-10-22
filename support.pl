#!/usr/bin/perl -w

use Modules::Util;
use Modules::Http::Request;
use Modules::Renders::NavBar;
use Modules::Authentication;

main();

sub main
{
	Modules::Http::Request::addHeader();
	$content = Modules::Util::getFile('templates/layout.html');
	$content = Modules::Renders::NavBar::render($content);
	$content = Modules::Util::replace("<page-content>", Modules::Util::getFile('templates/support.html') , $content);
	$content = Modules::Util::replace("--title--", "Ayuda", $content);
	$content = Modules::Util::replace("--subtitle--", "Consultas, retroalimentación y reclamos", $content);

	my $user_id = Modules::Authentication::getSessionUserId();
	if (!$user_id) {
		$content = Modules::Util::replace('<person-data>',  Modules::Util::getFile('templates/person_data_form.html') , $content);
	}

	print $content;
}