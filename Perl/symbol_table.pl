#!/usr/bin/perl -w

# example of manunipate perl symbol table

sub aaa
{
	print "aaa\n";
}

aaa();

foreach my $entry ( keys %main:: ) {
	print "$entry\n";
}

sub ccc
{
	print "ccc\n";
}

$aaa_bak = \&aaa;
$main::{aaa} = sub {print "bbb\n"};
aaa();

$main::{aaa} = $aaa_bak;
aaa();
