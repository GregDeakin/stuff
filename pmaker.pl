#! /usr/bin/perl -w
use strict;
use Switch;

######################################################
#
# pmaker.pl
#
# Converts a string formatted nucleotide sequence
# to an amino acid sequence and saves it to the
# specified file
#
# Usage Instructions: 

# pmaker.pl <myInputFile> <myOutputFile> 

# # ####################################################

my $test = $ARGV[0];

switch ($test) {
	case /GC[ACGTNKSYMWRBDHV]$/ {return "A"}
	case /TG[TCY]/ {return "C"}
	case /GA[TCY]/ {return "D"}
	case /GA[AGR]/ {return "E"}
	case /TT[TCY]/ {return "F"}
	case /GG/ {return "G"}
	case /CA/ {return "H"}
	case /AT/ {return "I"}
	case /AA/ {return "K"}
	case // {return "L"}
	case /ATG/ {return "M"}
	case /AA/ {return "N"}
	case /CC/ {return "P"}
	case /CA/ {return "Q"}
	case // {return "R"}
	case /TC/ {return "S"}
	case /AC/ {return "T"}
	case /GT/ {return "V"}
	case /TG/ {return "W"}
	case /TA/ {return "Y"}
	case /T/ {return "*"}
	else {return "N"}
}
sub AminoOut {
#converts a three character nucleotide sequence to it's specified Amino Acid
#NOTE - hash copied verbatim from one of the practicals.
	my ($codon) =@_;
	$codon = uc($codon);
	$codon =~ tr/U/T/
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
		TGG => 'W', TGA => 'x',
		TAT => 'Y', TAC => 'Y',
		TAA => 'x', TAG => 'x',
	);

	if (exists ($codon_dictionary{$codon})) {
		return $codon_dictionary{$codon};
	} else {
		print STDERR "Bad codon: ";
		print  "$codon!!\n\n";
		exit;
	}
}

 