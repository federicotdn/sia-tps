source("crossover.m");

function [rand_limit ,arch, individuals_qty, replacement_method, mutation_prob, range, selection, selection_k, tournament_m ,replacement_selection, replacement_tournament_m, cross_function] = parse()
	fid = fopen ("config.txt", "r");
	while (!feof (fid))
  	line = fgetl (fid);
  	split = strsplit(line, "=");
  	key = split{1};
  	value = split{2};
  	switch key
  		case "arch"
  			arch = parse2array(strsplit(value, ","));
  		case "rand_limit"
  			rand_limit = str2double(value);
      case "individuals_qty"
        individuals_qty = str2double(value);
      case "replacement_method"
        replacement_method = str2double(value);
      case "max_generations"
        max_generations = str2double(value);
      case "mutation_prob"
        mutation_prob = str2double(value);
      case "range"
        aux = parse2array(strsplit(value, ","));
        range = (aux(1):aux(3):aux(2));
  	  case "selection"
        selection = value;
      case "selection_k"
        selection_k = str2double(value);
      case "tournament_m"
        tournament_m = str2double(value);
      case "replacement_selection"
        replacement_selection = value;
      case "replacement_tournament_m"
        replacement_tournament_m = str2double(value);
      case "cross_function"
        cross_function = parse2function(value);
    end
	endwhile
fclose (fid);
endfunction

function array = parse2array(cell_string)
	for i = cell_string
		array(end + 1)  = str2double(i{1});
	endfor
endfunction

function f = parse2function(string)
  switch string
    case "one_point"
      f = @one_point_cross;
    case "two_point"
      f = @two_point_cross;
    case "anular_point"
      f = @anular_cross;
    case "uniform_point"
      f = @uniform_cross;
  end
endfunction