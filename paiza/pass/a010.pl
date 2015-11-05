use 5.014;

package tree;

use constant THREASHOLD => 0.001;

sub new
{
	my $class = shift;
	my ($x, $y, $r) = @_;
	return bless {x => $x, y => $y, r =>$r}, $class;
}

sub in
{
	my $self = shift;
	my ($x, $y) = @_;

	$y = 0 if (!defined($y));
	return less_than(distance($self->{x}, $self->{y}, $x, $y), $self->{r});
}

sub distance
{
	my ($x1, $y1, $x2, $y2) = @_;
	return sqrt(($x2 - $x1) ** 2 + ($y2 - $y1) ** 2);
}

sub less_than
{
	return ($_[0] < ($_[1] + THREASHOLD));
}

package main;

my $tree_num = <STDIN>;
my @tree_list;
my @point_list;
for (1..$tree_num)
{
	my $tree_line = <STDIN>;
	my ($x, $y, $r) = split / /, $tree_line;
	eval
	{
		my $abs_x = sqrt($r ** 2 - $y ** 2);
		push @point_list, ($x - $abs_x, $x + $abs_x);
	};
	push @tree_list, tree->new($x, $y, $r);
}

my $max_seen = 0;
for my $point (@point_list)
{
	my $seen = 0;
	for my $tree (@tree_list)
	{
		$seen++ if ($tree->in($point));
	}
	$max_seen = $seen if $max_seen < $seen;
	last if ($max_seen == $tree_num);
}
say $max_seen;
