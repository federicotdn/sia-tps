source('parser.m');

function genetic = init()
	config = parse_config();
	genetic.arch = config.arch;
	individuals.weights = init_weights(config.population_size, config.rand_limit, config.arch);
	individuals.fitnesses = [];
	genetic.individuals = individuals;
	genetic.population_size = config.population_size;
	genetic.generation = 1;
	genetic.replacement_method = config.replacement_method;
	genetic.mutation_prob = config.mutation_prob;
	genetic.mutation_range = config.mutation_range;
	genetic.range = config.range;
	genetic.max_generations = config.max_generations;
	genetic.expected_outputs = calc_expected_outputs(config.range);
	genetic.selection = config.selection;
	genetic.selection_k = config.selection_k;
	genetic.tournament_m = config.tournament_m;
	genetic.replacement_selection = config.replacement_selection;
	genetic.replacement_tournament_m = config.replacement_tournament_m;
	genetic.cross_function = config.cross_function;
end

function weights = init_weights(population_size, rand_limit, arch)
	weights = {};
	for i = 1:population_size
		weight = [];
		for j = 1:length(arch) -1
			weight = [weight, (rand(1, (arch(j) + 1)* arch(j+1))* (2*rand_limit)) - rand_limit];
		end

		weights{end + 1} = weight;
	end
end

function expected_outputs = calc_expected_outputs(range)
	for i=1:length(range)
		expected_outputs(i)= ((sin(range(i))*range(i)**3) + (range(i)/2));
	end

	max_abs_output = max(max(expected_outputs), abs(min(expected_outputs)));
	expected_outputs = expected_outputs/max_abs_output;
	expected_outputs = expected_outputs';
end

% smart_select calls selection_fn passing the appropiate parameters
function selected = smart_select(selection_fn)
	switch selection_fn
end