source('activation_fn.m');

function config = parse_backpropagation()
	fid = fopen ('config.txt', 'r');
	while (!feof (fid))
  	line = fgetl (fid);
    disp(line);
    if length(line) == 0 || line(1) == '%'
      continue;
    end

  	split = strsplit(line, '=');
  	key = split{1};
  	value = split{2};
  	switch key
  		case 'eta'
  			config.eta = str2double(value);
  		case 'beta_fn'
        if (!isfield(config, 'range'))
          error('beta_fn debe aparecer despues de range en la configuracion')
        end
  			aux = parse2array(strsplit(value, ','));
        config.betas = parse_betas(aux, config.range);
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
      case 'momentum'
        config.momentum = str2double(value);
  	end
	end
  fclose (fid);
  printf('\n');
end


function betas = parse_betas(array, range)
  betas = [];
  if rem(length(array), 3) ~= 0
    error ('Error al parsear beta: el formato es "desde, valor beta, hasta" y debe cubrir todo el intervalo');
  end
  for i = 1:3:length(array)/3
    betas = [betas, [ones(1, length(find(range >= array(i) & range  <= array(i + 2)))) * array(i + 1)]];
  end

  if length(betas) ~= length(range)
    error('Error al parsear beta: el intervalo de betas debe ser del mismo tamaño que el intervalo de la función');
  end
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