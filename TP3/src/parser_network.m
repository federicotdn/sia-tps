source('activation_fn.m');

function config = parse_network()
	fid = fopen ('config_network.txt', 'r');
	while (!feof (fid))
  	line = fgetl (fid);
  	split = strsplit(line, '=');
  	key = split{1};
  	value = split{2};
  	switch key
  		case 'eta'
  			config.eta = str2double(value);
  		case 'beta_fn'
  			config.beta_fn = str2double(value);
  		case 'max_epochs'
  			config.max_epochs = str2double(value);
  		case 'min_cuadratic_error'
  			config.min_cuadratic_error = str2double(value);
  		case 'arch'
  			config.arch = parse2array(strsplit(value, ','));
  		case 'range'
  			aux = parse2array(strsplit(value, ','));
  			config.range = (aux(1):aux(2):aux(3));
  		case 'act_fn'
        [config.act_fn, config.act_fn_der]  = parse_act_function(value);
      case 'output_act_fn'
        [config.output_act_fn, config.output_act_fn_der]  = parse_act_function(value);
      case 'rand_limit'
        config.rand_limit = str2double(value);
  	end
	end
  fclose (fid);
end

function [act_fn, act_fn_der] = parse_act_function(string)
  switch string
    case 'tanh' 
      act_fn = @act_tanh;
      act_fn_der = @act_tanh_der;
    case 'exp'
      act_fn = @exp_fn;
      act_fn_der = @exp_fn_der;
    case 'linear'
      act_fn = @linear;
      act_fn_der = @linear_der;
  end
end

function array = parse2array(cell_string)
	for i = cell_string
		array(end + 1)  = str2double(i{1});
	end
end