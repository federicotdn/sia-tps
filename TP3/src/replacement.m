source("selection.m");
source("mutation.m");
source("crossover.m");

function genetic = first_replacement(genetic)
	offsprings = {};
	while length(offsprings) < length(genetic.individuals.weights)
		switch genetic.selection
			case 'elite'
				selected = elite(genetic.individuals.fitnesses,2);
			case 'roulette'
				selected = roulette(genetic.individuals.fitnesses,2);
			case 'tournament_deterministic'
				selected = elite(genetic.individuals.fitnesses,2,genetic.tournament_contenders);
			case 'mixed'
				selected = elite(genetic.individuals.fitnesses,2, genetic.mixed_elite, genetic.mixed_reoulette);
		endswitch
		mother = genetic.individuals.weights{selected(1)};
		father = genetic.individuals.weights{selected(2)};
		new_offsprings = feval(genetic.cross_function,mother,father);
		for i = 1:length(new_offsprings)
			offsprings{end + 1} = mutate_classic(new_offsprings{i},0.05,0.1);
		endfor
	endwhile
	genetic.individuals.weights = offsprings;
endfunction