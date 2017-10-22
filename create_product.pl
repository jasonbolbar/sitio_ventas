#!/usr/bin/perl -w

use Modules::Util;
use Modules::Http::Request;
use Modules::Database::Querier;
use Modules::Authentication;

main();

sub main
{
	my %product = Modules::Http::Request::getRequestData('POST');
	my $user_id = Modules::Authentication::getSessionUserId();
	my $sql = "INSERT INTO products (user_id, name, price, description, quantity) VALUES (?, ?, ?, ?, ?);";
	my %row = Modules::Database::Querier::execute($sql, $user_id, $product{'name'}, $product{'price'}, $product{'description'}, $product{'quantity'});

	if ($row{'status'} == 0) {
	   Modules::Http::Request::redirectTo('/new_product?alert=error');
	} else {
	   Modules::Http::Request::redirectTo('/?alert=success');
	}
}