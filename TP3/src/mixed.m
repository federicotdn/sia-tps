source("elite.m")
source("roulette.m")
source("universal.m")

function selected = mixed(fitnesses, k, n, rou)
	selected = [];
	selected = elite(fitnesses, n);
	if rou
		selected = [selected, roulette(fitnesses,(k-n))];
	else
	 	elected = [selected, universal(fitnesses,(k-n))]; 
	endif
endfunction