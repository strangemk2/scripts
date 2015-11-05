<STDIN>;
chomp(@l = <STDIN>);
for (@l)
{
	my $t = reverse($_);
	$m = $t if ($t eq $_ && ($t le $m || !defined($m)));
	$r{($_ le $t?$_:$t)}++;
}
for $k (sort(keys(%r)))
{
	$res .= $k for (1..$r{$k}/2);
}
$res .= $m . reverse($res);
print $res, "\n";
