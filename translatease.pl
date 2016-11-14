#! /usr/bin/perl -w

######################################################
#
# translatease.pl
#
# Converts a string formatted nucleotide sequence
# to an amino acid sequence and saves it to the
# specified file
#
# Usage Instructions: 

# translatease.pl <myInputFile> <myOutputFile> <i>

# where i is the reading frame 0, 1 or 2
# ####################################################


	#Check the command line for input and output files. Display usage instructions if not used correctly.
#	if ($#ARGV != 2) {
#		Instructions();
#		exit;
#	}

	#checks the reading frame argument (bit of hack, couldn't get my regexp to work the other way round)
#	if ($ARGV[2]=~/^[012]$/) {
#	} else {
#		Instructions("Check reading frame must be 0,1 or 2\n\n");
 #         	exit;
#	}
	
	#get the input file
	$myStr = $ARGV[0];#get_file_data();

	#Translate to protein
	for (my $i=0;$i<3;$i++) {
		$myProtein = dna_to_protein(substr($myStr,$i));
		print "$myProtein\n";
	#write the formatted file back to the output file
	#write_string_data($myProtein);
	}


sub dna_to_protein {
#loops through a nucleotide sequence and feeds three character codons to AminoOut function, returns protein chain.

	my ($dna) = @_;
	my ($protein) = "";

	for ($i=0;$i<(length($dna) - 2); $i+=3) {
		$protein.=AminoOut(substr($dna,$i,3));
	}
	return $protein;
}	


sub AminoOut {
#converts a three character nucleotide sequence to it's specified Amino Acid
#
#NOTE - hash copied verbatim from one of the practicals.
		
	my ($codon) =@_;
	$codon = uc($codon);
	my (%codon_dictionary) = (
		GCT => 'A', GCC => 'A', GCA => 'A', GCG => 'A',  
		TGT => 'C', TGC => 'C',
		GAT => 'D', GAC => 'D',
		GAA => 'E', GAG => 'E',
		TTT => 'F', TTC => 'F',
		GGT => 'G', GGC => 'G', GGA => 'G', GGG => 'G',
		CAT => 'H', CAC => 'H',
		ATT => 'I', ATC => 'I', ATA => 'I',
		AAA => 'K', AAG => 'K', 
		TTA => 'L', TTG => 'L', CTT => 'L', CTC => 'L', CTA => 'L', CTG => 'L',
		ATG => 'M', 
		AAT => 'N', AAC => 'N',
		CCT => 'P', CCC => 'P', CCA => 'P', CCG => 'P', 
		CAA => 'Q', CAG => 'Q', 
		CGT => 'R', CGC => 'R', CGA => 'R', CGG => 'R', AGA => 'R', AGG => 'R',
		TCT => 'S', TCC => 'S', TCA => 'S', TCG => 'S', AGT => 'S', AGC => 'S',
		ACT => 'T', ACC => 'T', ACA => 'T', ACG => 'T',
		GTT => 'V', GTC => 'V', GTA => 'V', GTG => 'V', 
		TGG => 'W', TGA => '*',
		TAT => 'Y', TAC => 'Y',
		TAA => '*', TAG => '*',
	);

	if (exists ($codon_dictionary{$codon})) {
		return $codon_dictionary{$codon};
	} else {
		print STDERR "Bad codon: ";
		print  "$codon!!\n\n";
		exit;
	}
}



sub write_string_data {
#writes the string fromatted data to the file specified from the command line
	my ($outFile) = $ARGV[1];
	unless(open(OUTFILE,">$outFile")) {
		Instructions ("Cannot open output file \"$outFile\" for writing\n\n");
		exit;
	}
	print OUTFILE @_;
	close OUTFILE;
}

sub get_file_data {
#opens the input file specified from the command line and reads it into a string variable
	my ($inFile) = $ARGV[0];
    	unless(open(INFILE, $inFile) ) {
		Instructions("Cannot open input file \"$inFile\"\n\n");
          	exit;
    	}
	@file = <INFILE>;
	close INFILE;
	my ($myDNA) = join("",@file);
	return $myDNA;
}

sub Instructions {

	print qq [
@{_}translatease.pl

Translatease converts a string formatted nucleotid
sequence to a amino acid sequence and saves it to 
the specified file

Usage Instructions: 

translatease.pl <myInputFile> <myOutputFile> <i>

where i is the reading frame (0,1 or 2)

];

}
