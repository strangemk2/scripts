use 5.014;
use POSIX;
my $header = <STDIN>;
my ($pocket_size, $number) = split / /, $header;

sub is_odd
{
	return $_[0] % 2;
}

if (is_odd(floor(($number - 1) / $pocket_size)))
{
	say $number - ((($number - 1) % $pocket_size) * 2 + 1);
}
else
{
	say $number + (($pocket_size - ($number - 1) % $pocket_size) * 2 - 1);
}
