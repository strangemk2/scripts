use 5.014;

my $header_line = <STDIN>;
my ($x, $y, $z) = split / /, $header_line;

my @matrix;
for (my $wz = 0; $wz < $z; $wz++)
{
	for (my $wx = 0; $wx < $x; $wx++)
	{
		chomp(my $y_line = <STDIN>);
		my @blocks = split //, $y_line;
		for (my $wy = 0; $wy < $y; $wy++)
		{
			$matrix[$wx][$wy][$wz] = $blocks[$wy];
		}
	}
	<STDIN>; # read split line
}
my @x_projection = do_x_projection(\@matrix);
dump_projection(\@x_projection);

sub do_x_projection
{
	my $matrix_ref = shift;
	my @x_projection;
	for (my $wz = 0; $wz < $z; $wz++)
	{
		for (my $wy = 0; $wy < $y; $wy++)
		{
			for (my $wx = 0; $wx < $x; $wx++)
			{
				if ($matrix_ref->[$wx][$wy][$wz] eq '#')
				{
					$x_projection[$wy][$wz] = '#';
					last;
				}
			}
			$x_projection[$wy][$wz] = '.' if ($x_projection[$wy][$wz] ne '#');
		}
	}
	return @x_projection;
}

sub dump_projection
{
	my $projection_ref = shift;
	for (my $y = @{$projection_ref->[0]} - 1; $y >= 0; $y--)
	{
		for (my $x = 0; $x < @$projection_ref; $x++)
		{
			print $projection_ref->[$x][$y];
		}
		print "\n";
	}
}
