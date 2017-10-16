use strict;
package utils;
sub replace {
  my ($from,$to,$string) = @_;
  $string =~s/$from/$to/ig;                          #case-insensitive/global (all occurrences)

  return $string;
}

sub getTemplate {
	my ($filename) = @_;
	my $content = do 
	{
		local $/ = undef;
		open my $fh, "<", $filename or die "could not open $filename: $!";
		<$fh>;
	};
	return $content;
}

sub addHeader {
	print "Content-type: text/html\n\n";
}

sub setCookie {
	my ($cookieName, $cookieValue, $maxAge) = @_;
	$maxAge = $maxAge ? $maxAge : 3600;
	print "Set-Cookie: $cookieName=$cookieValue; Max-Age=$maxAge\n";
}

sub getCookies
{
  my %decode = ('\+'=>' ','\%3A\%3A'=>'::','\%26'=>'&','\%3D'=>'=',
             '\%2C'=>',','\%3B'=>';','\%2B'=>'+','\%25'=>'%');

  my %Cookies = ();
  foreach (split(/; /,$ENV{'HTTP_COOKIE'})) {
    my ($cookie,$value) = split(/=/);
    foreach my $ch ('\+','\%3A\%3A','\%26','\%3D','\%2C','\%3B','\%2B','\
+%25') {
      $cookie =~ s/$ch/$decode{$ch}/g;
      $value =~ s/$ch/$decode{$ch}/g;
    }
    $Cookies{$cookie} = $value;
  }
  return %Cookies;
}
1;