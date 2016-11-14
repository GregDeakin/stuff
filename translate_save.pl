#! /usr/bin/perl -w

my @my_transcripts = open_file();
my $out = "";
my $dna = "";
my $protein = "";
#while (<>) {
foreach(@my_transcripts) {	
	if (/^[>]/) {
		for (my $i=0;$i<(length($dna) - 2); $i+=3) {
			$protein.=AminoOut(substr($dna,$i,3));
		}	 	
	 	print "$protein\n$_";
	 	$protein = "";
		$dna = "";
	

	} else {
		$dna .= $_;
		chomp;

	}
}
	
#$fasta=~tr/ATCG/TAGC/;
#$fasta = reverse $fasta;
#$fasta=~ s/(.{60})/$1\n/gs;
#chomp($fasta);
#$out.=$fasta;

#$out = reverse $out;
#chomp($out);
#$out = reverse $out;
#print $out;

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
                CGT => 'R', CGC => 'R', CGA => 'R', CGG => 'R', AGA => 'R', AGG =>'R',
                TCT => 'S', TCC => 'S', TCA => 'S', TCG => 'S', AGT => 'S', AGC =>'S',
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


sub open_file {
#opens the input file specified from the command line and reads it into a string variable
	my ($inFile) = $ARGV[0];
    	unless(open(INFILE, $inFile) ) {
		Instructions("Cannot open input file \"$inFile\"\n\n");
          	exit;
    	}
	my @file = <INFILE>;
#	chomp(@file);
	close INFILE;
	return @file;
}



sub write_file {
#writes the string fromatted data to the file specified from the command line
	my $outFile = "$ARGV[0]_translated_F1.fa";
	print $outFile;
	unless(open(OUTFILE,">$outFile")) {
		Instructions ("Cannot open output file \"$outFile\" for writing\n\n");
		exit;
	}
	print OUTFILE @_;
	close OUTFILE;
}

sub Instructions {

	print qq [
@{_}translate_save.pl

Creates translation of a nucleotide sequence

Usage Instructions: 

translate_save.pl <myInputFile> 

];

}

