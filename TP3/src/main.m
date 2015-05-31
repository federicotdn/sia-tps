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
	iterations = (1: ceil(g.selection_k / 2)) .* 2;
	for i = iterations
		father = genetic.individuals.weights{selected_indices(i)};
		mother = genetic.individuals.weights{selected_indices(i - 1)};
		children = genetic.cross_function(mother, father, g.cross_prob);

		mut_children{end + 1} = smart_call_mutate(genetic, children{1});

		% If selection_k is odd, skip adding the second child on the last iteration
		if i ~= length(iterations) || mod(g.selection_k, 2) == 0
			mut_children{end + 1} = smart_call_mutate(genetic, children{2});
		end
	end

	new_weights = genetic.replacement_method(genetic, mut_children);
	old_weights = genetic.individuals.weights;

	genetic.individuals.weights = new_weights;
	genetic = calculate_fitnesses(genetic);

	g.generation++;

	max_fitness = max(genetic.individuals.fitnesses);

	if last_max_fitnesses == max_fitness
		max_fitness_count++;
		max_fitness_count
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

	if mod(g.generation, 50) == 0
		[m, index] = max(genetic.individuals.fitnesses);
		disp(m);
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