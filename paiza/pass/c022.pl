use 5.014;

chomp(my $num = <STDIN>);
my ($start_price, $end_price, $high_price, $low_price);
for (1..$num)
{
	chomp(my $day_stock_price_line = <STDIN>);
	my ($day_start_price, $day_end_price, $day_high_price, $day_low_price) = split / /, $day_stock_price_line;

	$start_price = $day_start_price if (!defined($start_price));
	$end_price = $day_end_price;
	$high_price = $day_high_price if ($high_price < $day_high_price);
	$low_price = $day_low_price if ($low_price > $day_low_price || !defined($low_price));
}
say "$start_price $end_price $high_price $low_price";
