#!/usr/bin/perl
use strict;
use warnings;

print "What are you searching for?(DPT, SRC, DST, PROTO, IN, MAC):\n";
chomp(my $in = <STDIN>); 
print "$in=\n";

my @journal = `journalctl -k`;
my @slim = &uniq (grep (/SRC=/, @journal));
my %hash = ();

foreach my $a (@slim) {
    my @final = join("\n", split(' ', $a));
    foreach my $x ( @final ) {
        if ($x =~ /$in=(.*)/) {
            $hash{$1}++;
        }
    }
}
for my $ip ( sort keys %hash) {
    print "$ip\n";
}




sub uniq {
    my %seen;
    return grep { !$seen{$_}++ } @_;
}

#    foreach my $i (@final) {
#        while ($i) { 
#            if (/^SRC=(.*)/) {
#                $hash{$1}++
#            } else { 
#                last;
#            }
#            last;
#        }
#        for my $ip ( sort keys %hash ) {
#            print "$ip: $hash{$ip}\n";
#        }
#    }
#}
