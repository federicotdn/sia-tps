source('parser.m');

function genetic = init()
	[rand_limit, arch, individuals_qty, replacement_method, mutation_prob, range, selection, selection_k, tournament_m ,replacement_selection, replacement_tournament_m, cross_function] = parse();
	genetic.arch = arch;
	individuals.weights = init_weights(individuals_qty, rand_limit, arch);
	individuals.fitnesses = [];
	genetic.individuals = individuals;
	genetic.generation  = 1;
	genetic.replacement_method = replacement_method;
	genetic.mutation_prob = mutation_prob;
	genetic.range = range;
	genetic.expected_outputs = calc_expected_outputs(range);
	genetic.selection = selection;
	genetic.selection_k = selection_k;
	genetic.tournament_m = tournament_m;
	genetic.replacement_selection = replacement_selection;
	genetic.replacement_tournament_m = replacement_tournament_m;
	genetic.cross_function = cross_function;
endfunction

function weights = init_weights(individuals_qty, rand_limit, arch)
	weights = {};
	for i = 1:individuals_qty
		weight = [];
		for j = 1:length(arch) -1
			weight = [weight, (rand(1, (arch(j) + 1)* arch(j+1))* (2*rand_limit)) - rand_limit];
		endfor
		weights{end + 1} = weight;
	endfor
endfunction

function expected_outputs = calc_expected_outputs(range)
	for i=1:length(range)
		expected_outputs(i)= ((sin(range(i))*range(i)**3) + (range(i)/2));
		% expected_outputs(i) = range(i)^3 - 2*range(i)^6 + sin(5*range(i));
		% expected_outputs(i) = (range(i) + 2 * range(i)^2 + 3*range(i)^3);
	endfor
	max_abs_output = max(max(expected_outputs), abs(min(expected_outputs)));
	expected_outputs = expected_outputs/max_abs_output;
	expected_outputs = expected_outputs';
end
