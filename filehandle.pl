#!/usr/bin/perl
use strict;
use warnings;
my $file = <FH>;
while (defined($file = <>)) {
    chomp $file; 
    print "$file\n";
}
