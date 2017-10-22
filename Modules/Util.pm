use strict;
package Modules::Util;
sub replace {
  my ($from,$to,$string) = @_;
  $string =~s/$from/$to/ig;                          #case-insensitive/global (all occurrences)

  return $string;
}

sub getFile {
	my ($filename) = @_;
	my $content = do 
	{
		local $/ = undef;
		open my $fh, "<", $filename or die "could not open $filename: $!";
		<$fh>;
	};
	return $content;
}

sub currencyFormat {
  my $number = shift @_;
  # Add one comma each time through the do-nothing loop
  1 while $number =~ s/^(-?\d+)(\d\d\d)/$1.$2/;
  # Put the dollar sign in the right place
  $number =~ s/^(-?)/$1\₡/;
  $number;
}


1;