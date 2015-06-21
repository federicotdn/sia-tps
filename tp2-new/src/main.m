source('network.m');

network = init_network();
network = train(network, true);
printf('Presione cualquier tecla para continutar...\n');
pause();
range = input('Introduzca el rango de patrones para generalizar de la forma min,step,max : ', 's');
network = generalize(network, range);
printf('Presione cualquier tecla para finalizar...\n');
pause();
