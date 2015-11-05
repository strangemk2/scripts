my $res;
for (1..7)
{
	chomp(my $rest = <STDIN>);
	$res++ if ($rest eq 'no');
}
print $res;
