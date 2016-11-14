#! /usr/bin/perl -w

my @my_transcripts = open_file();
my $out = "";
my $fasta = "";
#while (<>) {
foreach(@my_transcripts) {	
	if (/^[>]/) {
		$fasta=~tr/ATCG/TAGC/;
		$fasta = reverse $fasta;
		$fasta=~ s/(.{60})/$1\n/gs;
		chomp($fasta);
		$out.="$fasta\n$_";
		$fasta = "";	

	} else {
		chomp;
		$fasta.=$_;
	}
}
$fasta=~tr/ATCG/TAGC/;
$fasta = reverse $fasta;
$fasta=~ s/(.{60})/$1\n/gs;
chomp($fasta);
$out.=$fasta;

$out = reverse $out;
chomp($out);
$out = reverse $out;
#print $out;

write_file($out);

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
	my $outFile = "$ARGV[0]_rev_comp.fa";
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
@{_}rcsave.pl

Creates reverse compliment of nucleotide sequence

Usage Instructions: 

rcsave.pl <myInputFile> 

];

}

