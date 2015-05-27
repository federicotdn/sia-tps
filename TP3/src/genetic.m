source('parser.m');
source('selection.m')

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
	genetic.mixed_n = config.mixed_n;
	genetic.mixed_roul = config.mixed_roul;
	genetic.replacement_selection = config.replacement_selection;
	genetic.replacement_tournament_m = config.replacement_tournament_m;
	genetic.replacement_mixed_n = config.replacement_mixed_n;
	genetic.replacement_mixed_roul = config.replacement_mixed_roul;
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
		% FUNCTION 7
		% expected_outputs(i) = ((sin(range(i))*range(i)**3) + (range(i)/2));

		% FUNCTION 5
		expected_outputs(i) = tanh(0.1 * range(i)) + sin(3 * range(i));
	end

	max_abs_output = max(max(expected_outputs), abs(min(expected_outputs)));
	expected_outputs = expected_outputs/max_abs_output;
	expected_outputs = expected_outputs';
end

function selected = smart_call_select(genetic, k)
	selection_params.k = k;
	selection_params.selection_fn = genetic.selection;
	selection_params.mixed_n = genetic.mixed_n;
	selection_params.mixed_roul = genetic.mixed_roul;
	selection_params.tournament_m = genetic.tournament_m;
	selected = smart_call_select_generic(genetic, selection_params);
end

function selected = smart_call_replacement_select(genetic, k)
	selection_params.k = k;
	selection_params.selection_fn = genetic.replacement_selection;
	selection_params.mixed_n = genetic.replacement_mixed_n;
	selection_params.mixed_roul = genetic.replacement_mixed_roul;
	selection_params.tournament_m = genetic.replacement_tournament_m;
	selected = smart_call_select_generic(genetic, selection_params);
end

% _smart_call_select_generic calls a selection function passing the appropiate parameters
function selected = smart_call_select_generic(genetic, selection_params)
	switch selection_params.selection_fn
		case 'elite'
			selected = elite(genetic.individuals.fitnesses, selection_params.k);
		case 'mixed'
			selected = mixed(genetic.individuals.fitnesses, selection_params.k, selection_params.mixed_n, selection_params.mixed_roul);
		case 'roulette'
			selection = roulette(genetic.individuals.fitnesses, selection_params.k);
		case 'deterministic_tournament'
			selection = deterministic_tournament(genetic.individuals.fitnesses, selection_params.k, selection_params.tournament_m);
		case 'probabilistic_tournament'
			selection = probabilistic_tournament(genetic.individuals.fitnesses, selection_params.k);
		case 'universal'
			selection = universal(genetic.individuals.fitness, selection_params.k);
	end
end