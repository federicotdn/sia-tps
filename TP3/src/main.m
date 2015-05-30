% Genetic Algorithm - Main loop

source('genetic.m');
source('fitness.m'); % debugging

genetic = init();
genetic = calculate_fitnesses(genetic);
g = genetic; % shorter alias

while g.generation < g.max_generations % TODO: change condition

	selected = smart_call_select(genetic, g.selection_k);

	mut_children = {};
	iterations = 1: ceil(g.selection_k / 2);
	for i = iterations
		selected_pair = randperm(length(selected), 2);
		father = genetic.individuals.weights{selected_pair(1)};
		mother = genetic.individuals.weights{selected_pair(2)};
		children = genetic.cross_function(mother, father, g.cross_prob);

		mut_children{end + 1} = smart_call_mutate(genetic, children{1});

		% If selection_k is odd, skip adding the second child on the last iteration
		if i ~= length(iterations) || mod(g.selection_k, 2) == 0
			mut_children{end + 1} = smart_call_mutate(genetic, children{2});
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