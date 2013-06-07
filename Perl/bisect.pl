#!/usr/bin/perl

use 5.016;

my @array = qw/1 2 3 7 8 9 10 11/;

sub bisect
{
	my ($dest, $up, $down) = @_;

	return undef if ($up > $down);

	my $mid = int($up + ($down - $up) / 2);
	if ($dest == $array[$mid])
	{
		return $mid;
	}
	elsif ($dest < $array[$mid])
	{
		return bisect($dest, $up, $mid - 1);
	}
	else
	{
		return bisect($dest, $mid + 1, $down);
	}
}

print bisect(4, 0, $#array);
