function genetic = calculate_fitnesses(genetic)
	genetic.individuals.fitnesses = [];
	for weight = genetic.individuals.weights
		genetic.individuals.fitnesses(end + 1) = fitness(weight{1}, genetic);
	end
end

function fitness = fitness(individual, genetic)
	output = feed_forward(individual, genetic.arch, genetic.range);
	fitness =  1/((1/(length(genetic.range)))*sum((genetic.expected_outputs - output).^2));
endfunction

function new_individual = individual_array_to_cell_array(individual, arch)
	new_individual = {};
	pos = 1;
	for i = 1:length(arch) -1
		individual_size = (arch(i) + 1) * arch(i + 1);
		slice = individual(pos: pos + individual_size -1);
		new_individual{i} =  reshape(slice, arch(i) + 1, arch(i + 1));
		pos += individual_size;
	endfor
endfunction

function output = feed_forward(individual, arch, range)
	weights = individual_array_to_cell_array(individual, arch);
	inputs{1} = [(ones(size(range',1),1)*-1) range'];
	outputs= {};
	for i = 1:length(weights)
		outputs{i} = tanh(inputs{i}*weights{i});
		if (i < length(weights))
			inputs{i + 1} = [(ones(size(outputs{i},1),1)*-1) outputs{i}];
		endif
	endfor

	inputs{end + 1} = outputs{end};
	outputs{end + 1} = tanh(inputs{end});
	output = outputs{end};

end