sub beam_walk
{
	my ($x, $y, $direction) = @_;
	if ($direction eq "u")
	{
		$y--;
	}
	elsif ($direction eq "d")
	{
		$y++;
	}
	elsif ($direction eq "l")
	{
		$x--;
	}
	elsif ($direction eq "r")
	{
		$x++;
	}

	return ($x, $y);
}

my $geometry = <STDIN>;
my ($h, $w) = split / /, $geometry;

my @matrix;
my $i = 0;
foreach my $line (<STDIN>)
{
	$matrix[$i++] = [split //, $line];
}

my $count = 0;
my $direction = "r";
for(my $x = 0, my $y = 0; 0 <= $x && 0 <= $y && $x < $w && $y < $h;)
{
	if ($matrix[$y][$x] eq "_")
	{
		# nothing happen
	}
	elsif ($matrix[$y][$x] eq "\\")
	{
		if ($direction eq "u")
		{
			$direction = "l";
		}
		elsif ($direction eq "d")
		{
			$direction = "r";
		}
		elsif ($direction eq "l")
		{
			$direction = "u";
		}
		elsif ($direction eq "r")
		{
			$direction = "d";
		}
	}
	elsif ($matrix[$y][$x] eq "/")
	{
		if ($direction eq "u")
		{
			$direction = "r";
		}
		elsif ($direction eq "d")
		{
			$direction = "l";
		}
		elsif ($direction eq "l")
		{
			$direction = "d";
		}
		elsif ($direction eq "r")
		{
			$direction = "u";
		}
	}
	($x, $y) = beam_walk($x, $y, $direction);
	$count++;
}

print $count;
