% Genetic Algorithm - Main loop

source('genetic.m');
source('stop_conditions.m');
source('fitness.m'); % debugging

genetic = init();
genetic = calculate_fitnesses(genetic);
g = genetic; % shorter alias
last_max_fitnesses = 0;
max_fitness_count = 0;
old_weights = {};
running = true;

while running
	selected = smart_call_select(genetic, g.selection_k);

	mut_children = {};
	selected_indices = randperm(length(selected));
	iterations = (1: floor(g.selection_k / 2)) .* 2;
	for i = iterations
		father = genetic.individuals.weights{selected_indices(i)};
		mother = genetic.individuals.weights{selected_indices(i - 1)};

		if (rand() < g.cross_prob)
			children = genetic.cross_function(mother, father);
		else
			children = {mother, father};
		end

		mut_children{end + 1} = smart_call_mutate(genetic, children{1});
		mut_children{end + 1} = smart_call_mutate(genetic, children{2});
	end

	if mod(g.selection_k, 2) == 1
		selected_indices = randperm(length(selected), 2);
		father = genetic.individuals.weights{selected_indices(1)};
		mother = genetic.individuals.weights{selected_indices(2)};

		mut_children{end + 1} = smart_call_mutate(genetic, genetic.cross_function(mother, father, g.cross_prob){1});
	end

	new_weights = genetic.replacement_method(genetic, mut_children);
	old_weights = genetic.individuals.weights;

	genetic.individuals.weights = new_weights;
	genetic = calculate_fitnesses(genetic);

	g.generation++;

	max_fitness = max(genetic.individuals.fitnesses);

	if last_max_fitnesses == max_fitness
		max_fitness_count++;
	else
		max_fitness_count = 0;
		last_max_fitnesses = max_fitness;
	end

    running = (g.generation < g.max_generations) && (max(g.individuals.fitnesses) < g.max_fitness) ...
												 && (max_fitness_count < g.max_fitness_generations) ...
												 && (structure_stop(g, old_weights) < g.repeated_weights);


	% =============================
	% ======= DEBUG SECTION =======
	% =============================

	[m, index] = max(genetic.individuals.fitnesses);
	all_best(end + 1) = m;

	if mod(g.generation, 50) == 0
		printf('Best fitness: %f, generation: %d\n', m, g.generation);

		best = genetic.individuals.weights{index};
		r = genetic.range;
		results = feed_forward(best, genetic.arch, r);

		subplot (2, 1, 1)
		plot(r, results, r, genetic.expected_outputs);
		subplot (2, 1, 2)
		plot(1:g.generation-1, all_best);
		refresh();
	end

	% =============================
	% ===== END DEBUG SECTION =====
	% =============================
end