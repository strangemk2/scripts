use 5.014;

chomp(my $header_line = <STDIN>);
my ($n, $r) = split / /, $header_line;

for (1..$n)
{
	chomp(my $box_line = <STDIN>);
	my @box_size = split / /, $box_line;
	if (scalar(grep {$_ >= (2*$r)} @box_size) == 3)
	{
		say;
	}
}
