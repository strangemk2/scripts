use 5.014;
use POSIX;
my $capability = <STDIN>;
my $lines = <STDIN>;
my %pages_hash;
for (1..$lines)
{
	my $line = <STDIN>;
	my ($hour, $min, $papers) = split / /, $line;
	$pages_hash{$hour} += $papers;
}
my $get_paper_times = 0;
foreach my $papers (values(%pages_hash))
{
	$get_paper_times += ceil($papers / $capability);
}
say $get_paper_times;
