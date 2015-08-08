#!/usr/bin/perl
use strict;
use warnings;
use DBI;
use DBD::mysql;

# Forward declarations
my @children;
my $pid;
sub db_connect;

# Gather DB info from file
open(ACCESS_INFO, "<access_info.txt") || die "Can't access login credentials";
my $database = <ACCESS_INFO>;
my $host = <ACCESS_INFO>;
my $userid = <ACCESS_INFO>;
my $passwd = <ACCESS_INFO>;
chomp($database, $host, $userid, $passwd);
close(ACCESS_INFO);

# Connect to db and prep 
my $connection = &db_connect;
my $insert = "insert into `table name` values(?,?,?,?,?)";
my $sth = $connection->prepare($insert);

# Get current datetime
my ($d,$m,$y,$h,$min,$s) = (localtime)[3,4,5,2,1,0];
my $date = sprintf '%d-%d-%d %d:%d:%d', $y+1900, $m+1, $d, $h, $min, $s;

sub db_connect {
    my $connectionInfo="dbi:mysql:database:$host";
    my $dbh = DBI->connect($connectionInfo, $userid, $passwd);
    return $dbh;
}
