chomp(my $input = <STDIN>);
my ($num, $unit) = split / /, $input;
my %unit_table = (cm => 10, m => 100 * 10, km => 1000 * 100 * 10);
print $num * $unit_table{$unit}, "\n";
