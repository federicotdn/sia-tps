% Mutation functions for GA
% individuals is the individuals struct (.fitnesses[], .weights{})

function mut_individuals = mutate_classic(individuals, mut_p)
	mut_individuals.fitnesses = []
	mut_individuals.weights = {}


end

function mut_individuals = mutate_non_uniform(individuals, mut_p, generation)
end