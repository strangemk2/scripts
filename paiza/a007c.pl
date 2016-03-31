use 5.014;
use Data::Dumper;

package connection_blob;

sub new
{
	my $class = shift;
	my $id_gen = get_id_generator();
	return bless {data => [], id_gen => $id_gen}, $class;
}

sub bind
{
	my $self = shift;
	my ($a, $b) = @_;

	my $av = $self->{data}->[$a];
	my $bv = $self->{data}->[$b];

	if ($av == 0 && $bv == 0)
	{
		my $id = $self->{id_gen}->();
		$self->{data}->[$a] = $id;
		$self->{data}->[$b] = $id;
	}
	elsif ($av > 0 && $bv == 0)
	{
		$self->{data}->[$b] = $av;
	}
	elsif ($av == 0 && $bv > 0)
	{
		$self->{data}->[$a] = $bv;
	}
	else
	{
		if ($av != $bv)
		{
			for (my $i = 0; $i < @{$self->{data}}; $i++)
			{
				$self->{data}->[$i] = $av if ($self->{data}->[$i] == $bv);
			}
		}
	}

	#say Data::Dumper::Dumper($self->{data});
}

sub is_connected
{
	my $self = shift;
	my ($a, $b) = @_;

	return ($self->{data}->[$a] > 0 && $self->{data}->[$a] == $self->{data}->[$b]);
}

sub get_id_generator
{
	my $id = 1;
	return sub
	{
		return $id++;
	}
}


package main;

my $header_line = <STDIN>;
my ($user_num, $query_num) = split / /, $header_line;

my $connection_blob = connection_blob->new;
for (1..$query_num)
{
	chomp(my $query_line = <STDIN>);
	my ($dispose_id, @args) = split / /, $query_line;
	if ($dispose_id == 0)
	{
		$connection_blob->bind(@args);
	}
	elsif ($dispose_id == 1)
	{
		say $connection_blob->is_connected(@args)?'yes':'no';
	}
}
