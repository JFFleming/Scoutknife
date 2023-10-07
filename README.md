# Scoutknife
Scoutknife is a naïve, whole genome informed phylogenetic robusticity metric.

Scoutknife takes as input a directory of fasta files. Each of those fasta files should contain one multiple sequence alignment across the studied taxa.

Format a Scoutknife.pl command as follows:


``
perl Scoutknife.pl . 50 100
``

The first argument value is the target directory. The second is the desired size of the sample alignment in number of fasta files. The third is the number of sampling iterations.
For example, the above command will take each fasta file in the current present directory and generate 100 50 fasta file long alignments.


The manuscript for Scoutknife is currently under peer review at F1000 Research. If you are curious about how Scoutknife works and how it performs, please read a bit more about it here:

https://f1000research.com/articles/12-945


Included is also a Taxon Probability Calculator, as mentioned in the manuscript. This file (Scoutknife_TaxonProbCalculator.pl) might be useful to understand how to sample your data.
It takes as input a series of standard input questions: How many genes are in your dataset, how many of those genes contain the least represented taxa, how large you would like your Scoutknife sample to be and how many genes would you like to represent the least represented taxa in each sample.
It outputs the probability of that being the case. By increasing the number of sampled genes in the Scoutknife sample, you can increase the real number of genes representing your least represented taxa that appear in the average Scoutknife sample. However, it is worth noting that this will not increase the proportional representation of the least represented taxa in the sample. 


Scoutknife requires catsequences as a pre-requisite. Catsequences can be found and installed here:
https://github.com/ChrisCreevey/catsequences
