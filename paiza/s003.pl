use strict;
use List::Util qw/first/;
use Data::Dumper;

my $header_line = <STDIN>;
my ($villager_num, $rule_num) = split / /, $header_line;

use constant
{
	RULE_OK => 0,
	RULE_DUPLICATE => 1,
	RULE_LOGICAL_ERROR => 2,

	LEFT => 0,
	RIGHT => 1,
	ASSUMPTION => 2,
};

my @rules;
foreach (1..$rule_num)
{
	my $line = <STDIN>;
	my $rule = parse_rule($line);
	my $ret = validate_rule(\@rules, $rule);
	if ($ret == RULE_OK)
	{
		push @rules, $rule;
	}
	elsif ($ret == RULE_LOGICAL_ERROR)
	{
		print -1;
		exit;
	}
}

print $villager_num + 1 - scalar(@rules);
exit;

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

sub validate_rule
{
	my ($rules_ref, $rule) = @_;

	my ($a, $b, $assumption) = @$rule;

	my @logical_list = make_rule_logical($rules_ref, $a, $b);
	push @{$logical_list[0]}, $a;
	print Dumper(@logical_list);

	if ((first {$a == $_} @{$logical_list[0]}) && (first {$b == $_}  @{$logical_list[1]}))
	{
		if ($assumption eq 'h')
		{
			return RULE_LOGICAL_ERROR;
		}
		elsif ($assumption eq 'l')
		{
			return RULE_DUPLICATE;
		}
	}
	elsif (((first {$a == $_} @{$logical_list[0]}) && (first {$b == $_} @{$logical_list[0]})) ||
		((first {$a == $_} @{$logical_list[1]}) && (first {$b == $_} @{$logical_list[1]})))
	{
		if ($assumption eq 'h')
		{
			return RULE_DUPLICATE;
		}
		elsif ($assumption eq 'l')
		{
			return RULE_LOGICAL_ERROR;
		}
	}

	return RULE_OK;
}

sub make_rule_logical
{
	my @ret;
	my ($rules_ref, $base, $end) = @_;

	my @rules = (@$rules_ref);

	my @related_rules = grep {$_->[LEFT] == $base || $_->[RIGHT] == $base} @rules;
	my @left_rules = grep {!($_->[LEFT] == $base || $_->[RIGHT] == $base)} @rules;
	my @ordered_rules = map {reorder_rule($_, $base)} @related_rules;

	foreach (@ordered_rules)
	{
		if ($_->[ASSUMPTION] eq 'h')
		{
			push @{$ret[0]}, $_->[RIGHT];
		}
		elsif ($_->[ASSUMPTION] eq 'l')
		{
			push @{$ret[1]}, $_->[RIGHT];
		}

		if ($_->[RIGHT] == $end)
		{
			last;
		}

		my @r = make_rule_logical(\@left_rules, $_->[RIGHT], $end);
		push @{$ret[0]}, @{$r[0]} if (@r > 0);
		push @{$ret[1]}, @{$r[1]} if (@r > 1);
	}
	return @ret;
}

sub reorder_rule
{
	my ($rule_ref, $base) = @_;
	if ($rule_ref->[RIGHT] == $base)
	{
		return [$rule_ref->[RIGHT], $rule_ref->[LEFT], $rule_ref->[ASSUMPTION]];
	}
	else
	{
		return $rule_ref;
	}
}
