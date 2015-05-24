function selected = elite(fitnesses, k)
	selected = [];
	sorted = sort(fitnesses);
	for i =  (length(fitnesses)-k+1):length(fitnesses)
		selected(end+1) = find(sorted(i) == fitnesses)(1);
	endfor
endfunction

function selected = mixed(fitnesses, k, n, roul)
	selected = [];
	selected = elite(fitnesses, n);
	if roul
		selected = [selected, roulette(fitnesses,(k-n))];
 	 	elected = [selected, universal(fitnesses,(k-n))]; 
	endif
endfunction

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

function selected = tournament(fitnesses, k, m)
	selected = [];
	contenders = [];
	contender_index = [];
	for i = 1:k
		contender_index = ceil(rand(1,m)*length(fitnesses));
		for i = 1:m
			contenders(i) = fitnesses(contender_index(i));
		endfor
		selected(end+1) = find(max(contenders) == fitnesses)(1)
	endfor
endfunction

function selected = universal(fitnesses, k)
	selected = [];
	r = rand;
	relative_fitnesses = relative_fitness(fitnesses);
	cumulative_sum = cumsum(relative_fitnesses);
	for i = 1:k
		selected(end+1) = roulette_check(((r + i -1)/k), cumulative_sum);
	endfor
endfunction