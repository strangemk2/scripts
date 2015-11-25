use lib qw(./extlib/lib/perl5);
# a mock of imap message gc server using libevent and coro.
# curl http://15.107.32.20:9090/gc?acct=zngt0000000055

use 5.014;
use AnyEvent;
use Coro;
use Coro::AnyEvent;
use Coro::Socket;
use AnyEvent::Strict;
use AnyEvent::HTTPD;
use Data::Dumper;

my $cv = AnyEvent->condvar;

my $httpd = AnyEvent::HTTPD->new (port => 9090);

$httpd->reg_cb (
	'/gc' => sub
	{
		my ($httpd, $req) = @_;

		my $account = $req->parm('acct');
		async
		{
			my ($account) = @_;
			say "start $account.";
			#Coro::AnyEvent::sleep int(rand(10));
			imap_session($account);
			say "end $account.";
		} $account;
		$req->respond ([200, 'ok', { 'Content-Type' => 'text/html' }, "<h1>request accept, account: $account</h1>" ]);
	},
	'' => sub
	{
		my ($httpd, $req) = @_;
		$req->respond ([404, 'bad', { 'Content-Type' => 'text/html' }, '<h1>bad request</h1>' ]);
	}
);

$cv->recv;

sub imap_session
{
	my $user = shift;

	my $socket = Coro::Socket->new(PeerHost => '16.147.53.88', PeerPort => 23143);
	#my $socket = Coro::Socket->new(PeerHost => 'localhost', PeerPort => 23143);
	say read_until_tag($socket, "");
	$socket->print("00 capability\r\n");
	say read_until_tag($socket, "00");
	$socket->print("00 login $user password\r\n");
	say read_until_tag($socket, "00");
	$socket->print("00 select \"Deleted Messages\"\r\n");
	say read_until_tag($socket, "00");
	$socket->print("00 search all\r\n");
	my @all = read_until_tag($socket, "00");
	say @all;
	my @uids;
	if ($all[0] =~ m/^\*/)
	{
		$all[0] =~ s/[\r\n]//g;
		@uids = split / /, $all[0];
		shift @uids;
		shift @uids;
	}
	for my $uid (@uids)
	{
		$socket->print("00 STORE $uid +FLAGS (\\Deleted)\r\n");
		say read_until_tag($socket, "00");
		say $user;
	}
	$socket->print("00 expunge\r\n");
	say read_until_tag($socket, "00");
	$socket->print("00 logout\r\n");
	say read_until_tag($socket, "00");
	$socket->close;
};

sub read_until_tag
{
	my ($fh, $tag) = @_;
	my @ret;
	while (1)
	{
		my $l = $fh->readline;
		push @ret, $l;
		last if ($l =~ m/^$tag/)
	}
	return @ret;
}
