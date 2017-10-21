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


1;