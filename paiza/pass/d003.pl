my $value = <STDIN>;
print join(' ', map {$_ * $value} (1..9));
