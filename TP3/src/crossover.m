function offsprings = one_point_cross(mother, father, prob)
	if rand() < prob
		k = randi(length(mother));
		son = [mother(1:(k-1)),father(k:end)];
		daughter = [father(1:(k-1)),mother(k:end)];
		offsprings = {son,daughter};
	else
		offsprings = {mother,father}
	end
endfunction

function offsprings = two_point_cross(mother, father, prob)
	if rand() < prob	
		r1 = randi(length(mother));
		r2 = randi([r1, length(mother)]);
		son = [mother(1:(r1 - 1)),father(r1:r2),mother(r2 + 1:end)];
		daughter = [father(1:(r1-1)),mother(r1:r2),father(r2+1:end)];
		offsprings = {son,daughter};
	else
		offsprings = {mother,father}
	end
endfunction

function offsprings = anular_cross(mother, father, prob)
	if rand() < prob
		k = randi(length(mother));
		l = randi(length(mother)/2);
		if (k+l) > length(mother)
			son = [mother(1:(l-(length(mother)-k))),father((l-(length(mother)-k))+1:k),mother(k+1:end)];
			daughter = [father(1:(l-(length(mother)-k))),mother((l-(length(mother)-k))+1:k),father(k+1:end)];
		else
			son = [mother(1:k-1),father(k:k+l),mother(k+l+1:end)];
			daughter = [father(1:k-1),mother(k:k+l),father(k+l+1:end)];	
		endif
		offsprings = {son,daughter};
	else
		offsprings = {mother,father}
	end
endfunction

function offsprings = uniform_cross(mother, father, prob)
	if rand() < prob	
		k = randi(length(mother));
		son = [];
		daughter = [];
		for i = 1:length(mother)
			locus = rand;
			if mother(i) == father(i) && locus > 0.5
				son(end+1) = father(i);
				daughter(end+1) = mother(i);
			else
				son(end+1) = mother(i);
				daughter(end+1) = father(i);
			endif
		endfor
		offsprings = {son,daughter};
	else
		offsprings = {mother,father}
	end
endfunction