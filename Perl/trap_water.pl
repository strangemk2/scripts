#https://oj.leetcode.com/problems/trapping-rain-water/
#
#/********************************************************************************** 
#* 
#* Given n non-negative integers representing an elevation map where the width of each bar is 1, 
#* compute how much water it is able to trap after raining. 
#* 
#* For example, 
#* Given [0,1,0,2,1,0,1,3,2,1,2,1], return 6.
#*   
#*     ^                                             
#*     |                                             
#*   3 |                       +--+                  
#*     |                       |  |                  
#*   2 |          +--+xxxxxxxxx|  +--+xx+--+         
#*     |          |  |xxxxxxxxx|  |  |xx|  |         
#*   1 |   +--+xxx|  +--+xxx+--+  |  +--+  +--+      
#*     |   |  |xxx|  |  |xxx|  |  |  |  |  |  |      
#*   0 +---+--+---+--+--+---+--+--+--+--+--+--+----->
#*       0  1   0  2  1   0  1  3  2  1  2  1        
#* 
#* The above elevation map is represented by array [0,1,0,2,1,0,1,3,2,1,2,1]. In this case, 
#* 6 units of rain water (blue section) are being trapped. Thanks Marcos for contributing this image!
#*               
#**********************************************************************************/
use strict;

sub find_highest
{
	my $highest = 0;

	foreach (@_)
	{
		$highest = $_ if ($highest < $_);
	}

	$highest;
}

sub trap_water
{
	my $count = 0;
	my @walls = @_;

	my $left_wall = 0;
	my $right_wall = find_highest(@walls);

	my $end = @walls;
	for (my $i = 0; $i < $end; ++$i)
	{
		my $current_wall = $walls[$i];
		if ($left_wall > $current_wall && $right_wall > $current_wall)
		{
			my $low_wall = $left_wall < $right_wall ? $left_wall : $right_wall;
			$count += $low_wall - $current_wall;
		}

		if ($current_wall > $left_wall)
		{
			$left_wall = $current_wall
		}
		if ($current_wall == $right_wall)
		{
			$right_wall = find_highest(@walls[$i+1..100]);
		}
	}

	$count;
}

my @data1 = (2,5,1,2,3,4,7,7,6);
print trap_water(@data1);
print "\n";
my @data2 = (2,0,2);
print trap_water(@data2);
print "\n";
my @data3 = (0,1,0,2,1,0,1,3,2,1,2,1);
print trap_water(@data3);
print "\n";
my @data4 = (7,1,9,0,2,1,9,1,3,2,1,2,9,8,0,2);
print trap_water(@data4);
print "\n";
