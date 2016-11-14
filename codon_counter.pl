#!/usr/bin/perl
use warnings;
use strict;

#####
# Counts codons
#####

my @file = get_file_data(0);
my %sequences = ();
my %codons = ();
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

foreach my $key ( keys %sequences) {
	my $my_seq = $sequences{$key};
	my %cDNA = ();
	$cDNA{substr($my_seq,0,length($my_seq)-(length($my_seq)%3))}=0;
	foreach my $seq ( keys %cDNA) {
		$cDNA{$seq}=stop_counter($seq);
	}
	my $lowest=(sort {$cDNA{$a} <=> $cDNA{$b}} keys %cDNA)[0];
	for (my $i=0;$i<(length($lowest) - 2); $i+=3) {
		$codons{substr($lowest,$i,3)}++;
	}
	if ($ARGV[1]==1 ) {
		print "$key\n";
		foreach my $codon (keys %codons) {
			print "$codon ".AminoOut($codon)." ".$codons{$codon}."\n"  
		}
		%codons = ();
	}
}
if ($ARGV[1]==0 ) {
	foreach my $key (keys %codons) {
		print "$key ".AminoOut($key)." ".$codons{$key}."\n";  
	}
}

sub stop_counter {
#counts stop codons

	my ($dna) = @_;
	my ($count) = 0;

	for (my $i=0;$i<(length($dna) - 2); $i+=3) {
		my $codon = substr($dna,$i,3);
		$count++ if $codon=~/T(G|A)(G|A)/i;
	}
	return $count;
}


sub AminoOut {
		
	my ($codon) =@_;
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
		return  "Bad codon: ";
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
