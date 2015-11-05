use 5.014;
chomp(my $num = <STDIN>);
for (1..$num)
{
	chomp(my $n = <STDIN>);
	say judge_perfect_number($n);
}

sub judge_perfect_number
{
	my $n = shift;
	my $count;
	for (1..$n-1)
	{
		if ($n % $_ == 0)
		{
			$count += $_;
		}
	}
	if ($count == $n)
	{
		return 'perfect';
	}
	elsif (abs($count - $n) == 1)
	{
		return 'nearly';
	}
	else
	{
		return 'neither';
	}
}
