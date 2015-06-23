#!/usr/bin/perl
use strict;
use warnings;

my @journal = `journalctl`;
my @trim =~ m/.*SRC=.*/, @journal;
print "@trim\n";









sub uniq {
    my %seen;
    grep !$seen{$_}++, @_;
}
