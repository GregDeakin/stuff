#!/usr/bin/perl
use warnings;
use strict;
#use Bio::SeqIO;
use Bio::DB::GenBank;


my $db = Bio::DB::GenBank->new() or die "BIOPERL ERROR";

#my $seq = $db->get_Seq_by_gi($ARGV[0])->species->node_name; 
my $seq = $db->get_Seq_by_gi($ARGV[0])->desc or die "BIOPERL ERROR"; 

#my $species_string = $seq->species->node_name;
print "$ARGV[0]\t$seq\n";