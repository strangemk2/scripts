use 5.014;
chomp(my $my_card_line = <STDIN>);
my @my_card = split / /, $my_card_line;

chomp(my $n = <STDIN>);

for (1..$n)
{
	chomp(my $card_line = <STDIN>);
	my @card = split / /, $card_line;
	if ($my_card[0] > $card[0])
	{
		say 'High';
	}
	elsif ($my_card[0] == $card[0])
	{
		if ($my_card[1] < $card[1])
		{
			say 'High';
		}
		else
		{
			say 'Low';
		}
	}
	else
	{
		say 'Low';
	}
}
