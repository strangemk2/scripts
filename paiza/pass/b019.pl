use 5.014;

my $header_line = <STDIN>;
my ($pixel, $scale) = split / /, $header_line;
my @bitmap;
for (1..$pixel)
{
	chomp(my $pixel_line = <STDIN>);
	push @bitmap, [split / /, $pixel_line];
}

sub shrink_bitmap
{
	my ($pixel, $scale, @bitmap) = @_;
	my $target_pixel = $pixel / $scale;
	my @r;
	for (my $x = 0; $x < $target_pixel; $x++)
	{
		for (my $y = 0; $y < $target_pixel; $y++)
		{
			$r[$x][$y] = calc_average_bitmap($x, $y, $scale, @bitmap);
		}
	}
	return @r;
}

sub calc_average_bitmap
{
	my ($x, $y, $scale, @bitmap) = @_;
	my $sum;
	for (my $i = $x * $scale; $i < ($x+1) * $scale; $i++)
	{
		for (my $j = $y * $scale; $j < ($y+1) * $scale; $j++)
		{
			$sum += $bitmap[$i][$j];
		}
	}
	return int($sum / $scale / $scale);
}

sub print_bitmap
{
	foreach my $line_ref (@_)
	{
		say join ' ', @$line_ref;
	}
}

print_bitmap(shrink_bitmap($pixel, $scale, @bitmap));
