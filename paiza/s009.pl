use 5.014;
use Data::Dumper;

my $array_length = <STDIN>;
chomp(my $array_line = <STDIN>);
my @array = split / /, $array_line;
my $pattern_num = <STDIN>;
my @pattern;
for (1..$pattern_num)
{
	chomp(my $pattern_line = <STDIN>);
	push @pattern, [split / /, $pattern_line];
}
unshift @pattern, '';

sub full_select
{
	my ($array_ref, $length, $result, $result_set) = @_;

	if ($length == 0)
	{
		push $result_set, $result;
		return;
	}

	for (0..@$array_ref-1)
	{
		my @local_array = @$array_ref;
		my $ch .= $local_array[$_];
		splice(@local_array, 0, $_+1);

		full_select(\@local_array, $length - 1, [@$result, $ch], $result_set);
	}
}

sub permutation
{
	return [@_] if (@_ == 1);

	my @ret;
	for (0..$#_)
	{
		my @local_cards = @_;
		my ($local_first_cards) = splice(@local_cards, $_, 1);
		push @ret, map {[$local_first_cards, @$_]} permutation(@local_cards);
	}
	return @ret;
}

sub use_pattern
{
	my ($array_ref, $pattern_ref, $change_ref) = @_;

	my $result;
	my @s = @$array_ref;
	for my $n (@$change_ref)
	{
		my @w;
		my @p = @{$pattern_ref->[$n]};

		for (my $i = 0; $i < @p; $i++)
		{
			$w[$p[$i]-1] = $s[$i];
		}

		@s = @w;
		my $s = join ' ', @s;
		$result = $s if (!defined($result) || ($s lt $result));
	}

	return $result;
}

my @pattern_set;
for (1..$pattern_num)
{
	full_select([1..$pattern_num], $_, [], \@pattern_set);
}

my $result;
for my $pattern (@pattern_set)
{
	for my $change (permutation(@$pattern))
	{
		my $r = use_pattern(\@array, \@pattern, $change);
		$result = $r if (!defined($result) || ($r lt $result));
	}
}
say $result;
