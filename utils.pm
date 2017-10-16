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
1;