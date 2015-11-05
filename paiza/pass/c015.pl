use 5.014;

chomp(my $n = <STDIN>);
my $point;
for (1..$n)
{
	chomp(my $receipt_line = <STDIN>);
	my ($date, $money) = split / /, $receipt_line;
	my $rate = 0.01;
	$rate *= 3 if ($date =~ /3/);
	$rate *= 5 if ($date =~ /5/);
	$point += int($money * $rate);
}
say $point;
