% Mutation functions for GA

% Classic mutation
% individual: weights array for an individual (example: [0.4 0.3 1])
% mut_p: mutation probability (example: 0.05)
% mut_range: mutation range (example: 0.1 -> will mutate values by +/- 10% at random)
function mut_individual = mutate_classic(individual, mut_p, mut_range)
	mut_chosen = rand(1, length(individual)) < mut_p;
	mut_values = 1 + (rand(1, length(individual)) * (mut_range * 2)) - mut_range;
	mut_coef = mut_chosen .* mut_values;
	mut_individual = (individual .* mut_coef) + ((1 - mut_chosen) .* individual);
end

% Non-uniform mutation
% individual: weights array for an individual (example: [0.4 0.3 1])
% gen: generation number
% pop_size: population size
% m_alpha, m_beta: mutation coefficients (example: 10, 0.001)
% mut_range: mutation range (example: 0.1 -> will mutate values by +/- 10% at random)
function mut_individual = mutate_non_uniform(individual, gen, pop_size, m_alpha, m_beta, mut_range)
	mut_p = (m_alpha * exp((-1 * m_beta * gen) / 2)) / (pop_size * sqrt(length(individual)));
	mut_individual = mutate_classic(individual, mut_p, mut_range);
end