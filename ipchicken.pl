#!/usr/bin/perl
use strict;
use warnings;
use 5.014;

my @split = `curl -s www.ipchicken.com`;

foreach my $a ( @split ) { 
    my @final = join(":", split(' ', $a));
    foreach my $x ( @final ) {
        if ($x =~ /(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})/) {
            print "$1\n";
        } 
    }
}
