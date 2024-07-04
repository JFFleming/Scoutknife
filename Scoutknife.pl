use strict;
use warnings;
use List::Util qw/shuffle/;

my $dir;
my $sample_size;
my $iteration;
my $file_count;
my @fasta_list;

# Function to calculate the binomial coefficient
sub binomial_coefficient {
    my ($n, $k) = @_;
    
    my $result = 1;
    
    for (my $i = 1; $i <= $k; $i++) {
        $result *= ($n - $i + 1) / $i;
    }
    
    return $result;
}

# Function to calculate the hypergeometric probability
sub hypergeometric_probability {
    my ($population_size, $successes_population, $sample_size, $successes_sample) = @_;
    
    my $numerator = binomial_coefficient($successes_population, $successes_sample) * binomial_coefficient($population_size - $successes_population, $sample_size - $successes_sample);
    my $denominator = binomial_coefficient($population_size, $sample_size);
    
    return $numerator / $denominator;
}

# Function to calculate the cumulative probability
sub cumulative_probability {
    my ($population_size, $successes_population, $sample_size, $successes_sample) = @_;

    my $cumulative_prob = 0;
    my $min_successes = $successes_sample < $successes_population ? $successes_sample : $successes_population;

    for my $i ($min_successes..$sample_size) {
        $cumulative_prob += hypergeometric_probability($population_size, $successes_population, $sample_size, $i);
    }

    return $cumulative_prob;
}


if ($ARGV[0] =~ "--auto"){
	$iteration = 100;
	chomp( $dir = $ARGV[1] ); # . here is the input for the current directory
	opendir (DIR, $dir)|| die ("Can not open $dir");
	#!/usr/bin/perl
	@fasta_list = grep { /\.fas/i && !/^\./ } readdir(DIR);
	closedir(DIR);

	# Initialize variables
	$file_count = @fasta_list;
	my %taxa_count;

	# Loop through each file
	foreach my $file (@fasta_list) {
	    open(my $fh, '<', "$dir/$file") or die "Can't open $file: $!";

	    # Read each line of the file
	    while (my $line = <$fh>) {
	        chomp $line;
        
	        # Check for header line
	        if ($line =~ /^>/) {
	            # Extract taxa information
	            my ($taxa) = $line =~ />(\S+)/;
	            $taxa_count{$taxa}++;
	        }
	    }
	
	    close($fh);
	}

	# Find the minimum count
	my $min_count = (sort { $a <=> $b } values %taxa_count)[0];

	# Find all taxa with the minimum count
	my @min_taxa = grep { $taxa_count{$_} == $min_count } keys %taxa_count;

	#foreach my $bigtaxa (keys %taxa_count){
	#	print "$bigtaxa $taxa_count{$bigtaxa}\n";}

	# Output results
	print "Number of FASTA files in directory: $file_count\n";
	print "Taxa occurring the lowest number of times:\n";
	foreach my $taxa (@min_taxa) {
	    print "$taxa: $min_count times\n";
	}
	#Check to assess whether the dataset is appropriate for Scoutknife
	if ($file_count/$min_count <= 0.1){
		if ($ARGV[2] =~ "--force"){
		print("While the least represented taxa, is less than 10% of the total dataset, the --force command was called. Proceeding, using number of successes = 1. Be aware this may give unreliable results.");
		}
		else{
		die("The least represented taxa, is less than 10% of the total dataset. This dataset might give unreliable results with the Scoutknife approach, which requires higher occupancy. Try removing that problematic taxa - if that isn't possible, use the --force option,
		-- force has the following Syntax:
		Scoutknife.pl --auto <directory name> --force");
		}
	}
	# Main program
	my $population_size = $file_count;
	print "Total number of genes in the dataset: $population_size\n";

	my $successes_population = $min_count;
	print "Total number of genes in the population containing the least represented taxa: $successes_population\n";

	my $successes_sample = $file_count*0.1;
	print "Enter number of genes containing the least represented taxa you'd like to see: $successes_sample\n";

	my $cumulative_prob = 0.999;
	print "Enter the target cumulative probability: $cumulative_prob\n";

	chomp($population_size, $successes_population, $successes_sample, $cumulative_prob);

	# Calculate sample size
	$sample_size = 1;

	while (cumulative_probability($population_size, $successes_population, $sample_size, $successes_sample) < $cumulative_prob && $sample_size <= $population_size) {
	    $sample_size++;
	}

	print "The required sample size to achieve a cumulative probability of $cumulative_prob is: $sample_size\n";

	if ($sample_size < 100){
	$sample_size = 100;
	print "As the --auto option has been selected and the recommended minimum sample size is below 100, Scoutknife has defaulted to $iteration samples containing $sample_size genes.\n";
	}
}

else{
chomp( $dir = $ARGV[0] ); # . here is the input for the current directory
$sample_size = $ARGV[1]; #Looptime is alignment size
$iteration = $ARGV[2]; #Iteration is how many times
opendir (DIR, $dir)|| die ("Can not open $dir");
my @list_of_files = readdir(DIR);
@fasta_list = grep(/fas/, @list_of_files);
$file_count = @fasta_list;
}

#print "$sample_size \t $iteration \t $file_count\n";
#print "@fasta_list";

system "mkdir $dir/JackKnifeLists/";
my $number=1;
while ($number <= $iteration) {
	my $outfile = "$dir/Jack_knifelist.$number.txt";
	open (OUT, '>', $outfile) || die ("Can not open $outfile\n");
	for ((shuffle(0..$file_count-1))[1..$sample_size]) {
    	print OUT "$dir/$fasta_list[$_] \n";
	}
	system "catsequences $dir/Jack_knifelist.$number.txt";
	system "mkdir $dir/ScoutKnife_$number";
	system "mv allseqs.fas $dir/ScoutKnife_$number/$number.allseqs.fas";
	system "mv allseqs.partitions.txt $dir/ScoutKnife_$number/$number.allseqs.partitions.txt";	
	$number++;
}

system "mv $dir/Jack_knifelist.* $dir/JackKnifeLists/";
