#!/usr/bin/perl
use strict;
use warnings;
use IO::Socket::INET;
use DBI;
use DBD::mysql;

my @children;
my $pid;
sub db_connect;

# Open the accessDB file to retrieve the database name, host name, user name
# and password
open(ACCESS_INFO, "<access_info.txt") || die "Can't access login credentials";

# assign the values in the accessDB file to the variables
my $database = <ACCESS_INFO>;
my $host = <ACCESS_INFO>;
my $userid = <ACCESS_INFO>;
my $passwd = <ACCESS_INFO>;

# the chomp() function will remove any newline character from the end of a
# string
chomp ($database, $host, $userid, $passwd);


# close the accessDB file
close(ACCESS_INFO);

# auto-flush on socket
$| = 1;

my $socket = new IO::Socket::INET (
    LocalHost => '0.0.0.0',
    LocalPort => '7777',
    Proto => 'tcp',
    Listen => 5,
    Reuse => 1,
);
die "cannot create socket $!\n" unless $socket;
print "server waiting for client connection on port 7777\n";

while(my $client_socket = $socket->accept()) {

    if( my $pid = fork) {
        print "Child Spawned : $pid\n";
        push(@children, $pid);
    } elsif( !defined $pid ) {
        die "Cannot fork $!\n"
    } else {
        
        #waiting for client connection
        #my $client_socket = $socket->accept();
            
        # Connect to database and prepare the insert string
        my $connection = &db_connect;
        my $insert = "insert into `connect` values(?,?,?,?,?,?)";
        my $sth = $connection->prepare($insert);

        #get information about a newly connected client
        #my $client_address = $client_socket->peerhost();
        #my $client_port = $client_socket->peerport();
        chomp(my $srcip = $client_socket->peerhost());
        chomp(my $srcport = $client_socket->peerport());
        chomp(my $dstip = $client_socket->sockhost()); 
        chomp(my $dstport = $client_socket->sockport());
        my $data = $socket;
        
        $client_socket->timeout(10);
        $client_socket->recv($data, 1024);
        print "received data: $data from $srcip\n";
        my $hash = $data;
        $hash =~ s/\r\n//;
        print "$hash\n";
        print "connection from $srcip : $srcport\n";
        
        my ($d,$m,$y,$h,$min,$s) = (localtime)[3,4,5,2,1,0];
        my $date = sprintf '%d-%d-%d %d:%d:%d', $y+1900, $m+1, $d, $h, $min, $s;

        print "$date>$hash>$srcip>$srcport>$dstip>$dstport\n";
        $sth->execute($date,$hash,$srcip,$srcport,$dstip,$dstport);

        $data = "ok";
        $client_socket->send($data);
        shutdown($client_socket, 1);
        exit;
    }
}
foreach (@children) {
    waitpid($_, 0);
}

$socket->close();

sub db_connect { 
    # my $db = @_;
    # assign the values to your connection variable
    my $connectionInfo="dbi:mysql:gratisvpn:$host";
    my $dbh = DBI->connect($connectionInfo, $userid, $passwd);
    return $dbh;
}
