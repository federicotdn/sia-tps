source('parser.m');
source('feed_forward.m');
source('deltas.m');
source('weights.m');

function network = train(network, debug_mode)
	epochs = 1;

	network.previous_weights = network.weights;
	network = feed_forward_batch(network);
	cuadratic_error(end + 1) = calculate_cuadratic_error(network);
	while epochs <= network.max_epochs
		pattern_count = 0;
		if strcmp(network.mode, 'batch')
			network.previous_weights = network.weights;
			network = feed_forward_batch(network);
			network = calculate_deltas_batch(network);
			network = update_weights_batch(network);
			network.monmentum_weights = network.deltas_w;
			% abs(network.inputs{2}) > 0.9
			% network.outputs{end}
		else
			aux = randperm(length(network.range));
			i = 1;
			while i <= length(aux)
				pattern = aux(i);
				network = feed_forward(network, pattern);
				network = calculate_deltas(network, pattern);
				network = update_weights(network, pattern);
				network.monmentum_weights = network.deltas_w;

				% if i ~=1 && mod(i - 1, network.k) == 0
				% 	network = feed_forward_batch(network);
				% 	current_cuadratic_error = calculate_cuadratic_error(network);
				% 	delta_E = current_cuadratic_error - previous_cuadratic_error;
				% 	delta_eta = 0;
				% 	if delta_E >= 0
				% 		if !network.went_back
				% 			network.weights = network.previous_weights;
				% 			network.went_back = true;
				% 			i -= network.k;
				% 		end
				% 		network.eta -= network.b * network.eta;
				% 	elseif delta_E < 0
				% 		network.eta += network.a;
				% 		network.went_back = false;
				% 		previous_cuadratic_error = current_cuadratic_error;
				% 	end
				% 	network.previous_weights = network.weights;
				% end
				i++;
			end
		end

		network = feed_forward_batch(network);
		cuadratic_error(epochs + 1) = calculate_cuadratic_error(network);

		% network.outputs{end}
		% network.inputs{3}

		epochs++;

		% Si b es distinto de 0, entonces esta prendido eta adaptativo
		if (network.b ~= 0)
			delta_E = cuadratic_error(epochs) - cuadratic_error(epochs - 1);
			delta_eta = 0;
			if delta_E > 0
				epochs -=1;
				cuadratic_error = cuadratic_error(1:end - 1);
				delta_eta = - network.eta * network.b;
				network.weights = network.previous_weights;
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
			if ( mod(epochs, network.print_mod) == 0)
				hold on;
				subplot(2,1,1);
				plot(network.range, network.expected_outputs, network.range, network.outputs{end});
				subplot(2,1,2);
				plot((1:length(cuadratic_error)), cuadratic_error);
				hold off;
				refresh();
			end
		end
	end
end

function cuadratic_error = calculate_cuadratic_error(network)
	cuadratic_error = (1/(2*length(network.range)))*sum((network.expected_outputs - network.outputs{end}).^2);
end

function network  = init_network()
	config = parse_backpropagation();
	network = config;
	network.weights = init_weights(config.arch, config.rand_limit);
	min_range = min(config.range);
	max_range = max(config.range);
	network.range = ((config.range - min_range)/max(max_range - min_range)) * 2 -1; 
	% network.range = config.range/max_range;
	network.inputs{1} = [(ones(size(network.range',1),1)*-1) network.range'];
	network.expected_outputs = calc_expected_outputs(config.range)';

	% network.range /=max_range;
	network.const_E_growth = 0;
	% network.betas = [ones(1,5) * 2, ones(1,5) * 1.5, ones(1,5) * 1.3, ones(1,5) * 1.1, ones(1,5) * 0.8, ones(1,5) * 1, ones(1,5) * 0.7];
	network.betas = [ones(1,10) * 0.1, ones(1,10) * 2, ones(1,15) * 3];
	network.betas =network.beta_fn;
	network.went_back = false;
end

function weights = init_weights(arch, rand_limit)
	for i = 1:length(arch) - 1
		rand('seed', i * (5**32));
		fan_in = arch(i) + 1;
		% rand_limit = 1/sqrt(fan_in);
		weights{i} = (rand(fan_in, arch(i + 1)) * (2 * rand_limit)) - rand_limit;
		% weights{i} = ones(arch(i) + 1, arch(i + 1));
	end
end

function expected_outputs = calc_expected_outputs(range)
	for x = range
		expected_outputs(end + 1) = sin(x)*x^3 + x/2;
		% expected_outputs(end + 1) = sin(x) + (6 * (cos(x))^2);
		% expected_outputs(end + 1) = tanh(0.1 * x) + sin(3*x);
		% expected_outputs(end + 1) = sin(x + 2*x^2 + 3*x^3);
	end
	max_output = max(expected_outputs);
	min_output = min(expected_outputs);
	expected_outputs = (((expected_outputs - min_output)/(max_output - min_output)) *2 ) -1;
	% expected_outputs /= max_output;
	% expected_outputs = (expected_outputs + 1)/2;
end

% function outputs = init_inputs(arch)
% 	for i = 1:length(arch)-1
% 		outputs{i} = zeros(length(range), arch(i+1));
% 	end
% end
