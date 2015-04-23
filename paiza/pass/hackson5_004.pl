use strict;

my $header = <STDIN>;
my ($x, $y) = split / /, $header;

my @board;
for (1..$y)
{
	chomp(my $line = <STDIN>);
	$line =~ s/2/0/g;
	my @data = split / /, $line;
	push @board, \@data;
}

for (my $j = 0; $j < $x; $j++)
{
	my $count = 0;
	for (my $i = 0; $i < $y; $i++)
	{
		$count++ if ($board[$i][$j] == 1);
	}
	for (my $i = 0; $i < $y; $i++)
	{
		if ($i < ($y - $count))
		{
			$board[$i][$j] = 0;
		}
		else
		{
			$board[$i][$j] = 1;
		}
	}
}

for (my $i = 0; $i < $y; $i++)
{
	print join ' ', @{$board[$i]};
	print "\n";
}
