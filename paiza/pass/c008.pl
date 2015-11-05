use 5.014;
chomp(my $header_line = <STDIN>);
my ($tag_in, $tag_out) = split / /, $header_line;

chomp(my $data = <STDIN>);

my @res = ($data =~ m/$tag_in(.*?)$tag_out/g);
foreach (@res)
{
	say $_?$_:'<blank>';
}
