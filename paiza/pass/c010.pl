use 5.014;
chomp(my $header_line = <STDIN>);
my ($a, $b, $R) = split / /, $header_line;

chomp(my $tree_num = <STDIN>);
for (1..$tree_num)
{
	chomp(my $tree_line = <STDIN>);
	my ($x, $y) = split / /, $tree_line;

	if (is_enough_distance($a, $b, $x, $y, $R))
	{
		say 'silent';
	}
	else
	{
		say 'noisy';
	}
}

sub is_enough_distance
{
	my ($a, $b, $x, $y, $R) = @_;
	my $pow = sub { $_[0] * $_[0] };
	return ($pow->($x - $a) + $pow->($y - $b)) >= $pow->($R);
}
