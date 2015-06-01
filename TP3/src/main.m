% Genetic Algorithm - Main loop

source('genetic.m');
source('stop_conditions.m');
source('fitness.m'); % debugging

genetic = init();
genetic = calculate_fitnesses(genetic);
last_max_fitnesses = 0;
max_fitness_count = 0;
old_weights = {};
running = true;

while running
	selected = smart_call_select(genetic, genetic.selection_k);

	mut_children = {};
	selected_indices = randperm(length(selected));
	iterations = (1: floor(genetic.selection_k / 2)) .* 2;
	for i = iterations
		father = genetic.individuals.weights{selected_indices(i)};
		mother = genetic.individuals.weights{selected_indices(i - 1)};

		if (rand() < genetic.cross_prob)
			children = genetic.cross_function(mother, father);
		else
			children = {mother, father};
		end

		mut_children{end + 1} = smart_call_mutate(genetic, children{1});
		mut_children{end + 1} = smart_call_mutate(genetic, children{2});
	end

	if mod(genetic.selection_k, 2) == 1
		selected_indices = randperm(length(selected), 2);
		father = genetic.individuals.weights{selected_indices(1)};
		mother = genetic.individuals.weights{selected_indices(2)};

		mut_children{end + 1} = smart_call_mutate(genetic, genetic.cross_function(mother, father, genetic.cross_prob){1});
	end

	new_weights = genetic.replacement_method(genetic, mut_children);
	old_weights = genetic.individuals.weights;

	genetic.individuals.weights = new_weights;
	genetic = calculate_fitnesses(genetic);

	genetic.generation++;

	max_fitness = max(genetic.individuals.fitnesses);

	if last_max_fitnesses == max_fitness
		max_fitness_count++;
	else
		max_fitness_count = 0;
		last_max_fitnesses = max_fitness;
	end

  running = (genetic.generation < genetic.max_generations) ...
    		  && (max(genetic.individuals.fitnesses) < genetic.max_fitness) ...
			  && (max_fitness_count < genetic.max_fitness_generations) ...
			  && (structure_stop(genetic, old_weights) < genetic.repeated_weights);


	% =============================
	% ======= DEBUG SECTION =======
	% =============================

	[m, index] = max(genetic.individuals.fitnesses);
	all_best(end + 1) = m;

	if mod(genetic.generation, 50) == 0
		printf('Best fitness: %f, generation: %d\n', m, genetic.generation);

		best = genetic.individuals.weights{index};
		r = genetic.range;
		results = feed_forward(best, genetic.arch, r, genetic.beta_fn);

		subplot (2, 1, 1)
		plot(r, results, r, genetic.expected_outputs);
		legend('Funcion', 'Aprox', 'location', 'eastoutside');
		title('Funcion 5');
		xlabel('x');
    ylabel('f(x)');
		subplot (2, 1, 2)
		plot(1:genetic.generation-1, all_best);
		title('Evolucion del fitness maximo');
		xlabel('Generaciones');
    ylabel('Fitness');
		refresh();
	end

	% =============================
	% ===== END DEBUG SECTION =====
	% =============================
end