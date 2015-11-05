use 5.014;

package ground;

sub new
{
	my $class = shift;
	my $size = shift;
	return bless {size => $size, data => []}, $class;
}

sub set_rabbit
{
	my $self = shift;
	my ($rabbit_ref) = @_;
	$self->{data}->[$rabbit_ref->pos()] = $rabbit_ref;
}

sub mv_rabbit
{
	my $self = shift;
	my ($old_pos, $new_pos) = @_;
	$self->{data}->[$new_pos] = $self->{data}->[$old_pos];
	$self->{data}->[$old_pos] = undef;
	return $new_pos;
}

sub find_available
{
	my $self = shift;
	my ($pos) = @_;

	while (defined($self->{data}->[$pos]))
	{
		$pos++;
		$pos = 1 if ($pos > $self->{size});
	}
	return $pos;
}

package rabbit;

sub new
{
	my $class = shift;
	my $pos = shift;
	return bless \$pos, $class;
}

sub pos
{
	my $self = shift;
	my $pos = shift;
	if (defined($pos))
	{
		$$self = $pos;
	}
	return $$self;
}

package main;

my $header_line = <STDIN>;
my ($glass, $rabbit, $jump) = split / /, $header_line;

my $ground = ground->new($glass);
my @rabbits;
for (1..$rabbit)
{
	chomp(my $pos = <STDIN>);
	my $r = rabbit->new($pos);
	$ground->set_rabbit($r);
	push @rabbits, $r;
}


for (1..$jump)
{
	for my $rabbit_ref (@rabbits)
	{
		my $new_pos = $ground->find_available($rabbit_ref->pos());
		$ground->mv_rabbit($rabbit_ref->pos(), $new_pos);
		$rabbit_ref->pos($new_pos);
	}
}

say $_->pos() for (@rabbits);
