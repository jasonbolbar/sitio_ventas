#!/usr/bin/perl -w

use Modules::Util;
use Modules::Http::Request;
use Modules::Database::Querier;

main();

sub main
{
	Modules::Http::Request::addHeader();
	my %product = Modules::Http::Request::getRequestData('POST');
	my $sql = "INSERT INTO products (user_id, name, price, description, quantity) VALUES (?, ?, ?, ?, ?);";
	my %row = Modules::Database::Querier::execute($sql, $user_id, $product{'name'}, $product{'price'}, $product{'description'}, $product{'quantity'});
	print $row
	#if (not defined $rows) {
	   #print 'Se ha producido un error' ;
	#} else {
	   #print 'El artículo se ha creado correctamente';
	   #Modules::Http::Request::redirectTo('/');
	#}
}