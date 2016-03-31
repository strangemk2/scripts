use 5.014;
use List::Util qw/first/;
use Data::Dumper;

my $header_line = <>;
my ($villager_num, $rule_num) = split / /, $header_line;

my @villagers;
for (1..$villager_num)
{
	push @villagers, new_djset_element($_);
}

for(1..$rule_num)
{
	my $line = <>;
	my $rule = parse_rule($line);
	my $ret = insert_villager($rule);
	if (!$ret)
	{
		say -1;
		exit;
	}
}

#say Dumper(@villagers);
my %roots;
foreach (@villagers)
{
	my $r = find_root($_);
	#say $r->{value};
	$roots{$r->{value}} = 1;
}
#say Dumper(%roots);
say scalar(keys(%roots)) + 1;

sub new_djset_element
{
	my $value = shift;
	return {value => $value, parent => undef, color => 'h'};
}

sub find_root
{
	my $element = shift;
	while (defined($element->{parent}))
	{
		$element = $element->{parent};
	}
	return $element;
}

sub union_element
{
	my ($a, $b, $color) = @_;

	my $ar = find_root($a);
	my $br = find_root($b);

	$ar->{parent} = $br if ($ar->{value} != $br->{value});
}

sub parse_rule
{
	my $line = shift;
	$line =~ m/(\d+) said (\d+) was/;
	my ($a, $b) = ($1, $2);
	if ($line =~ m/honest/)
	{
		return [$a, $b, 'h'];
	}
	else
	{
		return [$a, $b, 'l'];
	}
}

sub insert_villager
{
	my ($rule) = @_;

	my ($a, $b, $assumption) = @$rule;

	union_element($villagers[$a-1], $villagers[$b-1]);
	return 1;
}
