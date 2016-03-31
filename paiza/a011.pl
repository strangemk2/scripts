use 5.014;
use Data::Dumper;

my $header_line = <STDIN>;

my ($blocks, $moves) = split / /, $header_line;
my @moves;
for (1..$moves)
{
    chomp(my $move = <STDIN>);
    push @moves, $move;
}

my @result;
if (dfs_tree(0, 0, \@moves, \@result))
{
    say join '', @result;
}

sub dfs_tree
{
    my ($node, $pos, $moves_ref, $result_ref) = @_;

	#say "$node, $pos";
	say @$result_ref;

	if ($pos > $blocks or $pos < -$blocks)
	{
		return 0;
	}

    return 1 if ($node == $moves);

    my $move = $moves_ref->[$node];

    push $result_ref, 'L';
	if (dfs_tree($node + 1, $pos + $move, $moves_ref, $result_ref))
	{
		return 1;
	}
	else
	{
		pop $result_ref;
	}

    push $result_ref, 'R';
	if (dfs_tree($node + 1, $pos - $move, $moves_ref, $result_ref))
	{
		return 1;
	}
	else
	{
		pop $result_ref;
	}

	0;
}
