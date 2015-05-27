% Genetic Algorithm - Main loop

source('genetic.m');
source('fitness.m');
source('replacement.m');
source('selection.m');
source('mutation.m');
source('crossover.m');

genetic = init();
genetic = calculate_fitnesses(genetic);
g = genetic; % shorter alias

while g.generation < g.max_generations % TODO: change condition

	% TODO: Use the selection function specified on config file
	selected = elite(genetic.individuals.fitnesses, g.selection_k);

	% TODO: Change how parents are crossed/selected from the K selected individuals
	indices = (1: (g.selection_k / 2)) * 2;
	mut_children = {};
	new_weights = {};
	for in = indices
		father = genetic.individuals.weights{selected(in - 1)};
		mother = genetic.individuals.weights{selected(in)};
		children = feval(genetic.cross_function, mother, father);

		for i = 1:length(children)
			% TODO: Use the mutation function specified on config file
			% new_weights{end + 1} = mutate_non_uniform(children{i}, g.generation, N, 10000, 0.1, 0.25);
			new_weights{end + 1} = mutate_classic(children{i}, 0.1, 0.25);
		end
	end

	% TODO: Use the replacement function specified on config file
	% retained_old_weights = {genetic.individuals.weights{randperm(N, N - k)}}; % random
	retained_old_weights = {genetic.individuals.weights{elite(genetic.individuals.fitnesses, g.population_size - g.selection_k)}}; %reemplazo con elite
	for i = 1:length(retained_old_weights)
		new_weights{end + 1} = retained_old_weights{i};
	end

	genetic.individuals.weights = new_weights;
	genetic = calculate_fitnesses(genetic);

	g.generation++;

	% =============================
	% ======= DEBUG SECTION =======
	% =============================

	prom = sum(genetic.individuals.fitnesses) / length(genetic.individuals.fitnesses);
	disp(prom)

	if mod(g.generation, 50) == 0
		[m, index] = max(genetic.individuals.fitnesses);
		all_best(end + 1) = m;

		best = genetic.individuals.weights{index};
		r = genetic.range;
		results = feed_forward(best, genetic.arch, r);

		subplot (2, 1, 1)
		plot(r, results, r, genetic.expected_outputs);
		subplot (2, 1, 2)
		plot(1:(g.generation/50), all_best);
		refresh();
	end

	% =============================
	% ===== END DEBUG SECTION =====
	% =============================
end