function offsprings = one_point_cross(mother, father, k)
	son = [mother(1:(k-1)),father(k:end)];
	doughter = [father(1:(k-1)),mother(k:end)];
	offsprings = {son,doughter};
endfunction
