function selected = roulette(fitnesses, k)
	selected = [];
	relative_fitnesses = relative_fitness(fitnesses);
	rands = rand(1,k);
	cumulative_sum = cumsum(relative_fitnesses);
	for i = 1:k
		selected(end+1) = roulette_check(rands(i), cumulative_sum);
	endfor
endfunction

function ans = roulette_check(r, cumulative)
	i = 1;
	ans = false;
	while ans == false && i <= length(cumulative)
		if i == 1
			ans = r > 0 && r < cumulative(i);
		else
			ans = r > cumulative(i-1) && r < cumulative(i);
		endif
		i = i +1;
	endwhile
	ans = i-1;
endfunction

function relative_fitness = relative_fitness(fitnesses)
	relative_fitness = zeros(1,size(fitnesses)(2));
	for i = 1:size(relative_fitness)(2)
		relative_fitness(i) = fitnesses(i)/sum(fitnesses);
	endfor
endfunction

roulette([4,3,6,8,2,4],4)