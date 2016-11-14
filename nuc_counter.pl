#! /usr/bin/perl -w

my $a = 0; 
my $c = 0; 
my $g = 0;
my $t = 0;

while (<>) {

	if ($_=~/^\</) {
	#$my_sequence  = lc($ARGV[0]);
				
	}
	else {
		$my_sequence =lc($_);
	
		$a++ while $my_sequence =~ /a|t/g;

		$c++ while $my_sequence =~ /c|g/g;
		
	#	$g++ while $my_sequence =~ /g/g;

	#	$t++ while $my_sequence =~ /t/g;
	
	}
}
	print "cg%: ".(($c+$g)/($a+$c+$g+$t))."\n";
	#print "".(($c+$g)/($a+$c+$g+$t))."\n";			
	print "total:".($a+$c+$g+$t)."\n";
	#print "at: $a\n";
	#print "c: $c\n";
	#print "g: $g\n";
	#print "t: $t\n";
	
