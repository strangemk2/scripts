use 5.014;

package map_game;

sub new
{
	my $class = shift;
	my ($w, $h, $x, $y) = @_;
	return bless {width => $w-1, height => $h-1, x => $x, y => $y}, $class;
}

sub current_pos
{
	my $self = shift;
	return "$self->{x} $self->{y}";
}

sub U
{
	my $self = shift;
	my $amount = shift;

	for (1..$amount)
	{
		$self->{y}++;
		$self->{y} = 0 if ($self->{y} > $self->{height});
	}
}

sub D
{
	my $self = shift;
	my $amount = shift;

	for (1..$amount)
	{
		$self->{y}--;
		$self->{y} = $self->{height} if ($self->{y} < 0);
	}
}

sub R
{
	my $self = shift;
	my $amount = shift;

	for (1..$amount)
	{
		$self->{x}++;
		$self->{x} = 0 if ($self->{x} > $self->{width});
	}
}

sub L
{
	my $self = shift;
	my $amount = shift;

	for (1..$amount)
	{
		$self->{x}--;
		$self->{x} = $self->{width} if ($self->{x} < 0);
	}
}


package main;

chomp(my $header_line = <STDIN>);
my ($map_w, $map_h, $n) = split / /, $header_line;
chomp(my $start_pos_line = <STDIN>);
my ($start_x, $start_y) = split / /, $start_pos_line;

my $game = map_game->new($map_w, $map_h, $start_x, $start_y);
for (1..$n)
{
	my $direction_line = <STDIN>;
	my ($direction, $amount) = split / /, $direction_line;
	$game->$direction($amount);
}
say $game->current_pos();
