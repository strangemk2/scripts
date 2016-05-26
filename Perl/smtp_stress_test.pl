#!/usr/bin/perl
# smtp stress test tool with starttls & cram-md5 authentication.
use 5.010;
use strict;
use Time::HiRes qw/time sleep/;

use File::Basename;
use lib dirname (__FILE__);
use Net::SMTP::TLS;

my $smtp_server = $ARGV[0]; # 15.210.144.210
my $smtp_port = $ARGV[1]; # 587
my $from = $ARGV[2];
my $to = $ARGV[3];
my $mail = $ARGV[4];
my $exe_per_second = $ARGV[5];

if (@ARGV < 6)
{
    print "parameter error.\n";
    print "$0 [smtp_server] [smtp_port] [from_list] [to_list] [mail_content] [execution_per_second]\n";
    exit 0;
}

my $helo = 'ezweb.ne.jp';

my @from_list = read_list($from);
my @to_list = read_list($to);
my $data = read_file($mail);

my $flow_control = get_current_control($exe_per_second, 1);

while (1)
{
    $flow_control->(\&send_mail);
}

sub send_mail
{
    my ($smtp_user, $smtp_passwd, $from) = split /,/, pickup_from_list(@from_list);
    my $mailer = new Net::SMTP::TLS(
                    $smtp_server,
                    Hello => $helo, 
                    Port => $smtp_port, 
                    User => $smtp_user,
                    Password => $smtp_passwd,
                    Debug => 0,
                    );
    $mailer->mail($from);
    $mailer->to(pickup_from_list(@to_list));
    $mailer->data;
    $mailer->datasend($data);
    $mailer->dataend;
    $mailer->quit;
}

sub read_list
{
    my $filename = shift;
    open (my $fh, "<$filename") or die "open $filename error.";

    return <$fh>;
}

sub read_file
{
    my $filename = shift;
    open (my $fh, "<$filename") or die "open $filename error.";

    local $/;
    return <$fh>;
}

sub pickup_from_list
{
    return $_[rand @_];
}

sub get_current_control
{
    my ($times, $seconds) = @_;
    my $interval = $seconds / $times;
    return sub
    {
        my $code_ref = shift;
        my $before = time();
        $code_ref->();
        my $after = time();
        my $time_to_sleep = $interval - ($after - $before);
        sleep($time_to_sleep) if ($time_to_sleep > 0);
    }
}
