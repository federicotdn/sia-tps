% Configuration Parser

source('crossover.m');
source('selection.m');
source('replacement.m')

function config = parse_config()
	fid = fopen('config.txt', 'r');
	while !feof(fid)
  	text_line = fgetl(fid);

    if length(text_line) == 0 || text_line(1) == '%'
      continue;
    end

  	split = strsplit(text_line, '=');
  	key = split{1};
  	value = split{2};

  	switch key
  		case 'arch'
  			config.arch = parse_to_array(strsplit(value, ','));
  		case 'rand_limit'
  			config.rand_limit = str2double(value);
      case 'population_size'
        config.population_size = str2double(value);
      case 'replacement_method'
        config.replacement_method = parse_replacement_function(value);
      case 'max_generations'
        config.max_generations = str2double(value);
      case 'mutation_prob'
        config.mutation_prob = str2double(value);
      case 'mutation_range'
        config.mutation_range = str2double(value);
      case 'mutation_function'
        config.mutation_function = value;
      case 'mutation_alpha'
        config.mutation_alpha = str2double(value);
      case 'mutation_beta'
        config.mutation_beta = str2double(value);
      case 'range'
        aux = parse_to_array(strsplit(value, ','));
        config.range = (aux(1):aux(2):aux(3));
      case 'cross_prob'
        config.cross_prob = str2double(value);
      case 'cross_function'
        config.cross_function = parse_cross_function(value);
      case 'selection'
        config.selection = value;
      case 'selection_k'
        config.selection_k = str2double(value);
      case 'tournament_m'
        config.tournament_m = str2double(value);
      case 'mixed_n'
        config.mixed_n = str2double(value);
      case 'mixed_roul'
        config.mixed_roul = str2double(value);
      case 'replacement_selection'
        config.replacement_selection = value;
      case 'replacement_tournament_m'
        config.replacement_tournament_m = str2double(value);
      case 'replacement_mixed_n'
        config.replacement_mixed_n = str2double(value);
      case 'replacement_mixed_roul'
        config.replacement_mixed_roul = str2double(value);
      case 'max_fitness'
        config.max_fitness = str2double(value);
      case 'max_fitness_generations'
        config.max_fitness_generations = str2double(value);
      case 'repeated_weights'
        config.repeated_weights = str2double(value);
    end
	end

  fclose(fid);
end

function array = parse_to_array(cell_string)
	for i = cell_string
		array(end + 1) = str2double(i{1});
	end
end

function fn = parse_cross_function(string)
  switch string
    case 'one_point'
      fn = @one_point_cross;
    case 'two_point'
      fn = @two_point_cross;
    case 'anular_point'
      fn = @anular_cross;
    case 'uniform_point'
      fn = @uniform_cross;
  end
end

function fn = parse_replacement_function(string)
  switch string
    case 'method1'
      fn = @method1;
    case 'method2'
      fn = @method2;
    case 'method3'
      fn = @method3;
  end
end