use 5.014;

package amidakuji_line;

sub new
{
	my $class = shift;
	return bless {sorted => 0, data => []}, $class;
}

sub set_anchor
{
	my $self = shift;
	my $anchor = shift;
	push @{$self->{data}}, $anchor;
}

sub find_prev_anchor
{
	my $self = shift;
	my $pos = shift;

	if (!$self->{sorted})
	{
		$self->sort_anchor();
		$self->{sorted} = 1;
	}

	my $index = $self->find_anchor_index($pos);
	if (!defined($index))
	{
		return $self->{data}->[-1];
	}
	else
	{
		return ($index == 0)?undef:$self->{data}->[$index-1];
	}
}

sub sort_anchor
{
	my $self = shift;
	@{$self->{data}} = sort {$a->{pos} <=> $b->{pos}} @{$self->{data}};
}

sub find_anchor_index
{
	my $self = shift;
	my $pos = shift;
	return bsearch($pos, $self->{data});
}

sub bsearch
{
	my ($x, $anchor_list_ref) = @_;
	my ($lower, $upper) = (0, @$anchor_list_ref - 1);
	my $i;
	while ($lower <= $upper)
	{
		$i = int(($lower + $upper) / 2);
		if ($anchor_list_ref->[$i]->{pos} < $x)
		{
			$lower = $i + 1;
		}
		elsif ($anchor_list_ref->[$i]->{pos} > $x)
		{
			$upper = $i - 1;
		}
		else
		{
			return $i;
		}
	}
	return undef;
}


package anchor;

sub new
{
	my $class = shift;
	my ($line, $pos, $oppsite_line, $oppsite_pos) = @_;
	return bless {
		line => $line,
		pos => $pos,
		oppsite_line => $oppsite_line,
		oppsite_pos => $oppsite_pos
	}, $class;
}

sub opposite
{
	my $self = shift;
	return ($self->{oppsite_line}, $self->{oppsite_pos});
}


package main;

my $header_line = <STDIN>;
my ($length, $vertical_line_num, $horizental_line_num) = split / /, $header_line;

my @vertical_lines;
$vertical_lines[$_] = amidakuji_line->new($length) for (1..$vertical_line_num);
for (1..$horizental_line_num)
{
	chomp(my $line = <STDIN>);
	my ($start_line, $start_pos, $end_pos) = split / /, $line;
	my $end_line = $start_line + 1;

	my $start_anchor = anchor->new($start_line, $start_pos, $end_line, $end_pos);
	my $end_anchor = anchor->new($end_line, $end_pos, $start_line, $start_pos);
	$vertical_lines[$start_line]->set_anchor($start_anchor);
	$vertical_lines[$end_line]->set_anchor($end_anchor);
}

say back_walk_amidakuji(\@vertical_lines, 1, $length);

sub back_walk_amidakuji
{
	my ($vertical_lines_ref, $start_line, $start_length) = @_;

	my $work_line = $start_line;
	my $work_length = $start_length;
	while (1)
	{
		my $anchor = $vertical_lines_ref->[$work_line]->find_prev_anchor($work_length);
		return $work_line if (!defined($anchor));

		($work_line, $work_length) = $anchor->opposite();
	}
}
