#!/usr/bin/perl
use strict;
use warnings;
use Net::DNS;

my $r = Net::DNS::Resolver->new;

for my $ip (@ARGV) {
my $reverse = join( '.', reverse( split /\./, $ip )) . '.in-addr.arpa';
    if (my $ap = $r->query( $reverse, 'PTR' )) {
        for my $pa ($ap->answer) {
            print "$ip => ", $pa->ptrdname, $/;
        }
    } else {
        print "$ip => NXDOMAIN\n";
    }
}
