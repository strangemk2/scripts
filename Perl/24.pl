#!/usr/bin/perl

use 5.016;
use strict;
use Data::Dumper;

# 51/5-5*
# 515/-5*
# 5155/-*
sub shuffle_cards
{
	return (@_) if (@_ == 1);

	my @ret;
	for (0..$#_)
	{
		my @local_cards = @_;
		my ($local_first_cards) = splice(@local_cards, $_, 1);
		push @ret, map {$local_first_cards . $_} shuffle_cards(@local_cards);
	}
	return @ret;
}

sub calc_reverse_polish
{
	my $expr = shift;
	my @stack;

	while ($expr)
	{
		my $chr = substr($expr, 0, 1, '');
		if ($chr =~ /\d/)
		{
			push @stack, $chr;
		}
		else
		{
			my $r = pop @stack;
			my $l = pop @stack;
			if ($chr eq '+')
			{
				push @stack, $l + $r;
			}
			elsif ($chr eq '-')
			{
				push @stack, $l - $r;
			}
			elsif ($chr eq '*')
			{
				push @stack, $l * $r;
			}
			elsif ($chr eq '/')
			{
				push @stack, $r == 0 ? 0 : $l / $r;
			}
		}
	}
	$stack[0];
}

sub operator_generator
{
	my $factor = 0;

	return sub
	{
		my $local_factor = $factor;
		my $ret;
		while ($local_factor)
		{
			$ret = ($local_factor % 4) . $ret;
			$local_factor /= 4;
			$local_factor = int($local_factor);
		}

		$factor++;
		return if (length($ret) >= 4);
		$ret = sprintf("%03d", $ret);
		$ret =~ tr(0123)(+\-\*/);
		$ret;
	}
}

sub make_pattern
{
	my ($expr, $op) = @_;

	my @exprs = split //, $expr;
	my @ops = split //, $op;
	("$exprs[0]$exprs[1]$ops[0]$exprs[2]$ops[1]$exprs[3]$ops[2]",
	 "$exprs[0]$exprs[1]$exprs[2]$ops[0]$ops[1]$exprs[3]$ops[2]",
	 "$exprs[0]$exprs[1]$exprs[2]$exprs[3]$ops[0]$ops[1]$ops[2]")
}

sub calc_dist
{
	my @expr;
	my ($dist, @cards) = @_;

	my %ret;
	@expr = shuffle_cards(@cards);
	foreach (@expr)
	{
		my $op_iter = operator_generator();
		while (my $op = $op_iter->())
		{
			my @patterns = make_pattern($_, $op);
			foreach my $pattern (@patterns)
			{
				if (calc_reverse_polish($pattern) == $dist)
				{
					$ret{$pattern} = 1;
				}
			}
		}
	}

	sort(keys(%ret));
}

sub calc_24
{
	calc_dist(24, @_);
}

print Dumper(calc_24(@ARGV[0..3]));
#print calc_reverse_polish($ARGV[0]);
