#!/usr/bin/perl
use strict;
use warnings;

# Globals
my %dups = ();
my @keys;
#my @v;

# Must be ran as root as the messages file can only be seen
# by root
my $login = (getpwuid $>);
die "must run as root" if $login ne 'root';

#TODO: Add an option so user can specify file
# Define the file to be opened
my @files = glob "'/var/log/messages*'";
#my $file = "/var/log/messages";
#print "@files\n";

# Open the file with the filehandle IN
foreach my $file ( @files ) {
    #print "$file\n";
    open IN, "<$file" or die "Can't open $file: $!\n";

    # Use the file we opened
    while ( my @line = <IN> ) {
        for my $x ( @line ) {
            # Separate the fields so we can use them
            my @final = split(' ', $x);
            # Iterate over each element so we can match on what we want
            for my $i ( @final ) { 
                # Match on their source IP and assign it to @keys 
                if ($i =~ m/SRC=(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})/) {
                    push @keys, $1;
                    # Add matched IP to hash and increment it's value
                    $dups{$1}++;
                
                # Keeping this DST ip around cause might use it someday
                #} elsif ($i =~ m/DST=(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})/) {
                #   push @v, $i;
                } else {
                    next;
                }
            }
        }
    }
}

# Using a hash because native uniq on keys
# The next function performs a descending sort switch $b and $a to make it
# an ascending sort
my @fin = sort { $dups{$b} <=> $dups{$a} } keys %dups;
foreach my $fun (@fin) {
     printf "%-20s %6d\n", $fun, $dups{$fun};
}
