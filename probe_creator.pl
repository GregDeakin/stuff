#! /usr/bin/perl
use warnings;
use strict;

my @myfile = get_file_data(0);

foreach (@myfile) {
	if (($_=~/active_sequence/)&&($_=~/UNC/)) {
		my @array = split(/\"/);
		my $pn = substr($array[1],index($array[1],"P"));
		print ">$array[3].$pn\n";
		print $array[5]."\n";	}
}

sub get_file_data {
#opens the input file specified from the command line
	my ($inFile) = $ARGV[$_[0]];
    	unless(open(INFILE, $inFile) ) {
	#	Instructions("Cannot open input file \"$inFile\"\n\n");
        	exit;
    	}
	my @file = <INFILE>;
	close INFILE;
	return @file;
}
