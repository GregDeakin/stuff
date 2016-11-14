#! /usr/bin/perl
use warnings;
use strict;

##############################
#
# Returns the sequence between start and stop  
#
# Usage: get_seq.pl genome(FASTA) scaffold start stop
#
#############################

my $my_FASTA_File = uc(join("",get_file_data(0)));
$my_FASTA_File = trim($my_FASTA_File);
my @scaffold = split(/\d\d?/,$my_FASTA_File);

print substr($scaffold[$ARGV[1]],$ARGV[2], ($ARGV[3]-$ARGV[2]))."\n";


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