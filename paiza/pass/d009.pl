chomp(my $input = <STDIN>);
my ($a, $b) = split / /, $input;
print $b - $a, "\n";
