% Mutation functions for GA

function mut_individual = mutate_classic(individual, mut_p, mut_range)
	mut_chosen = rand(1, length(individual)) < mut_p
	mut_values = (rand(1, length(individual)) * (mut_range * 2)) - mut_range
	mut_coef = mut_chosen .* mut_values
	mut_individual = (individual .* mut_coef) + ((1 - mut_chosen) .* individual)
end

function mut_individual = mutate_non_uniform(individual, mut_p, generation)
end