% Mutation functions for GA

% Classic mutation
% individual: weights array for an individual (example: [0.4 0.3 1])
% mut_p: mutation probability (example: 0.05)
% mut_range: mutation range (example: 0.1 -> will mutate values by +/- 10% at random)
function mut_individual = mutate_classic(individual, mut_p, mut_range)
	mut_chosen = rand(1, length(individual)) < mut_p
	mut_values = (rand(1, length(individual)) * (mut_range * 2)) - mut_range
	mut_coef = mut_chosen .* mut_values
	mut_individual = (individual .* mut_coef) + ((1 - mut_chosen) .* individual)
end

% Non-uniform mutation
function mut_individual = mutate_non_uniform(individual, mut_p, generation)

end