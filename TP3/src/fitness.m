source('network.m');

function genetic = calculate_fitnesses(genetic)
	genetic.individuals.fitnesses = [];
	for i = 1:length(genetic.individuals.weights)
		[genetic.individuals.fitnesses(end + 1), genetic.individuals.weights{i}, genetic.backpropagated] = fitness(genetic.individuals.weights{i}, genetic, genetic.backpropagated);
	end
end

function [fitness, new_weights, backpropagated] = fitness(individual, genetic, backpropagated)
	% output = feed_forward(individual, genetic.arch, genetic.range);
	genetic.network.weights = individual_array_to_cell_array(individual, genetic.arch);
	backpropagate = rand() < genetic.backpropagation_prob;
	genetic.network = train(genetic.network, false, backpropagate);
	
	fitness =  1/genetic.network.cuadratic_error;
	if backpropagate
		backpropagated++;
		new_weights = weights_cell_array_to_array(genetic.network.weights);
	else
		new_weights = individual;
	end
end

function new_individual = individual_array_to_cell_array(individual, arch)
	new_individual = {};
	pos = 1;
	for i = 1:length(arch) -1
		individual_size = (arch(i) + 1) * arch(i + 1);
		slice = individual(pos: pos + individual_size -1);
		new_individual{i} =  reshape(slice, arch(i) + 1, arch(i + 1));
		pos += individual_size;
	end
end

function new_weights = weights_cell_array_to_array(weights)
	new_weights = [];
	for i = 1:length(weights)
		weight = weights{i};
		flat_size = size(weight)(1) * size(weight)(2);
		new_weights = [new_weights, reshape(weight, 1, flat_size)];
	end
end
