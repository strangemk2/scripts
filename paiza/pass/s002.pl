use 5.014;
use Data::Dumper;

package node;

sub new
{
	my $class = shift;
	my ($x, $y) = @_;
	return bless {parent => '', x => $x, y => $y}, $class;
}

sub parent
{
	my $self = shift;
	my $parent = shift;
	$self->{parent} = $parent if (defined($parent));
	return $self->{parent};
}

package main;

my $header_line = <STDIN>;
my ($width, $height) = split / /, $header_line;

my @maze;
for (1..$height)
{
	chomp(my $maze_line = <STDIN>);
	push @maze, [split(/ /, $maze_line)];
}

my @route_graph;
for my $x (0..$height-1)
{
	my @route_line;
	for my $y (0..$width-1)
	{
		push @route_line, node->new($x, $y);
	}
	push @route_graph, \@route_line;
}

my @dfs_stack;
my $start_node = find_start(\@route_graph, \@maze);
$start_node->{parent} = 'start';
push @dfs_stack, $start_node;

my $goal_node = dfs_walk_graph(\@dfs_stack, \@route_graph, \@maze);
if ($goal_node)
{
	my $sum = 0;
	for (my $node = $goal_node; $node->{parent} ne 'start'; $node = $node->{parent})
	{
		$sum++;
	}
	say $sum;
}
else
{
	say 'Fail';
}

sub find_start
{
	my ($route_graph_ref, $maze_ref) = @_;
	for (my $x = 0; $x < $height; $x++)
	{
		for (my $y = 0; $y < $width; $y++)
		{
			if ($maze_ref->[$x][$y] eq's')
			{
				return $route_graph_ref->[$x][$y];
			}
		}
	}
}

sub dfs_walk_graph
{
	my ($dfs_stack_ref, $route_graph_ref, $maze_ref) = @_;
	while (@$dfs_stack_ref)
	{
		my $node = shift $dfs_stack_ref;
		my $x = $node->{x};
		my $y = $node->{y};
		say "processing node: $x, $y";
		if ($maze_ref->[$x][$y] eq 'g')
		{
			return $node;
		}
		if ($x + 1 < $height)
		{
			my $n = $route_graph_ref->[$x+1][$y];
			if (!$n->parent() && $maze_ref->[$x+1][$y] ne '1')
			{
				$n->parent($node);
				push $dfs_stack_ref, $n;
			}
		}
		if ($x - 1 >= 0)
		{
			my $n = $route_graph_ref->[$x-1][$y];
			if (!$n->parent() && $maze_ref->[$x-1][$y] ne '1')
			{
				$n->parent($node);
				push $dfs_stack_ref, $n;
			}
		}
		if ($y + 1 < $width)
		{
			my $n = $route_graph_ref->[$x][$y+1];
			if (!$n->parent() && $maze_ref->[$x][$y+1] ne '1')
			{
				$n->parent($node);
				push $dfs_stack_ref, $n;
			}
		}
		if ($y - 1 >= 0)
		{
			my $n = $route_graph_ref->[$x][$y-1];
			if (!$n->parent() && $maze_ref->[$x][$y-1] ne '1')
			{
				$n->parent($node);
				push $dfs_stack_ref, $n;
			}
		}
	}
	#say 'not found.';
	return;
}
