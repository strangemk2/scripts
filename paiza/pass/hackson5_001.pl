use strict;
my $secret = <STDIN>;
for (my $i = 0; $i < length($secret); $i+=2)
{
	print substr($secret, $i, 1);
}
print "\n";
