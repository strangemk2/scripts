my $max;
my $min;
for (1..5)
{
	chomp(my $num = <STDIN>);
	$max = $num if (!defined($max) || $num > $max);
	$min = $num if (!defined($min) || $num < $min);
}
print "$max\n$min\n";
