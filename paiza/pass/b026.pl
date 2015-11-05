use 5.014;

my $header_line = <STDIN>;
my ($v500, $v100, $v50, $v10) = split / /, $header_line;
my $customer = <STDIN>;

for (1..$customer)
{
	chomp(my $customer_line = <STDIN>);
	my ($price, $n500, $n100, $n50, $n10) = split / /, $customer_line;

	my $change = calc_price($n500, $n100, $n50, $n10) - $price;
	my $num500 = int($change / 500);
	$change -= ($num500 * 500);
	my $num100 = int($change / 100);
	$change -= ($num100 * 100);
	my $num50 = int($change / 50);
	$change -= ($num50 * 50);
	my $num10 = int($change / 10);
	$change -= ($num10 * 10);

	if ($num100 > $v100)
	{
		$num50 += (2 * ($num100 - $v100));
		$num100 = $v100;
	}
	if ($num50 > $v50)
	{
		$num10 += (5 * ($num50 - $v50));
		$num50 = $v50;
	}

	if (calc_price(0, 0, $num50, $num10) >= 100 || $num10 > $v10)
	{
		say 'impossible';
	}
	else
	{
		$v100 -= $num100;
		$v50 -= $num50;
		$v10 -= $num10;

		$v500 += $n500;
		$v100 += $n100;
		$v50 += $n50;
		$v10 += $n10;

		say "$num500 $num100 $num50 $num10";
		#say "stock: $v500, $v100, $v50, $v10";
	}
}

sub calc_price
{
	my ($n500, $n100, $n50, $n10) = @_;
	return $n500 * 500 + $n100 * 100 + $n50 * 50 + $n10 * 10;
}
