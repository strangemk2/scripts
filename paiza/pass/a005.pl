use 5.014;

my $header_line = <STDIN>;
my ($frame_num, $bottle_num, $throw_times) = split / /, $header_line;
chomp(my $throw_line = <STDIN>);
my @point_times;
$point_times[$_] = 1 for (0..$throw_times-1);
my @throw_points = split / /, $throw_line;

my $current_frame = 1;
my @frame;
for (my $i = 0; $i < @throw_points; $i++)
{
	push @frame, $throw_points[$i];
	if ($current_frame == $frame_num)
	{
		# skip
	}
	else
	{
		# strike
		if ($frame[0] == $bottle_num)
		{
			$point_times[$i+1]++;
			$point_times[$i+2]++;

			@frame = ();
			$current_frame++;
		}
		# spare
		elsif (@frame == 2)
		{
			if ($frame[0] + $frame[1] == $bottle_num)
			{
				$point_times[$i+1]++;
			}

			@frame = ();
			$current_frame++;
		}
	}
}

# last frame
if ($frame[0] == $bottle_num)
{
	$point_times[-2]++;
	if ($frame[1] == $bottle_num)
	{
		$point_times[-1]++;
	}
	$point_times[-1]++;
}
elsif ($frame[0] + $frame[1] == $bottle_num)
{
	$point_times[-1]++;
}

my $sum;
for (my $i = 0; $i < @point_times; $i++)
{
	$sum += ($point_times[$i] * $throw_points[$i]);
}
say $sum;
