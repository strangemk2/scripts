use 5.014;
use Data::Dumper;

#2 => 1
#3 => 7
#4 => 4
#5 => 2 3 5
#6 => 0 6 9
#7 => 8

my @convert_tree = (
	{'=' => [6, 9], '+' => [8], '-' => []},		#0
	{'=' => [], '+' => [7], '-' => []},			#1
	{'=' => [3], '+' => [], '-' => []},			#2
	{'=' => [2, 5], '+' => [9], '-' => []},		#3
	{'=' => [], '+' => [], '-' => []},			#4
	{'=' => [3], '+' => [9, 6], '-' => []},		#5
	{'=' => [0, 9], '+' => [8], '-' => [5]},	#6
	{'=' => [], '+' => [], '-' => [1]},			#7
	{'=' => [], '+' => [], '-' => [0, 6, 9]},	#8
	{'=' => [0, 6], '+' => [8], '-' => [3, 5]},	#9
);

chomp (my $match_number = <STDIN>);
my @res;
push @res, single_digit_convertion($match_number, \@convert_tree);
push @res, double_digit_convertion($match_number, \@convert_tree);
if (@res)
{
	say foreach (sort {$a <=> $b} @res);
}
else
{
	say 'none';
}

sub single_digit_convertion
{
	my ($match_number, $convert_tree_ref) = @_;
	my @res;
	my @match_numbers = split //, $match_number;
	for (my $i = 0; $i < @match_numbers; $i++)
	{
		my $number = $match_numbers[$i];
		if ($convert_tree_ref->[$number]{'='})
		{
			foreach my $d (@{$convert_tree_ref->[$number]{'='}})
			{
				my @worker_numbers = @match_numbers;
				$worker_numbers[$i] = $d;
				push @res, join '', @worker_numbers;
			}
		}
	}
	return @res;
}

sub double_order_generator
{
	my $length = shift;

	my $o1 = 0;
	my $o2 = 0;
	return sub
	{
		if ($o2 == $length)
		{
			$o2 = 0;
			$o1++;
		}
		if ($o1 == $length)
		{
			return ();
		}

		my @ret = ($o1, $o2);

		$o2++;

		return @ret;
	};
}

sub double_digit_convertion
{
	my ($match_number, $convert_tree_ref) = @_;
	my @res;
	my @match_numbers = split //, $match_number;

	my $order_gen = double_order_generator(length($match_number));
	for (my @order = $order_gen->(); @order; @order = $order_gen->())
	{
		next if ($order[0] == $order[1]);
		my $n1 = $match_numbers[$order[0]];
		my $n2 = $match_numbers[$order[1]];
		if ($convert_tree_ref->[$n1]{'+'} && $convert_tree_ref->[$n2]{'-'})
		{
			foreach my $d1 (@{$convert_tree_ref->[$n1]{'+'}})
			{
				foreach my $d2 (@{$convert_tree_ref->[$n2]{'-'}})
				{
					my @worker_numbers = @match_numbers;
					$worker_numbers[$order[0]] = $d1;
					$worker_numbers[$order[1]] = $d2;
					push @res, join '', @worker_numbers;
				}
			}
		}
		elsif ($convert_tree_ref->[$n1]{'-'} && $convert_tree_ref->[$n2]{'+'})
		{
			foreach my $d1 ($convert_tree_ref->[$n1]{'-'})
			{
				foreach my $d2 ($convert_tree_ref->[$n2]{'+'})
				{
					my @worker_numbers = @match_numbers;
					$worker_numbers[$order[0]] = $d1;
					$worker_numbers[$order[1]] = $d2;
					push @res, join '', @worker_numbers;
				}
			}
		}
	}
	return @res;
}
