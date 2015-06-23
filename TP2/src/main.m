source('network.m');
source('parser.m');

network = init_network();
network = train(network, true);
printf('Presione cualquier tecla para continutar...\n');
pause();

error = true;
while error
	range = input('Introduzca el rango de patrones para generalizar de la forma MIN,STEP,MAX : ', 's');
	try
		error = false;
		range = parse2array(strsplit(range, ','));
		range = (range(1):range(2):range(3));
		if length(range) == 0
			printf('Error: ');
			error = true;
		end
	catch
		printf('Error: ');
		error = true;
	end
end

network = generalize(network, range);
printf('Presione cualquier tecla para finalizar...\n');
pause();
