source("roulette.m")
function selected = universal(fitnesses, k)
	selected = [];
	r = rand;
	relative_fitnesses = relative_fitness(fitnesses);
	cumulative_sum = cumsum(relative_fitnesses);
	for i = 1:k
		selected(end+1) = roulette_check(((r + i -1)/k), cumulative_sum);
	endfor
endfunction