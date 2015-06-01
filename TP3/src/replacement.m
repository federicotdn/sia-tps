% Replacement methods for GA
source('fitness.m');

function new_weights = method1(genetic, mut_children)
	new_weights = mut_children;
end

function new_weights = method2(genetic, mut_children)
	retained_indices = smart_call_replacement_select(genetic, genetic.population_size - genetic.selection_k);
	new_weights = {genetic.individuals.weights{retained_indices}};
	for i = 1: length(mut_children)
		new_weights{end + 1} = mut_children{i};
	end
end

function new_weights = method3(genetic, mut_children)
	for i = 1: length(mut_children)
		genetic.individuals.weights{end + 1} = mut_children{i};
	end
	genetic = calculate_fitnesses(genetic);
	retained_indices = smart_call_replacement_select(genetic, genetic.population_size);
	new_weights = {genetic.individuals.weights{retained_indices}};
end