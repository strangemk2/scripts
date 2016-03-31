my $l = <STDIN>;
my ($m, $n) = split / /, $l;
push (@res, $m + $_ * $n) for (0..9);
print join(' ', @res) . "\n";
