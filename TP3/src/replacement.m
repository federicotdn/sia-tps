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
		%aca hay que hacer el selector del cruce
		new_offsprings = genetic.cross(mother,father);
		for i = 1:length(new_offsprings)
			%suponiendo que tenemos el metodo de mutacion en la genetica
			offsprings{end+1} = genetic.mutation(new_offsprings{i});
		endfor
	while length(offsprings) < length(genetic.individuals)
	genetic.individuals = offsprings;
	%aca hay que recaulcular los fitneses y listouuu

endfunction