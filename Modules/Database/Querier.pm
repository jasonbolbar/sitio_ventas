use strict;
use DBI;
use	Modules::Util;
package Modules::Database::Querier;



my $establishConnection = sub 
{
	my $connectionConfiguration = Modules::Util::getFile('Modules/Database/.env');
	my %settings = ();
	foreach (split(/\n/,$connectionConfiguration)) 
	{
		my ($set,$value) = split(/=/);
		$value=~ s/\W//g;
		$settings{$set} = $value;
	}
	my $dsn ="DBI:mysql:database=$settings{'DATABASE'};host=$settings{'HOST'}";
	return DBI->connect($dsn,$settings{'USERNAME'},$settings{'PASSWORD'});
};

my $perfomrQuery = sub {
	my ($sql, $callback, $successCallback) = @_;
	my $dbh = $establishConnection->();
	my $sth = $dbh->prepare($sql);
	my %result = ();
	$callback->($sth);
	if ($sth->err())
	{
		$result{'message'} = $sth->errstr();
		$result{'status'} = 0;
		return %result;
	} else 
	{
	    $result{'status'} = 1;
	    if ( $successCallback )
	    {
	    	my @rows = $successCallback->($sth);
	    	$result{'rows'} = \@rows; 
	    }
	}
	$sth->finish();
	$dbh->disconnect();
	return %result;
};

sub execute 
{
	my ($sql, @params) = @_;
	return $perfomrQuery->($sql, sub{
		my (my $query) = @_;
		if ( @params ) 
		{
			$query->execute(@params);
		} else {
			$query->execute();
		}
	} , sub {
		my (my $query) = @_;
		my @rows = ();
		while ( my $row = $query->fetchrow_hashref() ) {
		   push @rows, $row;
		}
		return @rows;
	} );
}

sub do
{
	my ($sql, @params) = @_;
	return $perfomrQuery->($sql, sub{
		my (my $query) = @_;
		if ( @params ) 
		{
			$query->execute(@params);
		} else {
			$query->execute();
		}
	});
}
1;