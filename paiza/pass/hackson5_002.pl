my $input_lines = <STDIN>;

my @result;
for (my $i = 0; $i < $input_lines; $i++)
{
	chomp(my $data = <STDIN>);
	$result[$i%7] += $data;
}
foreach (@result)
{
	print;
	print "\n";
}
