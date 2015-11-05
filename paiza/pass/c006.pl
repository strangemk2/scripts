use strict;
use 5.014;

package ranking;

sub new
{
	my $class = shift;
	my $num = shift;
	return bless { num => $num, data => [] }, $class;
}

sub add
{
	my $self = shift;
	my $score = shift;

	if (@{$self->{data}} < $self->{num})
	{
		push $self->{data}, $score;
	}
	else
	{
		if ($self->{data}->[-1] < $score)
		{
			$self->{data}->[-1] = $score;
		}
	}

	my @data = sort {$b <=> $a} @{$self->{data}};
	$self->{data} = \@data;
}

sub print
{
	my $self = shift;
	foreach (@{$self->{data}})
	{
		say positive_round($_);
	}
}

sub positive_round
{
	return int($_[0] + 0.5);
}

package main;

chomp(my $header_line = <STDIN>);
my ($param_n, $user_m, $top_k) = split / /, $header_line;

chomp(my $param_line = <STDIN>);
my @param_c = split / /, $param_line;

my $ranking = ranking->new($top_k);
for (1..$user_m)
{
	chomp(my $data_line = <STDIN>);
	my @datas = split / /, $data_line;
	my $score;
	for (0..$param_n-1)
	{
		$score += ($param_c[$_] * $datas[$_]);
	}
	$ranking->add($score);
}
$ranking->print();
