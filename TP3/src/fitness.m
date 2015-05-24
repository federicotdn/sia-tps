function fitnesses = calculate_fitnesses(individuals, arch, range, expected_outputs)
	fitnesses = []
	for individual = individuals
		new_individual = individual_array_to_cell_array(individual{1}, arch);
		output = feed_forward(new_individual, range);
		fitnesses(end + 1) = 1/((1/(2*length(range)))*sum((expected_outputs - output).^2));
	end
end

function ans = fitness(individual, arch, range, expected_outputs)
	for i = 1:length(arch) -1
	endfor
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

function output = feed_forward(weights, range)
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