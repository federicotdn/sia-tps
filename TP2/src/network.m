source('parser.m');
source('feed_forward.m');
source('deltas.m');
source('weights.m');

function network = train(network, debug_mode)
	epochs = 1;

	network.previous_weights = network.weights;
	network = feed_forward_batch(network);
	cuadratic_error(end + 1) = calculate_cuadratic_error(network);
	running = true;
	while running
		if strcmp(network.mode, 'batch')
			network.previous_weights = network.weights;
			network = feed_forward_batch(network);
			network = calculate_deltas_batch(network);
			network = update_weights_batch(network);
			network.momentum_weights = network.deltas_w;
		else
			aux = randperm(length(network.range));
			for pattern = aux;
				network = feed_forward(network, pattern);
				network = calculate_deltas(network, pattern);
				network = update_weights(network, pattern);
				network.momentum_weights = network.deltas_w;
			end
		end

		network = feed_forward_batch(network);
		cuadratic_error(epochs + 1) = calculate_cuadratic_error(network);

		epochs++;

		running = epochs <= network.max_epochs && cuadratic_error(epochs) > network.min_cuadratic_error;   

		% Si b es distinto de 0, entonces esta prendido eta adaptativo
		if (running && network.b ~= 0)
			delta_E = cuadratic_error(epochs) - cuadratic_error(epochs - 1);
			delta_eta = 0;
			network.momentum = network.original_momentum;
			if delta_E > 0
				epochs -=1;
				cuadratic_error = cuadratic_error(1:end - 1);
				delta_eta = - network.eta * network.b;
				network.weights = network.previous_weights;
				network.momentum = 0;
				network.const_E_growth = 0;
			elseif delta_E < 0
				network.const_E_growth++;
				if network.const_E_growth > network.k
					delta_eta = network.a;
				end
			end
			network.eta += delta_eta;
			network.previous_weights = network.weights;
		end
		
		if debug_mode
			printf('E = %f epoca = %d eta = %f\n', cuadratic_error(epochs), epochs, network.eta);
			if (epochs ~=1 &&  mod(epochs -1, network.print_mod) == 0)
				graph(cuadratic_error, epochs, network);
			end
		end
	end
	graph(cuadratic_error, epochs, network);
	if epochs > network.max_epochs
		cut_condition = 'maxima cantidad de generaciones alcanzada';
	else
		cut_condition = 'error cuadratico medio minimo alcanzado';
	end

	printf('\n Termino con: \n');
	printf('E = %f epoca = %d eta = %f\n', cuadratic_error(epochs), epochs, network.eta);
	printf('Razon de corte: %s\n\n', cut_condition);
end

function ans = graph(cuadratic_error, epochs, network)
	hold on;
	clf();
	figure (1, 'name', network.window_name);
	subplot(2,1,1);
	plot(network.range, network.expected_outputs, network.range, network.outputs{end});
	legend('Funcion', 'Aprox', 'location', 'eastoutside');
	title('Funcion 7');
	xlabel('x');
  ylabel('f(x)');
	subplot(2,1,2);
	plot((0:length(cuadratic_error) -1), cuadratic_error);
	title('Error cuadratico medio (E)');
	xlabel('Epoca');
  ylabel('E(epoca)');
	hold off;
	refresh();
end

function network = generalize(network, range)
	network.expected_outputs = calc_expected_outputs(range);
	network.range = normalize(range);
	network.inputs{1} = [(ones(size(network.range',1),1)*-1) network.range'];
	network.outputs = {};
	network = feed_forward_batch(network);
	cuadratic_error = calculate_cuadratic_error(network);
	printf('Generalizo con  E = %f\n', cuadratic_error);
	hold on;
	clf();
	plot(network.range, network.expected_outputs, network.range, network.outputs{end});
	legend('Funcion', 'Aprox', 'location', 'eastoutside');
	title('Funcion 7');
	xlabel('x');
  ylabel('f(x)');
	hold off;
	refresh();
end

function cuadratic_error = calculate_cuadratic_error(network)
	cuadratic_error = (1/(2*length(network.range)))*sum((network.expected_outputs - network.outputs{end}).^2);
end

function network  = init_network()
	config = parse_backpropagation();
	network = config;
	network.weights = init_weights(config.arch, config.rand_limit);
	network.range = normalize(config.range);
	network.inputs{1} = [(ones(size(network.range',1),1)*-1) network.range'];
	network.expected_outputs = calc_expected_outputs(config.range);
	network.const_E_growth = 0;
	network.original_momentum = network.momentum;
end

function ans = normalize(array)
	min_aux = min(array);
	max_aux = max(array);
	ans = ((array - min_aux)/max(max_aux - min_aux)) * 2 -1; 
end

function weights = init_weights(arch, rand_limit)
	for i = 1:length(arch) - 1
		rand('seed', i * (3**32));
		fan_in = arch(i) + 1;
		weights{i} = (rand(fan_in, arch(i + 1)) * (2 * rand_limit)) - rand_limit;
	end
end

function expected_outputs = calc_expected_outputs(range)
	for x = range
		expected_outputs(end + 1) = sin(x)*x^3 + x/2;
	end
	expected_outputs = normalize(expected_outputs)';
end
