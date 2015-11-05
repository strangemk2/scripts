use 5.014;
chomp(my $word = <STDIN>);
$word =~ tr/AEGIOSZ/4361052/;
say $word;
