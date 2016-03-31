use 5.014;

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
	$self->{data}->[$a] = {} if (!defined($self->{data}->[$a]));
	$self->{data}->[$a]->{$b} = 1;
	$self->{data}->[$b] = {} if (!defined($self->{data}->[$b]));
	$self->{data}->[$b]->{$a} = 1;
}

sub is_connected
{
	my $self = shift;
	my ($a, $b) = @_;

	my @search;
	my %accessed;
	push @search, $a;
	while (scalar(@search) != 0)
	{
		my $s = shift @search;
		$accessed{$s} = 1;
		if (defined($self->{data}->[$s]->{$b}))
		{
			return 1;
		}
		else
		{
			for (keys(%{$self->{data}->[$s]}))
			{
				if (!defined($accessed{$_}))
				{
					push @search, $_;
				}
			}
		}
	}
	return;
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
