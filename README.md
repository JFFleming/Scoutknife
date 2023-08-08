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

