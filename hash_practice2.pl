#!/usr/bin/perl
use warnings;
use strict;

my %lines;
my $file = "hashpractice2.txt";
open IN, "<$file" or die "Can't open\n";
while (<IN>) {
    chomp($_);
    $lines{$_}++;
}

while (my ($k, $v) = each %lines) {
    print "$k was seen $v times\n";
}
