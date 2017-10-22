use strict;
package Modules::Http::Request;
sub addHeader {
	print "Content-type: text/html\n\n";
}

sub getRequestData
{
    my ($expectedMethod) = @_;
    $expectedMethod //= 'GET';
    if( $ENV{"REQUEST_METHOD"} ne $expectedMethod  )
    {
        print("Status: 404 Not Found\n");
        addHeader();
        print "<h1> No existe url ($ENV{'REQUEST_METHOD'}) para $ENV{'REQUEST_URI'} <h1>";
        die;
    }
    my $xx;
    my $buffer;
    my %vars;
    if($ENV{"REQUEST_METHOD"} eq "GET")
    {
        $buffer=$ENV{'QUERY_STRING'};
    } 
    else 
    {
        read ( STDIN, $buffer, $ENV{"CONTENT_LENGTH"});
    }
    foreach my $pair (split(/&/, $buffer)) 
    {
        $pair =~ tr/+//;
        my ($name, $value) = split(/=/, $pair);
        $value =~ s/%(\w\w)/sprintf("%c", hex($1))/ge;
        $value=~s/\+/ /g;
        $vars{$name}="$value";
    }
    
    return %vars;
}

sub redirectTo {
	my ($redirectTo) = @_;
	print("Location: $redirectTo\n");
	print("Status: 302 Found\n");
	addHeader();
}
1;