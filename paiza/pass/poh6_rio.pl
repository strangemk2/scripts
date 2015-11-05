use strict;

package coffee_cup;

sub new
{
	my $class = shift;

	return bless {water => 0, powder => 0}, $class;
}

sub operation_1
{
	my $self = shift;
	my $value = shift;

	$self->{water} += $value;
}

sub operation_2
{
	my $self = shift;
	my $value = shift;

	$self->{powder} += $value;
}

sub operation_3
{
	my $self = shift;
	my $value = shift;

	my $powder = $value * $self->coffee_concentration();
	my $water = $value * $self->water_concentration();
	$self->{powder} -= $powder;
	$self->{water} -= $water;
}

sub water_concentration
{
	my $self = shift;

	return $self->{water} / ($self->{water} + $self->{powder});
}

sub coffee_concentration
{
	my $self = shift;

	return $self->{powder} / ($self->{water} + $self->{powder});
}

sub result
{
	my $self = shift;

	return int($self->coffee_concentration() * 100);
}

package main;

my $cup = coffee_cup->new();

my $operation_num = <STDIN>;
for (1..$operation_num)
{
	chomp(my $operation = <STDIN>);
	my ($op_id, $value) = split / /, $operation;
	#eval "\$cup->operation_$op_id(\$value);";
	my $method = "operation_$op_id";
	$cup->$method($value);
}
print $cup->result();
