#! /usr/bin/perl
use warnings;
use strict;

#######################################
#
# Takes a gene locations file and finds
# the upstream x basepaires
#
#######################################

#get the input file

my $my_FASTA_File = uc(join("",get_file_data(0)));
$my_FASTA_File = trim($my_FASTA_File);
my @scaffold = split(/\d\d?/,$my_FASTA_File);

my @my_searches = get_file_data(1);
#print "Scaffold,ProteinID,Sequence\n"; 
foreach (@my_searches) {
	my @protein = split(/,/);
	$protein[1]=~s/scaffold_//;
	my $primer_sequence="";
	if ($protein[3]>$protein[2]) {
		$primer_sequence=substr($scaffold[$protein[1]],$protein[2]-$ARGV[2],$ARGV[2]);
	} else {
		$primer_sequence=reverse substr($scaffold[$protein[1]],$protein[2],$ARGV[2]);
		$primer_sequence=~tr/ACGT/TGCA/c;
	}
	print "$protein[0] $primer_sequence\n";
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

