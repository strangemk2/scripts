# Write a program which will print out a numeric shape according to input to the program. The input is an integer number N (N>=1). The output is an N x N square together with its diagonal lines. Number increases by 1 from row to row. However if row# >= 10, print its last digit only.
# Note:
# 1.  No extra space is allowed before or after each line.
# 2.  Please use standard input and output to solve.
# 3.  Please submit source code and executable file if compilation needed

#!/usr/bin/perl

use 5.016;
use strict;

sub last_digit { @_[0] % 10; }

my $number = $ARGV[0] or exit 1;

# first line
say 1 x $number;
# mid lines
for my $line (2..$number-1)
{
	my @content = (undef, (' ') x $number);
	$content[1] = $content[$number] =
		$content[$line] = $content[-$line] = last_digit($line);

	say join '', @content;
}
# last line
say last_digit($number) x $number if $number > 1;
