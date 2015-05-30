source('activation_fn.m');

function [eta, beta_fn, act_fn, act_fn_der, max_epochs, range, min_cuadratic_error, arch, rand_limit] = parse()
	fid = fopen ("config.txt", "r");
	while (!feof (fid))
  	line = fgetl (fid);
  	split = strsplit(line, "=");
  	key = split{1};
  	value = split{2};
  	switch key
  		case "eta"
  			eta = str2double(value);
  		case "beta_fn"
  			beta_fn = str2double(value);
  		case "max_epochs"
  			max_epochs = str2double(value);
  		case "min_cuadratic_error"
  			min_cuadratic_error = str2double(value);
  		case "arch"
  			arch = parse2array(strsplit(value, ","));
  		case "range"
  			aux = parse2array(strsplit(value, ","));
  			range = (aux(1):aux(2):aux(3));
  		case "act_fn"
  			if (strcmp(value, 'tanh'))
          act_fn = @act_tanh;
          act_fn_der = @act_tanh_der;
        elseif (strcmp(value, 'exp'))
          act_fn = @exp_fn;
          act_fn_der = @exp_fn_der;
        endif
      case "rand_limit"
        rand_limit = str2double(value);
  	end
	endwhile
fclose (fid);
endfunction

function array = parse2array(cell_string)
	for i = cell_string
		array(end + 1)  = str2double(i{1});
	endfor
endfunction