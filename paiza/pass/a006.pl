use 5.014;
use Data::Dumper;

package move_direction;

my @directions = ([1, 0], [0, -1], [-1, 0], [0, 1]);

sub new
{
	my $class = shift;
	return bless {current_len => 0, max_len => 1, direction => 0, move => 0}, $class;
}

sub next
{
	my $self = shift;
	my $r = $directions[$self->{direction}];

	$self->{current_len}++;
	if ($self->{current_len} == $self->{max_len})
	{
		$self->{direction}++;
		$self->{direction} = 0 if ($self->{direction} == 4);

		$self->{move}++;
		if ($self->{move} == 2)
		{
			$self->{max_len}++;
			$self->{move} = 0;
		}

		$self->{current_len} = 0;
	}

	return @$r;
}

package walker;

sub new
{
	my $class = shift;
	my ($x, $y) = @_;
	return bless {time => 0, x => $x, y => $y}, $class;
}

sub pos
{
	my $self = shift;
	return ($self->{x}, $self->{y});
}

sub time
{
	my $self = shift;
	return $self->{time};
}

sub peek_walk
{
	my $self = shift;
	my ($x, $y) = @_;
	return ($self->{x} + $x, $self->{y} + $y);
}

sub walk
{
	my $self = shift;
	my ($x, $y) = @_;
	$self->{x} += $x;
	$self->{y} += $y;
	$self->{time}++;
}

package walk_map;

sub new
{
	my $class = shift;
	return bless {}, $class;
}

sub set
{
	my $self = shift;
	my ($x, $y) = @_;

	if ($self->{"${x}_${y}"} > 0)
	{
		die "key duplicated.";
	}
	else
	{
		$self->{"${x}_${y}"} = 1;
	}
}

sub is_set
{
	my $self = shift;
	my ($x, $y) = @_;

	return ($self->{"${x}_${y}"} > 0);
}

package main;

my $walker_num = <STDIN>;
my @walkers;
for (1..$walker_num)
{
	chomp(my $walker_line = <STDIN>);
	my $walker = walker->new(split / /, $walker_line);
	push @walkers, $walker;
}

my $move_direction = move_direction->new();
my $walk_map = walk_map->new();
$walk_map->set($_->pos()) for (@walkers);
my @stoped_walkers;
while (@walkers)
{
	my ($direction_x, $direction_y) = $move_direction->next();

	my @duplicated = check_duplicate(\@walkers, $direction_x, $direction_y);
	push @stoped_walkers, remove_walker(\@walkers, \@duplicated);

	my @occupied = check_occupied(\@walkers, $walk_map, $direction_x, $direction_y);
	push @stoped_walkers, remove_walker(\@walkers, \@occupied);

	for (@walkers)
	{
		$_->walk($direction_x, $direction_y);
		$walk_map->set($_->pos());

		#say Dumper($_->pos());
	}
	#say '--------';
}
say $stoped_walkers[-1]->time();

sub check_duplicate
{
	my ($walker_ref, $direction_x, $direction_y) = @_;

	my %pos_map;
	for my $walker (@$walker_ref)
	{
		my ($x, $y) = $walker->peek_walk($direction_x, $direction_y);
		if (!defined($pos_map{"${x}_${y}"}))
		{
			$pos_map{"${x}_${y}"} = [];
		}
		my ($px, $py) = $walker->pos();
		push $pos_map{"${x}_${y}"}, "${px}_${py}";
	}

	my @r;
	for (values %pos_map)
	{
		if (scalar(@$_) > 1)
		{
			push @r, @$_;
		}
	}
	return @r;
}

sub check_occupied
{
	my ($walker_ref, $walk_map, $direction_x, $direction_y) = @_;
	my @r;
	for my $walker (@$walker_ref)
	{
		if ($walk_map->is_set($walker->peek_walk($direction_x, $direction_y)))
		{
			my ($px, $py) = $walker->pos();
			push @r, "${px}_${py}";
		}
	}
	return @r;
}

sub remove_walker
{
	my ($walker_ref, $remove_keys_ref) = @_;
	my @r;
	my @z;
	for (@$walker_ref)
	{
		my ($px, $py) = $_->pos();
		if ("${px}_${py}" ~~ @$remove_keys_ref)
		{
			push @z, $_;
		}
		else
		{
			push @r, $_;
		}
	} 
	@$walker_ref = @r;
	return @z;
}
