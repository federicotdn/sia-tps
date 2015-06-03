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
 	else
 	 	selected = [selected, universal(fitnesses,(k-n))];
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
	found = false;
	while found == false && i <= length(cumulative)
		if i == 1
			found = r > 0 && r < cumulative(i);
		else
			found = r > cumulative(i-1) && r <= cumulative(i);
		endif
		i++;
	endwhile
	ans = i-1;
endfunction

function relative_fitnesses = relative_fitness(fitnesses)
	sum_fitness = sum(fitnesses);
	relative_fitnesses = fitnesses/sum_fitness;
end

function selected = boltzman(fitnesses, k, temprature)
	selected = [];
	relative_boltzman = relative_boltzman(fitnesses, temprature);
	cumulative_boltzman = cumsum(relative_boltzman);
	cumulative_boltzman /= max(cumulative_boltzman);
	rands = rand(1,k);
	for i = 1:k
		selected(end+1) = roulette_check(rands(i), cumulative_boltzman);
	endfor
end

function relative_boltzman = relative_boltzman(fitnesses, temprature)
	relative_boltzman = exp(fitnesses/temprature);
	relative_boltzman = relative_boltzman/mean(relative_boltzman);
endfunction


function selected = tournament(fitnesses, k, m, probabilistic)
	selected = [];
	contenders = [];
	for i = 1:k
		contender_indexes = randi(length(fitnesses), 1, m);
		contenders = fitnesses(contender_indexes);
		if (probabilistic && rand < 0.75) || !probabilistic
			selected(end + 1) = find(max(contenders) == fitnesses)(1);
		else
			selected(end+1) = find(min(contenders) == fitnesses)(1);
		end
	end
end

function selected = universal(fitnesses, k)
	selected = [];
	r = rand;
	relative_fitnesses = relative_fitness(fitnesses);
	cumulative_sum = cumsum(relative_fitnesses);
	for i = 1:k
		selected(end+1) = roulette_check(((r + i -1)/k), cumulative_sum);
	endfor
endfunction