#! /usr/bin/perl
use warnings;
use strict;

############################################################################################################################################################
# cat jgiIDs|xargs -I % grep "proteinId %; exonNumber 1$" Abisporus_varbisporusH97.v2.allModels.gff > output.txt
#
#    [0]	  [1]	  [2]	    [3]	   [4]	 [5]	 [6] 	 [7]	   [8]		9			10	11	12	  13 
# scaffold_1      JGI     CDS     728567  728949  .       +       0       name "estExt_fgenesh2_kg.C_10204"; proteinId 189334; exonNumber 1
#    	
#
# Takes an output file (as above) and finds the upstream n bases
# 
# USAGE: getprimer.pl genome.fasta output.txt n
#
############################################################################################################################################################


my $my_FASTA_File = uc(join("",get_file_data(0)));
$my_FASTA_File = trim($my_FASTA_File);
my @scaffold = split(/\d\d?/,$my_FASTA_File);

my @my_searches = get_file_data(1);
 
foreach (@my_searches) {
	my @protein = split(/\t|  */);
	$protein[0]=~s/scaffold_//;
	my $primer_sequence="";
	
	if ($protein[6]eq"-") {
		$primer_sequence=reverse substr($scaffold[$protein[0]],$protein[4],$ARGV[2]);
		$primer_sequence=~tr/ACGT/TGCA/;
	} else {
		$primer_sequence=substr($scaffold[$protein[0]],$protein[3]-($ARGV[2]+1),$ARGV[2]);
	}
	print ">$protein[11]\n$primer_sequence\n";
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

