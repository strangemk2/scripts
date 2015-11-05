use 5.014;

my $n = <STDIN>;
for (1..$n)
{
	chomp(my $word = <STDIN>);
	say to_plurality($word);
}

sub to_plurality
{
	my $word = shift;

	return $word if ($word =~ s/s$/ses/);
	return $word if ($word =~ s/sh$/shes/);
	return $word if ($word =~ s/ch$/ches/);
	return $word if ($word =~ s/o$/oes/);
	return $word if ($word =~ s/x$/xes/);

	return $word if ($word =~ s/f$/ves/);
	return $word if ($word =~ s/fe$/ves/);

	return $word if ($word =~ s/([^aeiou])y$/$1ies/);

	return "${word}s";
}
