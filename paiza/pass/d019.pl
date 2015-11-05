chomp(my $input = <STDIN>);
my ($str, $n) = split / /, $input;
print substr($str, $n-1, 1), "\n";
