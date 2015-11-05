chomp(my $input = <STDIN>);
my ($m, $n) = split / /, $input;
print int($m / $n), ' ', $m % $n, "\n";
