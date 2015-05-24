source('genetic.m');
source('fitness.m');
source('replacement.m');

genetic = init();
generations = 0
genetic = calculate_fitnesses(genetic);
genetic.individuals.fitnesses
while generations < 50 
	genetic = first_replacement(genetic);	
	genetic = calculate_fitnesses(genetic);
	generations = generations +1;
endwhile
"after"
genetic.individuals.fitnesses