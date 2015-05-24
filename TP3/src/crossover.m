function offsprings = one_point_cross(mother, father)
	k = randi(length(mother));
	son = [mother(1:(k-1)),father(k:end)];
	doughter = [father(1:(k-1)),mother(k:end)];
	offsprings = {son,doughter};
endfunction

function offsprings = two_point_cross(mother, father)
	k = randi(length(mother));
	j = randi(length(mother));
	if j < k 
		son = [mother(1:(j-1)),father(j:k),mother(k:end)];
		doughter = [father(1:(j-1)),mother(j:k),father(k:end)];
	else
		son = [mother(1:(k-1)),father(k:j),mother(j:end)];
		doughter = [father(1:(k-1)),mother(k:j),father(j:end)]; 
	end
	offsprings = {son,doughter};
endfunction

function offsprings = anular_cross(mother, father)
	k = randi(length(mother));
	l = randi(length(mother)/2);
	if (k+l) > length(mother)
		son = [mother(1:(l-(length(mother)-k))),father((l-(length(mother)-k))+1:k),mother(k+1:end)];
		doughter = [father(1:(l-(length(mother)-k))),mother((l-(length(mother)-k))+1:k),father(k+1:end)];
	else
		son = [mother(1:k-1),father(k:k+l),mother(k+l+1:end)];
		doughter = [father(1:k-1),mother(k:k+l),father(k+l+1:end)];	
	endif
	offsprings = {son,doughter};
endfunction

function offsprings = uniform_cross(mother, father)
	k = randi(length(mother));
	son = [];
	doughter = [];
	for i = 1:length(mother)
		locus = rand;
		if mother(i) == father(i) && locus > 0.5
			son(end+1) = father(i);
			doughter(end+1) = mother(i);
		else
			son(end+1) = mother(i);
			doughter(end+1) = father(i);
		endif
	endfor
	offsprings = {son,doughter};
endfunction