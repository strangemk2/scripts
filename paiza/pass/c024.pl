use 5.014;

package computer;

sub new
{
	my $class = shift;
	return bless {register => [0, 0, 0]}, $class;
}

sub SET
{
	my $self = shift;
	my ($register_num, $value) = @_;
	$self->{register}->[$register_num] = $value;
}

sub ADD
{
	my $self = shift;
	my $value = shift;
	$self->{register}->[2] = $self->{register}->[1] + $value;
}

sub SUB
{
	my $self = shift;
	my $value = shift;
	$self->{register}->[2] = $self->{register}->[1] - $value;
}

sub print_register
{
	my $self = shift;
	say "$self->{register}->[1] $self->{register}->[2]";
}

sub AUTOLOAD
{
	say "operator $computer::AUTOLOAD is not supported";
}

sub DESTROY
{
}

package main;

chomp(my $n = <STDIN>);
my $computer = computer->new();
for (1..$n)
{
	chomp(my $instruction_line = <STDIN>);
	my ($operator, @args) = split / /, $instruction_line;
	$computer->$operator(@args);
}
$computer->print_register();
