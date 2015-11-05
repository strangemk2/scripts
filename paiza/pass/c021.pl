use 5.014;

chomp(my $header_line = <STDIN>);
my ($xc, $yc, $r1, $r2) = split / /, $header_line;

chomp(my $n = <STDIN>);
for (1..$n)
{
	chomp(my $coordinator_line = <STDIN>);
	my ($x, $y) = split / /, $coordinator_line;

	my $powerd_distance = pow2($x - $xc) + pow2($y - $yc);
	if (pow2($r1) <= $powerd_distance && $powerd_distance <= pow2($r2))
	{
		say 'yes';
	}
	else
	{
		say 'no';
	}
}

sub pow2
{
	return $_[0] * $_[0];
}
