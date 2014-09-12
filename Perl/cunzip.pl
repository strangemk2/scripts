#!/usr/bin/perl
# unzip with filename codepage convert.
# don't work on specified Perl version

use strict;
use IO::Uncompress::Unzip qw($UnzipError);
use IO::File;
use Encode qw(from_to);
use File::Basename;
use File::Path qw(make_path);
use Getopt::Std;

my %opts;
getopts('lxf:t:d:', \%opts);
my $zipfile = shift @ARGV;
die "Use: $0 [-l] [-f from_cp] [-t to_cp] [-d directory] [-x] filename." unless ($zipfile);
my $codepage_from = $opts{f} || "cp932";
my $codepage_to = $opts{t} || "utf8";
my $prefix_directory = $opts{d} || "";

my $u = new IO::Uncompress::Unzip $zipfile or die "Cannot open $zipfile: $UnzipError";

sub is_dirname
{
    my $name = shift;
    substr($name, -1) eq '/';
}

if ($opts{x} && !$opts{l})
{
	my ($name,$path,$suffix) = fileparse($zipfile, qr/\.[^.]*/);
	make_path($name) unless (-d $name);
	$prefix_directory .= $name;
}

my $status;
for ($status = 1; $status > 0; $status = $u->nextStream())
{
    my $name = $u->getHeaderInfo()->{Name};
    from_to($name, $codepage_from, $codepage_to);
    warn "$status: Processing member $name\n";
	next if ($opts{l});

	$name = "$prefix_directory/$name";
    if (is_dirname($name))
    {
        make_path($name) unless (-d $name);
        next;
    }
    my $buff;
    my $fh = IO::File->new("> $name") || die "Open file $name for output error";
    $fh->binmode;
    while (($status = $u->read($buff)) > 0) {
        print $fh $buff;
    }
    $fh->close;
    last if $status < 0;
}
die "Error processing $zipfile: $!\n" if $status < 0 ;
