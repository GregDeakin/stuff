#! /usr/bin/perl -w
use File::Spec;

my %hash;
my $header = "";

opendir (DIR, $ARGV[0]) or die "$!";
my @files = grep {/_translated_/} readdir DIR;
close DIR;
foreach my $file (@files) {
	$abs_path = File::Spec->rel2abs($file, $ARGV[0] );
	
	open(FH,"$ARGV[0]/$file") or die "$!";
	while (<FH>){ 
	#each file will be read line by line here
		chomp;
		if (/^[>]/) {
			$header = $_;
			my $len = int(substr($header,rindex($header,"_")+1)/3);
			if (!exists $hash{$header}) {
				$hash{$header} =[$_,0,$len];
			}
		} elsif (//) {}
		else {
			my @split = split /\*/;
			my $maxlen = 0;
			foreach (@split) {
				if (length($_) > $maxlen) {
					$maxlen = length($_);
				}
			}
			if ($maxlen > $hash{$header}[1]) { 
				$hash{$header}[0] = $_;
				$hash{$header}[1] = $maxlen;
			}
		}
	}
	close(FH);
}

foreach $k (keys %hash) {
	$loc = substr($abs_path,0,rindex($abs_path,"/"));
	$fkey = $k;
	$fkey =~ s/>/>$loc\//;

	if ((@{$hash{$k}}[1]/@{$hash{$k}}[2]) > 0.25) {
		print "$fkey\n";
		print @{$hash{$k}}[0];
			print "\n";
	}
}

sub write_file {
#writes the string fromatted data to the file specified from the command line
	my $outFile = "$ARGV[0]_translated_F1.fa";
	print $outFile;
	unless(open(OUTFILE,">$outFile")) {
		Instructions ("Cannot open output file \"$outFile\" for writing\n\n");
		exit;
	}
	print OUTFILE @_;
	close OUTFILE;
}

