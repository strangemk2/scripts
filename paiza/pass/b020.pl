use 5.014;

my $n = <STDIN>;

my @browser_stack;
my $last;
for (1..$n)
{
	chomp(my $browse_line = <STDIN>);
	if ($browse_line =~ m/go to (.*)$/)
	{
		say $1;
		push @browser_stack, $last;
		$last = $1;
	}
	else
	{
		$last = pop @browser_stack;
		say $last;
	}
}
