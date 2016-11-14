#!/usr/bin/perl
use warnings;
use strict;


#get the input file

my $my_transcripts = join("",get_file_data(0));
#my @transcript = split(/>/,$my_transcripts);
my $location = $ARGV[0];
my $sequence = "";
while (<>) {
	if (/(.*\d+)/) {
		if (length($sequence)>0) {
			print length($sequence).",";
			my $MA = getMA($sequence);		
		}
		my $name = $1;
		print "$location,$name,";
		$sequence = "";
		 
	} else {
#		print $_;
		chomp;
		$sequence.=$_;
	}
}

print length($sequence).",";
my $MA = getMA($sequence);

sub getMA {

	my ($myDNA)  = @_;
	$myDNA = uc($myDNA);
		
	my @maxave = runX($myDNA);
#	print "$myDNA\n";
	my $myCompDNA = $myDNA;
	$myCompDNA =~ tr/ATCG/TAGC/;
	my @cmaxave = runX($myCompDNA);
	if ($cmaxave[0] > $maxave[0] ) { @maxave = @cmaxave;}
#	print "$myCompDNA\n";
	my $myRevDNA = reverse $myDNA;
	my @rmaxave = runX($myRevDNA);
	if ($rmaxave[0] > $maxave[0] ) { @maxave = @cmaxave;}	
#	print "$myRevDNA\n";
	my $myRevCompDNA =reverse $myCompDNA;
	my @rcmaxave = runX($myRevCompDNA);
	if ($rcmaxave[0] > $maxave[0] ) { @maxave = @cmaxave;}	
#	print "$myRevCompDNA\n";
	print $maxave[0].",".$maxave[1]."\n";

}

sub runX {
	my ($myDNA)  = @_;
	my @return = (0,0);
	for (my $i=0;$i<3;$i++) {
		my $myProtein = dna_to_protein(substr($myDNA,$i));
		my @allProt = split(/x/,$myProtein);
		my $max = 0;
		my $avg = 0;
		foreach (@allProt) {
			if (length($_) > $max) {$max = length($_);}
			$avg += length($_);
		}
		$avg /=scalar(@allProt);
 		if ($max>$return[0]) {@return = ($max,$avg);} 

	}
	return @return;

}


sub dna_to_protein {
#loops through a nucleotide sequence and feeds three character codons to AminoOut function, returns protein chain.

	my ($dna) = @_;
	my ($protein) = "";
	for (my $i=0;$i<(length($dna) - 2); $i+=3) {
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

sub trim
{

	my $string = shift;
	chomp($string);
	chop($string);
	$string =~ s/^\s+//;
	$string =~ s/\s+$//;
	$string =~ s/>SCAFFOLD_//g;
	return $string;
}