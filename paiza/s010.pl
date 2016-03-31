use 5.014;
use Data::Dumper;

chomp(my $dice_line = <>);
chomp(my $n = <>);
my @board;
for (1..$n)
{
	chomp(my $block = <>);
	push @board, $block;
}

my @dice_order = ('T', 'B', 'U', 'D', 'L', 'R');
my @dice_value = split / /, $dice_line;

my @dice_pattern;
for (my $i = 0; $i < @dice_order; $i++)
{
	$dice_pattern[$dice_value[$i]] = $dice_order[$i];
}

my @board_pattern = map {$dice_pattern[$_]} @board;

my $result = 0;
my $top = $board_pattern[0];
for my $pattern (@board_pattern)
{
	if ($top eq $pattern)
	{
		# noop
	}
	elsif (($top eq 'T' && $pattern eq 'B') || ($top eq 'B' && $pattern eq 'T') ||
		   ($top eq 'U' && $pattern eq 'D') || ($top eq 'D' && $pattern eq 'U') ||
		   ($top eq 'L' && $pattern eq 'R') || ($top eq 'R' && $pattern eq 'L'))
	{
		$result += 2;
	}
	else
	{
		$result += 1;
	}

	$top = $pattern;
}

say $result;
