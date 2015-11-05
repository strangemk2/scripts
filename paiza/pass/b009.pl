use 5.014;

package mtime;

use overload "<" => \&mtime::less_than,
             "+" => \&mtime::add;

sub new
{
	my $class = shift;
	my ($h, $m) = @_;
	return bless {h => $h, m => $m}, $class;
}

sub expr
{
	my $self = shift;
	return sprintf("%02d:%02d", $self->{h}, $self->{m});
}

sub add
{
	my $self = shift;
	my ($m) = @_;

	my $ret = mtime->new($self->{h}, $self->{m});

	$ret->{m} += $m;
	while ($ret->{m} >= 60)
	{
		$ret->{h}++;
		$ret->{m} -= 60;
	}

	return $ret;
}

sub less_than
{
	my $self = shift;
	my $other = shift;
	return $self->expr() le $other->expr();
}

package main;

chomp(my $n = <STDIN>);
my $rest_flag = 0;
my $start_time = mtime->new(10, 0);
my $rest_time = mtime->new(12, 1);
for (1..$n)
{
	chomp(my $reserve_line = <STDIN>);
	my ($name, $reserve_minutes) = split / /, $reserve_line;
	if ($rest_time < ($start_time + $reserve_minutes))
	{
		if (!$rest_flag)
		{
			$start_time = $start_time + 50;
			$rest_flag = 1;
		}
	}
	my $end_time = $start_time + $reserve_minutes;
	say $start_time->expr(), " - ", $end_time->expr(), " $name";
	$start_time = $end_time + 10;
}
