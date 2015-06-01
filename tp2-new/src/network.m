source('parser.m');
source('feed_forward.m');
source('deltas.m');
source('weights.m');

function network = train(network, debug_mode)
	epochs = 1;
	while epochs <= network.max_epochs
		aux = randperm(length(network.range));
		for pattern = aux
			network = feed_forward(network, pattern);
			network = calculate_deltas(network, pattern);
			network = update_weights(network, pattern);
		end

		network = feed_forward_batch(network);
		cuadratic_error(epochs) = calculate_cuadratic_error(network);

		if epochs > 1 && mod(epochs - 1, 30) == 0
			delta_eta = 0;
			if cuadratic_error(epochs) > cuadratic_error(epochs - 30)
				network.weights = network.prev_weights;
				network.outputs = network.prev_outputs;
				cuadratic_error(epochs) = cuadratic_error(epochs - 30);
				delta_eta = -network.b * network.eta;
			elseif(cuadratic_error(epochs) < cuadratic_error(epochs - 30))
				delta_eta = network.a;
			end
			network.eta += delta_eta;
		end

		if epochs == 1 || mod(epochs - 1, 30) == 0
			network.prev_weights = network.weights;
			network.prev_outputs = network.outputs;
		end
		
		if debug_mode
			printf('E = %f epoca = %d eta: %f\n', cuadratic_error(epochs), epochs, network.eta);
			if ( mod(epochs - 1, 30) == 0)
				hold on;
				subplot(2,1,1);
				plot(network.range, network.expected_outputs, network.range, network.outputs{end});
				subplot(2,1,2);
				plot((1:length(cuadratic_error)), cuadratic_error);
				hold off;
				refresh();
			end
		end
		epochs++;
	end
end

function cuadratic_error = calculate_cuadratic_error(network)
	cuadratic_error = (1/(2*length(network.range)))*sum((network.expected_outputs - network.outputs{end}).^2);
end

function network  = init_network()
	config = parse_backpropagation();
	network.eta = config.eta;
	network.a = config.a;
	network.b = config.b;
	network.beta_fn = config.beta_fn;
	network.act_fn = config.act_fn;
	network.act_fn_der = config.act_fn_der;
	network.output_act_fn = config.output_act_fn;
	network.output_act_fn_der = config.output_act_fn_der;
	network.max_epochs = config.max_epochs;
	network.range = config.range;
	network.min_cuadratic_error = config.min_cuadratic_error;
	network.weights = init_weights(config.arch, config.rand_limit);
	network.inputs{1} = [(ones(size(config.range',1),1)*-1) config.range'];
	network.expected_outputs = calc_expected_outputs(config.range)';
end

function weights = init_weights(arch, rand_limit)
	for i = 1:length(arch) - 1
		weights{i} = (rand(arch(i) + 1, arch(i + 1)) * (2 * rand_limit)) - rand_limit;
		% weights{i} = ones(arch(i) + 1, arch(i + 1));
	end
end

function expected_outputs = calc_expected_outputs(range)
	for x = range
		% expected_outputs(end + 1) = sin(x)*x^3 + x/2;
		% expected_outputs(end + 1) = sin(x) + (6 * (cos(x))^2);
		expected_outputs(end + 1) = tanh(0.1 * x) + sin(3*x);
		% expected_outputs(end + 1) = sin(x + 2*x^2 + 3*x^3);
	end
	max_output = max(abs(expected_outputs));
	expected_outputs /= max_output;
	% expected_outputs = (expected_outputs + 1)/2;
end

% function outputs = init_inputs(arch)
% 	for i = 1:length(arch)-1
% 		outputs{i} = zeros(length(range), arch(i+1));
% 	end
% end
