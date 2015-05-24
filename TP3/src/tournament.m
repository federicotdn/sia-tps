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

tournament([5,4,2,6,3,1,4],4,3)