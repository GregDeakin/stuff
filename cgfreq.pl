#!/usr/bin/perl
use warnings;
use strict;

##############################
#
#Returns CG value of a FastA file
#
#############################

my @file = get_file_data(0);
my %sequences = ();
my $label;
foreach(@file) {
	chomp;
	if ($_=~m/^\>/){
		$label = $_;
		$sequences{$label}="";
	}
	else{
		$sequences{$label}.=uc($_);
	}
}
my $at = 0;
my $cg = 0; 
foreach my $key ( keys %sequences) {
	$at++ while $sequences{$key} =~ m/A|T/ig;
	$cg++ while $sequences{$key} =~ m/C|G/ig;
}

print $cg/($cg+$at);
print "\n";

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
