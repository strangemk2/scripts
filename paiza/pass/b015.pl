use 5.014;
use List::Util qw/first/;

my @digits_pattern = (
	"1111110",
	"0110000",
	"1101101",
	"1111001",
	"0110011",
	"1011011",
	"1011111",
	"1110010",
	"1111111",
	"1111011",
);

sub get_digit
{
	chomp(my $digit = <STDIN>);
	$digit =~ s/ //g;
	return $digit;
}

sub check_num
{
	foreach my $num (@_)
	{
		my $r = first {$num eq $_} @digits_pattern;
		return unless (defined($r));
	}
	1;
}

sub do_convert
{
	my ($digit, $convert_table_ref) = @_;
	my @r;
	my @d = split //, $digit;
	foreach (keys(%$convert_table_ref))
	{
		$r[$convert_table_ref->{$_}] = $d[$_];
	}
	return join '', @r;
}

sub convert_display
{
	my ($digit1, $digit2, $convert_table_ref) = @_;
	my $digit3 = $digit1;
	$digit1 = do_convert($digit2, $convert_table_ref);
	$digit2 = do_convert($digit3, $convert_table_ref);
	return ($digit1, $digit2);
}

sub flip_display
{
	my %convert_table = (
		0 => 0,
		1 => 5,
		2 => 4,
		3 => 3,
		4 => 2,
		5 => 1,
		6 => 6,
	);

	return convert_display(@_, \%convert_table);
}

sub rotate_display
{
	my %convert_table = (
		0 => 3,
		1 => 4,
		2 => 5,
		3 => 0,
		4 => 1,
		5 => 2,
		6 => 6,
	);

	return convert_display(@_, \%convert_table);
}

my @origin_display = (get_digit(), get_digit());
my @flip_display = flip_display(@origin_display);
my @rotate_display = rotate_display(@origin_display);
say check_num(@origin_display)?'Yes':'No';
say check_num(@flip_display)?'Yes':'No';
say check_num(@rotate_display)?'Yes':'No';
