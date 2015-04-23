sub output
{
	my $log = shift;
	$log =~ m/([\d\.]+).*\[(.+) \+\d{4}\].*GET +([^ ]+)/;
	print "$1 $2 $3\n";
}

sub match
{
	my ($pattern, $data) = @_;

	if ($pattern eq "*")
	{
		return 1;
	}
	elsif (substr($pattern, 0, 1) eq "[")
	{
		$pattern = substr($pattern, 1, -1);
		my ($start, $end) = split /-/, $pattern;
		return $start <= $data && $data <= $end;
	}
	else
	{
		return $pattern == $data;
	}
}

chomp(my $pattern = <STDIN>);
chomp(my $input_lines = <STDIN>);
my ($first, $second, $third, $fourth) = split /\./, $pattern;

foreach my $log (<STDIN>)
{
	chomp($log);
	if ($log =~ m/^$first\.$second\.(\d+)\.(\d+)/)
	{
		if (match($third, $1) && match($fourth, $2))
		{
			output($log);
		}
	}
}
