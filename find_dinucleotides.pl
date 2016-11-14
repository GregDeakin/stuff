#!/usr/bin/perl
use warnings;
use strict;

######################################################
#
# find_dinucleotides.pl
#
# Finds dinucleotides in a (DNA) fasta file
# Multiple sequences can be read 
# ambigeous nucleotides are ignored
#
# Usage Instructions: 
#
# find_dinucleotides fasta_file
# 
# ####################################################



my @file = get_file_data(0);
my %sequences = ();
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

my @my_searches=probe_set(2);
foreach (@my_searches){
	print ",$_";
}


sub countnmstr {
    my ($haystack, $needle) = @_;
    my ($first, $rest) = $needle =~ /^(.)(.*)$/;
    return scalar (() = $haystack =~ /(\Q$first\E(?=\Q$rest\E))/g);
}

foreach my $key ( keys %sequences) {
	print"\n$key,";

	foreach(@my_searches){

		print countnmstr($sequences{$key},$_).",";

#		my $count = 0; 
#		my $count2 =()= $sequences{$key} =~/$_/g;
#		$count++ while $sequences{$key} =~/$_/g;
#		print "$count2,"; 
	}
}

sub probe_set {
       #creates a complete set of nucleotides for the input value 	
  my @str;
  my $inp = 4**($_[0]);
  for (my $i=$inp;$i<2*$inp;$i++) {
    my $num=$i;
    my $str="";
    while ($num>1) {
      $str=$num%4 . $str;
      $num/=4; 
    }
    $str =~ s/^.//s;
    $str =~ tr/0123/ACGT/;
    push(@str,$str); 
  }
  unshift(@str, shift(@str)."A");
  return @str;
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
