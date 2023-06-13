use strict;
use warnings;

# Function to calculate the factorial of a number
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
# Main program
print "How many genes in total are in your dataset?\n";
my $population_size = <STDIN>;

print "How many of those contain your least represented taxa?\n";
my $successes_population = <STDIN>;

print "How many Scoutknife samples would you like to take of the data?\n";
my $sample_size = <STDIN>;

print "How many genes containing the least represented taxa would you like to see?\n";
my $successes_sample = <STDIN>;

chomp($population_size, $successes_population, $sample_size, $successes_sample);

my $cumulative_prob = cumulative_probability($population_size, $successes_population, $sample_size, $successes_sample);
print "This is the probability of any given Scoutknife sample containing $successes_sample genes containing the least represented taxa:\t $cumulative_prob\n";
