use 5.014;

my $receipt_ref = load_material();
my $material_ref = load_material();

my $cnt = 0;
while (is_material_good($material_ref))
{
	material_minus($receipt_ref, $material_ref);
	$cnt++;
}
say $cnt-1;

sub is_material_good
{
	my $material_ref = shift;
	foreach (values($material_ref))
	{
		if ($_ < 0)
		{
			return;
		}
	}
	return 1;
}

sub material_minus
{
	my ($m1, $m2) = @_;
	foreach (keys($m1))
	{
		$m2->{$_} -= $m1->{$_};
	}
}

sub load_material
{
	chomp(my $num = <STDIN>);
	my %material;
	for (1..$num)
	{
		chomp(my $line = <STDIN>);
		my @t = split / /, $line;
		$material{$t[0]} = $t[1];
	}
	return \%material;
}
