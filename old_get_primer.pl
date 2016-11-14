#! /usr/bin/perl
use warnings;
use strict;

#get the input file
my @sequence = get_file_data(0);
my @gene = get_file_data(1);
my %primers = ();

foreach (@sequence) {
	my @s = split(/ /);
	$primers{$s[0]}=$s[1];
}

foreach (@gene) {
	print ">$_\n$primers{$_}\n";
}


sub get_file_data {
#opens the input file specified from the command line
	my ($inFile) = $ARGV[$_[0]];
    	unless(open(INFILE, $inFile) ) {
		Instructions("Cannot open input file \"$inFile\"\n\n");
        	exit;
    	}
	my @file = <INFILE>;
	chomp(@file);
	
	close INFILE;
	return @file;
}
