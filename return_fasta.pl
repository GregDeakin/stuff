#! /usr/bin/perl -w
use warnings;
use strict;
use constant { true => 1, false => 0 };
 
my $mytran = ">".$ARGV[1];

my $mylen = substr($mytran,rindex($mytran,"_")+1);

my @my_fasta = load_file($ARGV[0]);

my $count = 0;
#print "$mytran\n";
foreach (@my_fasta) {
#	if($mytran=~$_) {
$count++;

		print "$count $_";
#	}
if ($count==10) {die;}

}
sub load_file {
  open (MYINFILE, $_[0]) or die "can't open file $_[0]";
  my @ret = <MYINFILE>;
 # chomp(@ret);
  close MYINFILE;
  return @ret;
}

