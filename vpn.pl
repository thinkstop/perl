#!/usr/bin/perl
use strict;
use warnings;


my $login = (getpwuid $>);
die "must run as root" if $login ne 'root';

my $process_id = `pgrep openvpn`;

if ($process_id) {
    print "Openvpn is already running as PID:$process_id\n";
} else {
    system("/usr/bin/openvpn", "/etc/openvpn/mullvad.conf");
    print "Openvpn's PID should be: `pgrep openvpn`\n";
}
