use strict;
use warnings;
use List::Util qw/shuffle/;

chomp( my $dir = $ARGV[0] ); # . here is the input for the current directory
my $looptime = $ARGV[1]; #Looptime is alignment size
my $iteration = $ARGV[2]; #Iteration is how many times
opendir (DIR, $dir)|| die ("Can not open $dir");
my @list_of_files = readdir(DIR); #this can go use a simple file glob my @glob_files = <$basename*>; 

my $dir_length = @list_of_files;

my @fasta_list = grep(/fas/, @list_of_files);

$dir_length = @fasta_list;

system "mkdir $dir/JackKnifeLists/";
my $number=1;
while ($number <= $iteration) {
	my $outfile = "$dir/Jack_knifelist.$number.txt";
	open (OUT, '>', $outfile) || die ("Can not open $outfile\n");
	for ((shuffle(0..$dir_length-1))[1..$looptime]) {
    	print OUT "$fasta_list[$_] \n";
	}
	system "/home/jamesfl/catsequences/catsequences $dir/Jack_knifelist.$number.txt";
	system "mkdir $dir/ScoutKnife_$number";
	system "mv allseqs.fas $dir/ScoutKnife_$number/$number.allseqs.fas";
	system "mv allseqs.partitions.txt $dir/ScoutKnife_$number/$number.allseqs.partitions.txt";	
	$number++;
}
system "mv $dir/Jack_knifelist.* $dir/JackKnifeLists/";
