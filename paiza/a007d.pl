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

	if (!defined($av) && !defined($bv))
	{
		my $id = $self->{id_gen}->();
		$self->{data}->[$a] = \$id;
		$self->{data}->[$b] = \$id;
	}
	elsif (defined($av) && !defined($bv))
	{
		$self->{data}->[$b] = $av;
	}
	elsif (!defined($av) && defined($bv))
	{
		$self->{data}->[$a] = $bv;
	}
	else
	{
		if (${last_ref($av)} != ${last_ref($bv)})
		{
			my $id = $self->{id_gen}->();
			my $ref_a = last_ref($self->{data}->[$a]);
			$$ref_a = \$id;
			my $ref_b = last_ref($self->{data}->[$b]);
			$$ref_b = \$id;
		}
	}

	#say Data::Dumper::Dumper($self->{data});
}

sub is_connected
{
	my $self = shift;
	my ($a, $b) = @_;

	return (defined($self->{data}->[$a]) &&
		defined($self->{data}->[$b]) &&
		${last_ref($self->{data}->[$a])} == ${last_ref($self->{data}->[$b])});
}

sub get_id_generator
{
	my $id = 1;
	return sub
	{
		return $id++;
	}
}

sub last_ref
{
	my $ref = shift;

	while (1)
	{
		return $ref if (ref($ref) ne 'REF');
		$ref = $$ref;
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
