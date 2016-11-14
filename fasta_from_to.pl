#! /usr/bin/perl
use warnings;
use strict;
use constant { true => 1, false => 0 };

#######################################
#
# Returns a portion of a fasta file
# 
# fasta_from_to.pl filename header from to 
#
####################################### 

my @my_fasta = load_file($ARGV[0]);

my $start = false;
if ($ARGV[1]==0) {
	$start = true;
}
my $out = "";
foreach(@my_fasta) {
#	print "$_\n";
	if ($start) {
		last if ($_=~/>/);
#		print "$_\n";
		$out.=$_;
	}
	if ($_=~/$ARGV[1]/){
		$start =true;
	}
}

if(!$ARGV[2]) {
	print">chr$ARGV[1]\n";
	print"$out\n";

} else {

	print substr($out,$ARGV[2]-1,($ARGV[3]-$ARGV[2])+1);
	print "\n";
}
	
sub load_file {
  open (MYINFILE, $_[0]) or die "can't open file $_[0]";
  my @ret = <MYINFILE>;
  chomp(@ret);
  close MYINFILE;
  return @ret;
}

