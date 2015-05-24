source('parser.m');

function genetic = init()
	[rand_limit, arch, individuals_qty, replacement_method, mutation_prob, range] = parse();
	genetic.arch = arch;
	genetic.individuals = init_individuals(individuals_qty, rand_limit, arch);
	genetic.generation  = 1;
	genetic.replacement_method = replacement_method;
	genetic.mutation_prob = mutation_prob;
	genetic.range = range;
	genetic.expected_outputs = calc_expected_outputs(range);
endfunction

function individuals = init_individuals(individuals_qty, rand_limit, arch)
	individuals = {};
	for i = 1:individuals_qty
		individual = [];
		for j = 1:length(arch) -1
			individual = [individual, (rand(1, (arch(j) + 1)* arch(j+1))* (2*rand_limit)) - rand_limit];
		endfor
		individuals{end + 1} = individual;
	endfor
endfunction

function expected_outputs = calc_expected_outputs(range)
	for i=1:length(range)
		expected_outputs(i)= ((sin(range(i))*range(i)**3) + (range(i)/2));
	endfor
	max_abs_output = max(max(expected_outputs), abs(min(expected_outputs)));
	expected_outputs = expected_outputs/max_abs_output;
	expected_outputs = expected_outputs';
end
