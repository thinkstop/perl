#!/usr/bin/perl
use strict;
use warnings;

my %lines;

my $file = ("logrotate.conf");
my $tmp = "$file.tmp";
open IN, "<$file" or die "Can't open $file: $!\n";

while (<IN>) {
    chomp($_);
    $lines{$_}++;
}

while ( my ($key, $value) = each(%lines) ) {
    print "$key => $value\n";
}

sub in {
    my $path = shift;
    open(my $fh, '<', $path) || return undef;
    return $fh;
}

sub out {
    my $path = shift;
    open(my $fh, '>', $path) || return undef;
    return $fh;
}
