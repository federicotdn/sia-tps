function selected = roulette(fitnesses, k)
	selected = [];
	relative_fitnesses = relative_fitness(fitnesses);
	rands = rand(1,k);
	cumulative_sum = cumsum(relative_fitnesses);
	for i = 1:length(relative_fitnesses)
		if i == 1 
			select = roulette_check(rands, 0, cumulative_sum(i));
		else
			select = roulette_check(rands, cumulative_sum(i-1), cumulative_sum(i));
		endif
		if select
			selected(end+1) = i;
		endif
	endfor
endfunction

function ans = roulette_check(rands, bottom, top)
	i = 1;
	ans = false;
	while ans == false && i <= length(rands)
		ans = rands(i) > bottom && rands(i) < top;
		i = i +1;
	endwhile
endfunction

roulette([4,3,6,8,2,4],3)