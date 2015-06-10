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
	mut_children = {};
	if genetic.replacement_method == @method1
		while length(mut_children) < genetic.population_size
			selected = smart_call_select(genetic, 2);
			father = genetic.individuals.weights{selected(1)};
			mother = genetic.individuals.weights{selected(2)};

			if (rand() < genetic.cross_prob)
				children = genetic.cross_function(mother, father);
			else
				children = {mother, father};
			end

			mut_children{end + 1} = smart_call_mutate(genetic, children{1});
			if length(mut_children) < genetic.population_size
				mut_children{end + 1} = smart_call_mutate(genetic, children{2});
			end
		end
	else
		selected = smart_call_select(genetic, genetic.selection_k);

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
	end

	new_weights = genetic.replacement_method(genetic, mut_children);

	genetic.individuals.weights = new_weights;
	genetic = calculate_fitnesses(genetic);

	mean_fitnesses(genetic.generation) = mean(genetic.individuals.fitnesses);

	genetic.generation++;

	max_fitness = max(genetic.individuals.fitnesses);

	if abs(last_max_fitnesses - max_fitness) < 0.000001
		max_fitness_count++;
	else
		max_fitness_count = 0;
		last_max_fitnesses = max_fitness;
	end

  running = (genetic.generation < genetic.max_generations) ...
    		  && (max(genetic.individuals.fitnesses) < genetic.max_fitness) ...
			  && (max_fitness_count < genetic.max_fitness_generations) ...
			  && (length(mean_fitnesses) == 1 || abs(mean_fitnesses(genetic.generation -1) - mean_fitnesses(genetic.generation -2)) > genetic.delta_structure);

	% =============================
	% ======= DEBUG SECTION =======
	% =============================

	[m, index] = max(genetic.individuals.fitnesses);
	all_best(end + 1) = m;

	if mod(genetic.generation - 1, 100) == 0
		printf('Mejor fitness: %f, generacion: %d\n', m, genetic.generation - 1);

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
		plot(1:genetic.generation-1, all_best, 1:genetic.generation-1, mean_fitnesses);
		legend('Max', 'Promedio', 'location', 'eastoutside');
		title('Evolucion del fitness');
		xlabel('Generaciones');
    ylabel('Fitness');
		refresh();
	end

	% =============================
	% ===== END DEBUG SECTION =====
	% =============================

end

cut = '';
if genetic.generation >= genetic.max_generations
	cut = 'Maxima cantidad de generaciones';
elseif max(genetic.individuals.fitnesses) >= genetic.max_fitness
	cut = 'Maximo fitness superado';
elseif max_fitness_count >= genetic.max_fitness_generations
	cut = 'Maximo fitness no progreso';
else
	cut = 'Estructura';
end

printf('\nCriterio de corte: %s\n', cut);

printf('Mejor fitness: %f, generacion: %d\n', m, genetic.generation);
printf('Mejores pesos: \n');
disp(genetic.individuals.weights{index});

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
plot(1:genetic.generation-1, all_best, 1:genetic.generation-1, mean_fitnesses);
legend('Max', 'Promedio', 'location', 'eastoutside');
title('Evolucion del fitness maximo');
xlabel('Generaciones');
ylabel('Fitness');
refresh();
pause();