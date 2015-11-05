use 5.014;
use List::Util qw/first/;

chomp(my $lottery_6_line = <STDIN>);
my @lottery_6_number = split / /, $lottery_6_line;

chomp(my $n = <STDIN>);
for (1..$n)
{
	chomp(my $ticket_line = <STDIN>);
	my $cnt = 0;
	foreach my $number (split / /, $ticket_line)
	{
		if (first {$number == $_} @lottery_6_number)
		{
			$cnt++;
		}
	}
	say $cnt;
}
