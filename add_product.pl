#!/usr/bin/perl -w

use Modules::Util;
use Modules::Http::Request;
main();

sub main
{
	Modules::Http::Request::addHeader();
	my %product = Modules::Http::Request::getRequestData('POST');
	my $sql = "INSERT INTO products (user_id, name, price, description, quantity) VALUES (?, ?, ?, ?, ?);";
	my $numrows = $dbh->do( 
			$sql, 
			undef, 
			$user_id, $baz, $product{'name'}, $product{'price'}, $product{'description'}, $product{'quantity'} 
		);
	if (not defined $numrows) {
	   print STDERR "ERROR: $DBI::errstr";
	} else {
	   print STDERR 'El artículo se ha creado correctamente';
	   Modules::Http::Request::redirectTo('/');
	}
}