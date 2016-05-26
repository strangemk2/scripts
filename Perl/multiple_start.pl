#!/usr/bin/perl
# simple tool for start multiple process.
use 5.010;
use strict;

my @pids;
$SIG{INT} = sub { kill 1, @pids };

if (@ARGV < 1)
{
    print "parameter error.\n";
    print "$0 [command_list]\n";
    exit 0;
}

my @cmd_list = read_list($ARGV[0]);

for my $cmd (@cmd_list)
{
    chomp($cmd);
    my $pid = fork();
    die "fork() failed: $!" unless defined $pid;
    if ($pid)
    {
        push @pids, $pid;
        print ("process [$pid:$cmd] started.\n");
    }
    else
    {
        exec($cmd);
    }
}

for (@cmd_list)
{
    my $pid = wait();
    print ("process [$pid] stoped.\n");
}

sub read_list
{
    my $filename = shift;
    open (my $fh, "<$filename") or die "open $filename error.";

    return <$fh>;
}
