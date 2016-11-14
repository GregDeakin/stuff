#! /usr/bin/perl
use warnings;
use strict;

###################################################
#
# Searches for a regex defined fasta region
# in a FASTA sequnce file
#
# Usage: find_regex.pl sequence_file regex
#
###################################################


my $sequence_file = uc(join("",load_file($ARGV[0])));
$sequence_file=trim($sequence_file);
$sequence_file=uc $sequence_file;
my @scaffold=split(/\d\d?/,$sequence_file);
#my @scaffold=split(/>/,$sequence_file);
my $reg = "";
if($#ARGV == 1) {
	$reg = $ARGV[1];
} else {
	$reg = <STDIN>;
}
chomp $reg;
$reg = uc $reg;
my $n=0;
my $i=0;
#print $scaffold[1];
print "scaffold,start,finish\n";
foreach (@scaffold) {
	
	my @try = match_all_positions($reg,$_);
	my $rev = reverse $_;
	$rev=~tr/ACGT/TGCA/;
	my @t = match_all_positions($reg,$rev);
	foreach (@t) {
		print "reversed\n";
		my $myLen = length($rev);
		push @try,[ $myLen-$_->[1],$myLen-$_->[0] ];
	}
	foreach (@try) {
		my $num=$_->[0]+1;
		print "$i,$num,$_->[1]\n";
		$n++;
	}
	$i++;
}
print "$n\n";

sub match_all_positions { 
    my ($regex, $string) = @_; 
    my @ret; 
    while ($string =~ /$regex/g) { 
        push @ret, [ $-[0], $+[0] ]; 
    } 
    return @ret 
} 

sub load_file {
  open (MYINFILE, $_[0]) or die "can't open file $_[0]";
  my @ret = <MYINFILE>;
  chomp(@ret);
  close MYINFILE;
#  shift(@ret);
  return @ret;
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
