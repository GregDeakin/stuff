#! /usr/bin/perl -w

#Reverse Compliment DNA Strand

my @file = get_file_data(0);

foreach (@file) {
	chomp;
	if ($_=~m/^\>/){
		print "$_\n";
	}
	else{	
		my $myCompDNA = $_;
		$myCompDNA =~ tr/atcgATCG/tagcTAGC/;
		my $myRevCompDNA =reverse $myCompDNA;
		print uc($myRevCompDNA);
		print "\n";
	}
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



