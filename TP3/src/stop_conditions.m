function repeated = structure_stop(genetic, old_weights)
	repeated = 0;

	for i = 1: genetic.population_size
		for j = 1: genetic.population_size
			deltas = abs(1 - abs(genetic.individuals.weights{j} ./ old_weights{i})) < genetic.delta_for_repeated;
			if deltas
				repeated++;
				break;
			end
		end
	end
end