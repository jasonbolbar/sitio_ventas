#!/usr/bin/perl -w
use Modules::Http::Request;
use Modules::Database::Querier;
use Modules::Authentication;

main();

sub main
{
	my %params = Modules::Http::Request::getRequestData('POST');
	my $user_id = Modules::Authentication::getSessionUserId();
	print $user_id;
	my %row = Modules::Database::Querier::execute(
		'CALL send_message(?, ?, ?, ?, ?);', 
		$user_id, $params{'message'}, $params{'name'}, $params{'email'}, $params{'phone'}
	);

	if ($row{'status'} == 0) {
	   Modules::Http::Request::redirectTo('/support?alert=error');
	} else {
	   Modules::Http::Request::redirectTo('/?alert=success');
	}
}