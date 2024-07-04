#!/usr/bin/perl

use strict;
use warnings;
use Bio::Phylo;
use Bio::Phylo::IO qw(parse unparse);


print "Welcome to Scoutknife Consensus, the Consensus Tree Maker for Scoutknife! 
A few important usage notes before we go on: 
- Scoutknife Consensus creates a consensus tree of the input treelist, but if a taxon is not present in all of the trees in the treelist, it will omit that taxon from the result. Please make sure that all your taxa were represented, using the --auto command in Scoutknife, or the Scoutknife Calculator, also at the Github. 
--- If you would like to retain that taxon, we would recommend using sumtrees.py instead, part of the DendroPy package, which you can find here: https://github.com/jeetsukumaran/DendroPy
- Values on branches are the average of that branch length across all trees in the treelist, while the value at the node is the percentage of times the bipartition is recovered in the treelist.
- Scoutknife Consensus requires the Bio::Phylo perl module to run. You can install that using cpan as follows:
cpan Bio::Phylo
- The input format for Scoutknife Consensus is:
 perl Scoutknife_Consensus.pl <treelist>
"; 

# Check for command line arguments
if (@ARGV != 1) {
    die "Usage: $0 <input_trees_file>\n";
}


# Input file containing multiple Newick trees
my $input_file = $ARGV[0];
open(OUT,'>',"$input_file.consensus");


# Read the input trees using forest
my $forest = parse('-file' => $input_file, '-format' => 'newick');

# make the consensus and print
my $tree = $forest->make_consensus('-branches'=>'average', '-summarize'=>'probability');

print OUT unparse('-phylo'=>$tree, '-format'=>'newick');
