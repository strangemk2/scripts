use 5.014;

my $header_line = <STDIN>;
my ($candidator, $elector, $speech) = split / /, $header_line;

my @supporters = ($elector);

for (1..$speech)
{
	my $speech_man = <STDIN>;
	@supporters = change_supporter($speech_man, $candidator, @supporters);
}
say foreach (get_elected(@supporters));

sub change_supporter
{
	my ($speech_man, $candidator, @supporters) = @_;
	for (my $i = 0; $i <= $candidator; $i++)
	{
		if ($i != $speech_man && $supporters[$i] > 0)
		{
			$supporters[$i]--;
			$supporters[$speech_man]++;
		}
	}
	return @supporters;
}

sub get_elected
{
	my @supporters = @_;
	my @elected;

	for (my $i = 1; $i < @supporters; $i++)
	{
		if (!@elected || $supporters[$elected[0]] < $supporters[$i])
		{
			@elected = ($i);
		}
		elsif ($supporters[$elected[0]] == $supporters[$i])
		{
			push @elected, $i;
		}
	}
	return @elected;
}
