sub max
{
	my $ret = 0;

	foreach (@_)
	{
		if ($ret < $_)
		{
			$ret = $_;
		}
	}

	return $ret;
}

sub cutl
{
	my $number = shift;
	if ($number >= 0)
	{
		if (int($number) == $number)
		{
			return $number;
		}
		else
		{
		   	return int($number) + 1;
		}
	}
	else
	{
		return int($number);
	}
}

sub cutr
{
	my $number = shift;
	if ($number >= 0)
	{
		return int($number);
	}
	else
	{
		if (int($number) == $number)
		{
			return $number
		}
		else
		{
			return int($number) - 1;
		}
	}
}

my $input_lines = <STDIN>;
my %results;

for (my $i = 0; $i < $input_lines; ++$i)
{
	chomp(my $line = <STDIN>);
	my ($x, $y, $r) = split / /, $line;
	my $pow_x = $r * $r - $y * $y;
	if ($pow_x >= 0)
	{
		my $projection_x = sqrt($pow_x);
		my $positive_x = $x + $projection_x;
		my $negative_x = $x - $projection_x;

		for (my $j = cutl($negative_x); $j <= cutr($positive_x); ++$j)
		{
			$results{$j}++;
		}
	}
}

print max(values(%results));
