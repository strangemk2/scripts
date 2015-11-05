use 5.014;
chomp(my $n = <STDIN>);
chomp(my $m = <STDIN>);
my $cnt;
for (1..$m)
{
	chomp(my $room = <STDIN>);
	unless ($room =~ m/$n/)
	{
		say $room;
		$cnt++;
	}
}
say 'none' unless ($cnt);
