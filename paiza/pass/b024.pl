use 5.014;
use POSIX;

my $r = <STDIN>;
my $height = ceil ($r);
my $width = $height;

my $sum;
for (my $x = 0; $x < $width; $x++)
{
	for (my $y = 0; $y < $height; $y++)
	{
		if (sqrt($x * $x + $y * $y) < $r)
		{
			$sum++;
		}
	}
}
say $sum * 4;
