#!/usr/bin/perl
use strict;
use warnings;

my %names = ( 
    'fred' => 'flinstone',
    'barney' => 'rubble',
    'wilma' => 'flinstone',
);

print "What characters family name do you want to see?:\n";
chomp(my $input = <STDIN>);

while ( my ($k, $v) = each %names) { 
        if ($input eq $k) {
            print "$input" . "'s family name is $v\n";
        }
}
