use 5.014;
use List::Util qw/first/;

chomp(my $card_line = <STDIN>);
my @cards = split //, $card_line;

if (is_four_card(@cards))
{
	say 'FourCard';
}
elsif (is_three_card(@cards))
{
	say 'ThreeCard';
}
elsif (is_two_pair(@cards))
{
	say 'TwoPair';
}
elsif (is_one_pair(@cards))
{
	say 'OnePair';
}
else
{
	say 'NoPair';
}

sub count_card
{
	my %card_map;
	$card_map{$_}++ foreach (@_);
	my $star = 0;
	if (defined($card_map{'*'}))
	{
		$star = delete $card_map{'*'};
	}
	return ($star, values(%card_map));
}

sub is_four_card
{
	my ($star, @cards) = count_card(@_);
	my $dist = 4 - $star;
	return $cards[0] == $dist;
}

sub is_three_card
{
	my ($star, @cards) = count_card(@_);
	my $dist = 3 - $star;
	return 1 if (first {$_ == $dist} @cards);
	return;
}

sub is_two_pair
{
	my ($star, @cards) = count_card(@_);
	return (($cards[0] == 2 && $cards[1] == 2) ||
		($cards[0] == 2 && $cards[1] == 1 && $star == 1) ||
		($cards[0] == 1 && $cards[1] == 2 && $star == 1));
}

sub is_one_pair
{
	my ($star, @cards) = count_card(@_);
	my $dist = 2 - $star;
	return 1 if (first {$_ == $dist} @cards);
	return;
}
