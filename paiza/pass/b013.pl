use 5.014;

package mtime;

use overload "<" => \&mtime::less_than,
             "-" => \&mtime::remove;

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

sub remove
{
	my $self = shift;
	my ($m) = @_;

	my $ret = mtime->new($self->{h}, $self->{m});

	$ret->{m} -= $m;
	while ($ret->{m} < 0)
	{
		$ret->{h}--;
		$ret->{m} += 60;
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

my $header_line = <STDIN>;
my ($minuts_a, $minuts_b, $minuts_c) = split / /, $header_line;

my $lines = <STDIN>;
my $office_time = mtime->new(8, 59);
my $gino_time = $office_time - $minuts_c;
my $paiza_time = $gino_time - $minuts_b;
my $last_time;
for (1..$lines)
{
	my $train_time_line = <STDIN>;
	my $train_time = mtime->new(split / /, $train_time_line);
	if ($train_time < $paiza_time)
	{
		$last_time = $train_time;
	}
	else
	{
		last;
	}
}
my $home_time = $last_time - $minuts_a;
say $home_time->expr();
