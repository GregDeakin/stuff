#! /usr/bin/perl
use warnings;
use strict;

###################################################
#
# Maximises found sequences
# 
#
# Usage: reg_maximiser.pl sequence_file regex
#
###################################################



my $sequence_file = uc(join("",load_file($ARGV[0])));
$sequence_file=trim($sequence_file);
$sequence_file=uc $sequence_file;
my @scaffold=split(/\d\d?/,$sequence_file);
my $reg = $ARGV[1];
$reg = uc $reg;

my $seq_len =length $sequence_file;
#print "scaffold,start,finish\n";

my $count = 0;
my $n=0;
my $n1=0;

while ($count <200) {
	$n=calc_n();
	my $exp = $seq_len*reg_score();
	my $old_reg = $reg;
	

		$reg=mutate_reg();

	$n1=calc_n();
	my $fnd = $seq_len*reg_score($reg);
	if (($n1/$fnd)>($n/$exp)) {
		$count=0;
	} else {
		$reg=$old_reg;
		$count++
	}
}

print "$n\n$reg\n";



sub reg_score {
	my @split = split(/\[/,$reg);
	chop(@split);
	shift(@split);
	my $ret = 1;
	foreach(@split) {
		$ret=$ret*nUniqC($_)*.25;
	}
	return($ret);
}

sub mutate_reg {
	my $return = $reg;
	my $r_len = length $reg;
	my $pos = 0;
	while ($pos==0) {
		my $rand = int(rand($r_len-1))+1;
		if (substr($reg,$rand,1)=~/[A-Z]/){
			$pos = $rand;
		}
	}
	my $mutated =0;
	while ($return eq $reg) {
		my $rand = int(rand(3));
		my $nuc = "";
		if ($rand==0) {$nuc="A";
		}
		 elsif ($rand==1){$nuc="C";
		} elsif ($rand==2){$nuc="G";
		} else {$nuc="T";
		}

		substr($return, $pos, 0 ) =$nuc;
	}
	return($return);

}

sub nUniqC{
    my @uniq;
    scalar grep{ ++$uniq[$_] == 1 } unpack('C*',$_[0]);
}


sub calc_n {
	my $i=0;
	foreach (@scaffold) {
	
		my @try = match_all_positions($reg,$_);
		my $rev = reverse $_;
		push (@try,match_all_positions($reg,$rev));
		foreach (@try) {
			$i++;
		}
	}
	return($i);
}

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
