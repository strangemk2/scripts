use 5.014;
use Data::Dumper;

sub shuffle
{
	return [@_] if (@_ == 1);

	my @ret;
	for (0..$#_)
	{
		my @local_cards = @_;
		my ($local_first_cards) = splice(@local_cards, $_, 1);
		push @ret, map {[$local_first_cards, @$_]} shuffle(@local_cards);
	}
	return @ret;
}

my @s = (1,2,3,4,5);


sub choose
{
	my ($n, @s, $r) = @_;

	if ($n == 1)
	{
	}
	else
	{
		return choose($n - 1, 
	}
}

say Dumper(shuffle(@s));
