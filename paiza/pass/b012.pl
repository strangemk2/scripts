use 5.014;
use List::Util qw/sum/;

my $card_num = <STDIN>;
for (1..$card_num)
{
	chomp(my $card_id = <STDIN>);
	my $index;
	my @card_digits = split //, $card_id;

	$index = 1;
	my @even_digits = grep {$index++ % 2} @card_digits;
	$index = 0;
	my @odd_digits = grep {$index++ % 2} @card_digits;

	pop @odd_digits;
	my $checksum_remainder = calc_checksum(\@odd_digits, \@even_digits) % 10;
	say $checksum_remainder==0 ? 0 : 10-$checksum_remainder;
}

sub calc_checksum
{
	my ($odd_digits_ref, $even_digits_ref) = @_;
	my @even_digits = map {my $a = $_ * 2; $a>=10 ? int($a/10)+$a%10 : $a} @$even_digits_ref;
	return (sum @even_digits) + (sum @$odd_digits_ref);
}
