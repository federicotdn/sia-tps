source('genetic.m');
source('fitness.m');

genetic = init();
calculate_fitnesses(genetic.individuals, genetic.arch, genetic.range, genetic.expected_outputs)