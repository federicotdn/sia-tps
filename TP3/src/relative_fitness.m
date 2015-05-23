function relative_fitness = relative_fitness(fitnesses)
	relative_fitness = zeros(1,size(fitnesses)(2));
	for i = 1:size(relative_fitness)(2)
		relative_fitness(i) = fitnesses(i)/sum(fitnesses);
	endfor
endfunction