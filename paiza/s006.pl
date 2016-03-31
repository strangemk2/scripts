use 5.014;
use Data::Dumper;

sub get_number
{
	my $s = shift;
	$s =~ s/^[0-9]+//p;
	return (${^MATCH}, $s);
}

sub get_string
{
	my $s = shift;
	$s =~ s/^[a-z]+//p;
	return (${^MATCH}, $s);
}

sub make_str_result
{
	my $ret = {type => 'str', data => []};
	for my $ch (split //, shift)
	{
		$ret->{data}->[ord($ch) - ord('a')]++;
	}
	return $ret;
}

sub can_calculate
{
	my $result_ref = shift;
	return 0 if (@$result_ref < 2);
	return 1 if ($result_ref->[-1]->{type} eq 'str');
	return 1 if ($result_ref->[-1]->{type} eq 'r');
	return 0;
}

sub print_result
{
	my $result_ref = shift;
	for (my $i = 0; $i < 26; ++$i)
	{
		$result_ref->{data}->[$i] //= 0;
		print chr($i + ord('a')), " $result_ref->{data}->[$i]\n";
	}
}

sub do_calculate
{
	my $result_ref = shift;
	my $r = pop $result_ref;

	if ($r->{type} eq 'str')
	{
		if ($result_ref->[-1]->{type} eq 'str' || $result_ref->[-1]->{type} eq 'l')
		{
			for (my $i = 0; $i < @{$r->{data}}; ++$i)
			{
				$result_ref->[-1]->{data}->[$i] += $r->{data}->[$i];
			}
		}
		elsif ($result_ref->[-1]->{type} eq 'num')
		{
			my $num = $result_ref->[-1]->{data};
			$result_ref->[-1]->{type} = 'str';
			$result_ref->[-1]->{data} = [];
			for (my $i = 0; $i < @{$r->{data}}; ++$i)
			{
				$result_ref->[-1]->{data}->[$i] = $r->{data}->[$i] * $num;
			}
		}
	}
	else
	{
		$result_ref->[-1]->{type} = 'str';
	}
}

sub count_alphabets
{
	my $data = shift;

	$data =~ s/([0-9])([a-z])/$1($2)/g;

	my @result;
	while ($data ne '')
	{
		given ($data)
		{
			when (m/^[a-z]+/)
			{
				my $str;
				($str, $data) = get_string($data);
				push @result, make_str_result($str);
			}
			when (m/^[0-9]+/)
			{
				my $num;
				($num, $data) = get_number($data);
				push @result, {type => 'num', data => $num};
			}
			when (m/^\(/)
			{
				push @result, {type => 'l', data => []};
				$data = substr($data, 1);
			}
			when (m/^\)/)
			{
				push @result, {type => 'r'};
				$data = substr($data, 1);
			}
		}

		while (can_calculate(\@result))
		{
			do_calculate(\@result);
		}
	}

	return $result[0];
}

chomp(my $data = <>);
print_result(count_alphabets($data));
