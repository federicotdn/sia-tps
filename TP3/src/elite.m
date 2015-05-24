function selected = elite(fitnesses, k)
	selected = [];
	sorted = sort(fitnesses);
	for i =  (length(fitnesses)-k+1):length(fitnesses)
		selected(end+1) = find(sorted(i) == fitnesses)(1);
	endfor
endfunction
