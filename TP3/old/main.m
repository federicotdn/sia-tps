source('genetic.m');
source('fitness.m');
source('replacement.m');

genetic = init();
generations = 0;
genetic = calculate_fitnesses(genetic);
genetic.individuals.fitnesses
while generations < 1000 
	genetic = first_replacement(genetic);	
	genetic = calculate_fitnesses(genetic);
	generations = generations +1;
endwhile
"after"
genetic.individuals.fitnesses
[best_fitness, index] = max(genetic.individuals.fitnesses);
output = feed_forward(genetic.individuals.weights{index}, genetic.arch, genetic.range);
plot(genetic.range, genetic.expected_outputs, genetic.range, output);
pause();