# Scoutknife
Scoutknife is a naïve, whole genome informed phylogenetic robusticity metric.

Scoutknife takes as input a directory of fasta files. Each of those fasta files should contain one multiple sequence alignment across the studied taxa.

Format a Scoutknife.pl command as follows:

``
perl Scutknife.pl <directory name> <sample alignment size> <Number of iterations>
``

For Example
``
perl Scoutknife.pl . 50 100
``

The first argument value is the target directory. The second is the desired size of the sample alignment in number of fasta files. The third is the number of sampling iterations.
For example, the above command will take each fasta file in the current present directory and generate 100 50 fasta file long alignments.

Alternatively, Scoutknife can be run using the "--auto" command, as follows:

``
perl Scoutknife.pl --auto .
``

Where the second argument is the target directory, as in the primary Scoutknife command. The auto command first opens each input fasta file in the directory and counts how many times each taxon occurs across the fasta files within the directory. It uses this to find the taxon with the highest missing data, and then calculates how many genes should be present in each Scoutknife sample in order to give a 99.9% chance that the taxon with the highest missing data is sampled in all Scoutknife datasets. If this number is below 100 (which would represent low amounts of missing data), then Scoutknife auto defaults to 100.

Please note that, if a gene is not present, but the taxon is represented in the single gene alignment fasta file by missing data markers, rather than absent from the file, then Scoutknife's auto command will count that taxon as present in that gene!

If the least represented taxa is present in less than 10% of the genes in the total dataset, then Scoutknife will present a warning that this dataset is likely not suited for the Scoutknife approach, and then exit. If you still wish to continue, you can use the "--force" command as follows:

``
perl Scoutknife.pl --auto . --force
``

After you have constructed the Scoutknife trees, once they are concatenated into a single treelist, you can then use Scoutknife_Consensus.pl to construct a Consensus tree, as follows:

``
perl Scoutknife_Consensus.pl <treelist>
``

The manuscript for Scoutknife is currently under peer review at F1000 Research. If you are curious about how Scoutknife works and how it performs, please read a bit more about it here:
https://f1000research.com/articles/12-945

Included is also a Taxon Probability Calculator, as mentioned in the manuscript. This file (Scoutknife_TaxonProbCalculator.pl) might be useful to understand how to sample your data, and can be used in place of the Auto command of Scoutknife if you would like to explore how sampling changes probabilities in your dataset.
It takes as input a series of standard input questions: How many genes are in your dataset, how many of those genes contain the least represented taxa, how large you would like your Scoutknife sample to be and how many genes would you like to represent the least represented taxa in each sample.
It outputs the probability of that being the case. By increasing the number of sampled genes in the Scoutknife sample, you can increase the real number of genes representing your least represented taxa that appear in the average Scoutknife sample. However, it is worth noting that this will not increase the proportional representation of the least represented taxa in the sample. 


Scoutknife requires catsequences as a pre-requisite. Catsequences can be found and installed here:
https://github.com/ChrisCreevey/catsequences
