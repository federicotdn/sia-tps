source('parser.m');

function genetic = init()
	[rand_limit, arch, individuals_qty, replacement_method, mutation_prob] = parse();
	genetic.arch = arch;
	genetic.individuals = init_individuals(individuals_qty, rand_limit, arch);
	genetic.generation  = 1;
	genetic.replacement_method = replacement_method;
	genetic.mutation_prob = mutation_prob;
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

init();