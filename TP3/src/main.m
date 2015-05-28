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

	selected = smart_call_select(genetic, g.selection_k);

	% TODO: Change how parents are crossed/selected from the K selected individuals
	% for now, K must be even
	indices = (1: (g.selection_k / 2)) * 2;
	mut_children = {};
	for in = indices
		father = genetic.individuals.weights{selected(in - 1)};
		mother = genetic.individuals.weights{selected(in)};
		children = feval(genetic.cross_function, mother, father);

		for i = 1:length(children)
			mut_children{end + 1} = smart_call_mutate(genetic, children{i});
		end
	end

	new_weights = genetic.replacement_method(genetic, mut_children);

	genetic.individuals.weights = new_weights;
	genetic = calculate_fitnesses(genetic);

	g.generation++;

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