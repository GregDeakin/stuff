#! /usr/bin/perl
use warnings;
use strict;

#get the input file
#my @myfile = get_file_data(0);

my $my_FASTA_File = uc(join("",get_file_data(0)));
$my_FASTA_File = trim($my_FASTA_File);
my @my_searches = get_file_data(1);

foreach (@my_searches) {
	if ($_=~/^>/) {
		print "$_\n";
	} else {
		my $x = substr($_,15,40); 
		my $i = index($my_FASTA_File,$x);
		if ($i==-1) {
			$x = reverse $x;
			$i = index($my_FASTA_File,$x);
		}
		if ($i==-1) {
			$x =~ tr/ACGT/TGCA/;
			$i = index($my_FASTA_File,$x);
		}
		if ($i==-1) {	
			$x = reverse $x;
			$i = index($my_FASTA_File,$x);
		}

		if ($i>-1) {
			print substr($my_FASTA_File,$i-$ARGV[2],$ARGV[2]);
			print "\n";
		}
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

sub trim
{

	my $string = shift;
	chomp($string);
	chop($string);
	$string =~ s/^\s+//;
	$string =~ s/\s+$//;
	return $string;
}

