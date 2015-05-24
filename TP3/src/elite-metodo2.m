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
while generations < 1000
	selected = elite(genetic.individuals.fitnesses, k);

	indices = (1: (k / 2)) * 2;
	mut_children = {};
	new_weights = {};
	for in = indices
		father = genetic.individuals.weights{selected(in - 1)};
		mother = genetic.individuals.weights{selected(in)};
		children = feval(genetic.cross_function, mother, father);

		for i = 1:length(children)
			new_weights{end + 1} = mutate_classic(children{i}, 0.4, 0.25);
		end
	end

	retained_old_weights = {genetic.individuals.weights{randperm(N, N - k)}};
	for i = 1:length(retained_old_weights)
		new_weights{end + 1} = retained_old_weights{i};
	end

	genetic.individuals.weights = new_weights;
	genetic = calculate_fitnesses(genetic);

	prom = sum(genetic.individuals.fitnesses) / length(genetic.individuals.fitnesses);
	disp(prom)

	generations++;
end