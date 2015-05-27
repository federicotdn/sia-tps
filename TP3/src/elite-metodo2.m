% Genetic Algorithm - Main loop

source('genetic.m');
source('fitness.m');
source('replacement.m');
source('selection.m');
source('mutation.m');
source('crossover.m');

genetic = init();
generations = 0;
genetic = calculate_fitnesses(genetic);

k = 2 * 4; % must be even
N = length(genetic.individuals.fitnesses);

% Elite + Metodo de Reemplazo 2
while generations < 100000
	selected = elite(genetic.individuals.fitnesses, k);

	indices = (1: (k / 2)) * 2;
	mut_children = {};
	new_weights = {};
	for in = indices
		father = genetic.individuals.weights{selected(in - 1)};
		mother = genetic.individuals.weights{selected(in)};
		children = feval(genetic.cross_function, mother, father);

		for i = 1:length(children)
			%new_weights{end + 1} = mutate_non_uniform(children{i}, generations, N, 10000, 0.1, 0.25);
			new_weights{end + 1} = mutate_classic(children{i}, 0.05, 0.25);
		end
	end

	%retained_old_weights = {genetic.individuals.weights{randperm(N, N - k)}}; % random
	retained_old_weights = {genetic.individuals.weights{elite(genetic.individuals.fitnesses, N - k)}}; %reemplazo con elite
	for i = 1:length(retained_old_weights)
		new_weights{end + 1} = retained_old_weights{i};
	end

	genetic.individuals.weights = new_weights;
	genetic = calculate_fitnesses(genetic);

	generations++;

	prom = sum(genetic.individuals.fitnesses) / length(genetic.individuals.fitnesses);
	disp(prom)

	if mod(generations, 50) == 0
		[m, index] = max(genetic.individuals.fitnesses);
		all_best(end + 1) = m;

		best = genetic.individuals.weights{index};
		r = genetic.range;
		results = feed_forward(best, genetic.arch, r);

		subplot (2, 1, 1)
		plot(r, results, r, genetic.expected_outputs);
		subplot (2, 1, 2)
		plot(1:(generations/50), all_best);
		refresh();
	end
end