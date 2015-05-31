function repeated = structure_stop(genetic, old_weights)
	repeated = 0;

	for i = 1:length(old_weights)
		for j = 1:length(old_weights)
			keyboard()
			if prod(old_weights{i} == genetic.individuals.weights{j}) == 1
				repeated++;
				break;
			end
		end
	end
end