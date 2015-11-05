use 5.014;

chomp(my $l = <STDIN>);
my ($m, $p, $q) = split / /, $l;
say percentage_left(percentage_left($m, $p), $q);

sub percentage_left
{
	my ($m, $p) = @_;
	return $m * (100 - $p) / 100;
}
