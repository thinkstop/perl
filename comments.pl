#!/usr/bin/perl
use strict;
use warnings;

#my $login = (getpwuid $>);
#die "must run as root" if $login ne 'root';

print "This may take a few minutes to run.\n";
my @journal = `journalctl`;

