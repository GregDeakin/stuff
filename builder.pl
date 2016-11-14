#!/usr/bin/perl
#use warnings;
use strict;
use Switch 'fallthrough';


##############################
#
# Finds the start, stop and scaffold for a gene 
#
# Usage: builder.pl locations file
#
#############################

my @tan_loc = load_file($ARGV[0]);
my %genome=();


foreach ( @tan_loc) {
	my @split = split(/\t/);
	my @name = split(/ /,$split[8]);
	foreach (@name) {
		s/\;//;
	}
	$genome{$name[1]}{"scaffold"}=$split[0];
#	$genome{$name[1]}{"start"}=1000000000000;
#	$genome{$name[1]}{"stop"}=0;

	if ($split[6]=~/\+/) {
		if (defined($genome{$name[1]}{"start"})) {
			if ($split[3] < $genome{$name[1]}{"start"}) {
				$genome{$name[1]}{"start"}=$split[3];
			}
			if ($split[4] > $genome{$name[1]}{"stop"}) {
				$genome{$name[1]}{"stop"}=$split[4];
			}
		} else {
			$genome{$name[1]}{"start"}=$split[3];
			$genome{$name[1]}{"stop"}=$split[4];
		}
	} else {
		if (defined($genome{$name[1]}{"start"})) {
			if ($split[4] > $genome{$name[1]}{"start"}) {
				$genome{$name[1]}{"start"}=$split[4];
			}
			if ($split[3] < $genome{$name[1]}{"stop"}) {
				$genome{$name[1]}{"stop"}=$split[3];
			}
		} else {
			$genome{$name[1]}{"start"}=$split[4];
			$genome{$name[1]}{"stop"}=$split[3];
		}
	}

	if ($split[2]=~/^CDS/) {
		$genome{$name[1]}{"protein"}=$name[3];
	}


#	if ($split[2]=~/codon$/) {
#		$genome{$name[1]}{substr($split[2],0,index($split[2],/_/))}=$split[3];
#	} 
#	if ($split[2]=~/^CDS/) {
#		$genome{$name[1]}{"protein"}=$name[3];
#		if(!$genome{$name[1]}{substr($split[2],0,index($split[2],/_/))}) {
#			if ($split[6]=~/\+/) {
#				
#			$genome{$name[1]}{substr($split[2],0,index($split[2],/_/))} = $split[3];
#		}
#	}

}

my( $proteinID, $start, $stop, $scaffold);
print "ProteinID,scaffold,start,stop\n";
for my $model (keys %genome) {
	my $proteinID = %genome->{$model}->{"protein"};
	my $start = %genome->{$model}->{"start"};
	my $stop = %genome->{$model}->{"stop"};
	my $scaffold = %genome->{$model}->{"scaffold"};

	print "$proteinID,$scaffold,$start,$stop\n";
}
	

sub load_file {
  open (MYINFILE, $_[0]) or die "can't open file $_[0]";
  my @ret = <MYINFILE>;
  chomp(@ret);
  close MYINFILE;
  shift(@ret);
  return @ret;
}
