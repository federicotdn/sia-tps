function [rand_limit ,arch, individuals_qty] = parse()
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
  	end
	endwhile
fclose (fid);
endfunction

function array = parse2array(cell_string)
	for i = cell_string
		array(end + 1)  = str2double(i{1});
	endfor
endfunction