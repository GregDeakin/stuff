#!/usr/bin/perl
use warnings;
use strict;

##############################
#
#Gets nucleotide prevelance in a FastA file (counts "other")
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
print"sequence,a,c,g,t,other\n";
foreach my $key ( keys %sequences) {

	my $a = 0; 
	$a++ while $sequences{$key} =~ m/A/ig;
	my $c = 0; 
	$c++ while $sequences{$key} =~ m/C/ig;
	my $g = 0;
	$g++ while $sequences{$key} =~ m/G/ig;	
	my $t = 0;
	$t++ while $sequences{$key} =~ m/T/ig;	
	my $na = 0;
	$na++ while $sequences{$key} =~ m/[^ATCG]/ig;
	print "$key,$a,$c,$g,$t,$na\n";

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
