#!/usr/bin/perl
use warnings;
use strict;

my $i=1;
my $j=1;
my $x=40+int(rand($ARGV[1]-40));
while($i <= $ARGV[0]) {
	print ">r_dna_$i\n";
	while($j <= $x) {
		my $rnd_num = int(rand(4));
		if ($rnd_num == 0) {print "A"}
		elsif ($rnd_num == 1) {print "T"}
		elsif ($rnd_num == 2) {print "C"}
		else {print "G"}
		$j++;
	}
	print "\n";
	$i++;
	$j=1;
	$x = 40+int(rand($ARGV[1]-40));

}