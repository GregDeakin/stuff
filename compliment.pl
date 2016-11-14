#! /usr/bin/perl -w

######################################################
#
# compliment.pl
#
# Returns the compliment of a given nucleotide sequence
#
# ####################################################

if (@ARGV) {
	$myDNA  = uc($ARGV[0]);
} else {
	$myDNA = <STDIN>;
} 
#print "$myDNA\n";
$myCompDNA = $myDNA;
$myCompDNA =~ tr/ATCG/TAGC/;
print "$myCompDNA\n";
#$myRevDNA = reverse $myDNA;
#print "$myRevDNA\n";
#$myRevCompDNA =reverse $myCompDNA;
#print "$myRevCompDNA\n";