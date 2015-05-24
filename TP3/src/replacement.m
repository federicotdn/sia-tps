function population = first_replacement(genetic)
	offsprings = {};
	do
		if genetic.select == 'elite'
			selected = elite(genetic.individuals.fitnesses,2);
		elseif genetic.select == 'roulette'
			selected = roulette(genetic.individuals.fitnesses,2);
		elseif genetic.select == 'tournament_deterministic'
			selected = elite(genetic.individuals.fitnesses,2,genetic.tournament_contenders);
		elseif genetic.select == 'mixed'
			selected = elite(genetic.individuals.fitnesses,2, genetic.mixed_elite, genetic.mixec_reoulette);
		endif
		mother = genetic.individuals{selected(1)};
		father = genetic.individuals{selected(2)};
		new_offsprings = genetic.cross(mother,father);
		for i = 1:length(new_offsprings)
			offsprings{end+1} = genetic.mutation(new_offsprings{i});
		endfor
	while length(offsprings) < length(genetic.individuals)

endfunction