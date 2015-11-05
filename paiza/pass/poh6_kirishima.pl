# 自分の得意な言語で
# Let's チャレンジ！！
use strict;

package sugoroku;

sub new
{
	my $class = shift;
	chomp(my $cell_line = shift);
	my @cells = split / /, $cell_line;
	my @board;
	for my $cell (@cells)
	{
		push(@board, {value => $cell, accessed => undef});
	}

	return bless \@board, $class;
}

sub play
{
	my $self = shift;
	my ($goal_num, $roulette) = @_;

	$self->reset();

	my $current = $roulette;
	my $goal = $goal_num - 1;
	while ($current != $goal)
	{
		if ($current < 0 || $current > $goal ||
			$self->[$current]{accessed} ||
			$self->[$current]{value} == 0)
		{
			return 'No';
		}

		$self->[$current]{accessed} = 1;
		$current += $self->[$current]{value};
	}

	return 'Yes';
}

sub reset
{
	my $self = shift;
	for my $cell (@$self)
	{
		$cell->{accessed} = 0;
	}
}

package main;

my $goal_num = <STDIN>;
my $cell_line = <STDIN>;
my $game = sugoroku->new($cell_line);

my $roulette_num = <STDIN>;
for (1..$roulette_num)
{
	chomp(my $roulette = <STDIN>);
	print $game->play($goal_num, $roulette), "\n";
}
