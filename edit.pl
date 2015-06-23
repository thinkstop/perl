#!/usr/bin/perl
use strict;
use warnings;

my $file = "rules";
my $echo = "new_rules";
my $bak = "rules.bak";


print "Are you turning the firewall on or off?:\n";
chomp(my $input = <STDIN>);

my $logdrop = '-A LOGDROP -j DROP';
my $notdrop = '#-A LOGDROP -j DROP';

open IN, "<$file" or die "Can't open $file: $!\n";
open OUT, ">$echo" or die "Can't open $echo: $!\n";
while ( my $line = <IN> ) {
    chomp($line);
    if  ( "$input" eq "off" && "$line" eq "$notdrop") {
        print "Firewall is already off\n";
        print OUT "$line\n";
        next;
    } elsif ( $input eq 'on' && $line eq $notdrop) {
        print "Turning firewall $input\n";
        print OUT "$logdrop\n";
        next;
    } elsif ( $input eq 'off' && $line eq $logdrop) {
        print "Turning firewall $input\n";
        print OUT "$notdrop\n";
        next;
    } elsif ( $input eq 'on' && $line eq $logdrop) {
        print "Firewall is already on\n";
        print OUT "$line\n";
        next;
    } else {
        print OUT "$line\n";
        next;
    }
}
close IN;
close OUT;

rename($file, $bak) or die "can't rename $file to $bak: $!";
rename($echo, $file) or die "can't rename $echo to $file: $!";
