use 5.014;
use Data::Dumper;

package connection_blob;

sub new
{
	my $class = shift;
	return bless {data => []}, $class;
}

sub bind
{
	my $self = shift;
	my ($a, $b) = @_;

	my $a_group = $self->{data}->[$a];
	my $b_group = $self->{data}->[$b];

	if (!defined($a_group->{$a}) && !defined($b_group->{$b}))
	{
		$a_group = {$a => 1, $b => 1};
		$b_group = $a_group;

		$self->{data}->[$a] = $a_group;
		$self->{data}->[$b] = $b_group;
	}
	elsif (defined($a_group->{$a}) && !defined($b_group->{$b}))
	{
		$a_group->{$b} = 1;
		$b_group = $a_group;

		$self->{data}->[$b] = $b_group;
	}
	elsif (!defined($a_group->{$a}) && defined($b_group->{$b}))
	{
		$b_group->{$a} = 1;
		$a_group = $b_group;

		$self->{data}->[$a] = $a_group;
	}
	else
	{
		if ($a_group != $b_group)
		{
			while (my ($key,$value) = each $b_group)
			{
				$a_group->{$key} = $value;
				$self->{data}->[$key] = $a_group;
			}
			$b_group = $a_group;

			$self->{data}->[$b] = $b_group;
		}
	}
}

sub is_connected
{
	my $self = shift;
	my ($a, $b) = @_;

	return defined($self->{data}->[$a]->{$b});
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
