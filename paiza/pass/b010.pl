use 5.014;

chomp(my $header = <STDIN>);
my ($team, $player_number) = split / /, $header;
chomp(my $team_a_pos_line = <STDIN>);
chomp(my $team_b_pos_line = <STDIN>);

my @my_team_pos = split / /, $team_a_pos_line;
my @enemy_team_pos = split / /, $team_b_pos_line;
if ($team ne 'A')
{
	# swap team
	my @tmp_pos = @my_team_pos;
	@my_team_pos = swap_side(@enemy_team_pos);
	@enemy_team_pos = swap_side(@tmp_pos);
}

# set nutual index
unshift @my_team_pos, '';

my $enemy_team_2nd_pos = (sort {$b <=> $a} (@enemy_team_pos))[1];
my $offset_num = 0;
foreach my $n (1..11)
{
	if (is_in_enemy_side(\@my_team_pos, $n) &&
		is_closer_to_enemy_goal(\@my_team_pos, $n, $player_number) &&
		is_in_front_of_enemy_keeper(\@my_team_pos, $n, $enemy_team_2nd_pos))
	{
		say $n;
		$offset_num++;
	}
}
say 'None' if ($offset_num == 0);

sub swap_side
{
	return map { 110 - $_ } @_;
}

sub is_in_enemy_side
{
	my ($team_pos_ref, $number) = @_;
	return $team_pos_ref->[$number] >= 55;
}

sub is_closer_to_enemy_goal
{
	my ($team_pos_ref, $number1, $number2) = @_;
	return $team_pos_ref->[$number1] > $team_pos_ref->[$number2];
}

sub is_in_front_of_enemy_keeper
{
	my ($team_pos_ref, $number, $enemy_team_2nd_pos) = @_;
	return $team_pos_ref->[$number] > $enemy_team_2nd_pos;
}
