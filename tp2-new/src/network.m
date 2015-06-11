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

		network.monmentum_weights = network.deltas_w;

		network = feed_forward_batch(network);
		cuadratic_error(epochs) = calculate_cuadratic_error(network);

		% Si b es distinto de 0, entonces esta prendido eta adaptativo
		if (epochs ~= 1 && network.b ~= 0)
			delta_E = cuadratic_error(epochs) - cuadratic_error(epochs - 1);
			delta_eta = 0;
			if (delta_E > 0)
				delta_eta = -network.b * network.eta;
				epochs -= 1;
				cuadratic_error = cuadratic_error(1:epochs);
				network.weights = network.previous_weights;
				network.const_E_growth = 0;
			elseif delta_E < 0
				network.const_E_growth += 1;
				if mod(network.const_E_growth, network.k) == 0
					delta_eta = network.a;
				end
			end
			network.eta += delta_eta;
			network.previous_weights = network.weights;
		end

		if epochs == 1
			network.previous_weights = network.weights;
		end
		
		if debug_mode
			printf('E = %f epoca = %d eta = %f\n', cuadratic_error(epochs), epochs, network.eta);
			if ( mod(epochs, 20) == 0)
				clf();
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
	network = config;
	network.weights = init_weights(config.arch, config.rand_limit);
	network.inputs{1} = [(ones(size(config.range',1),1)*-1) config.range'];
	network.expected_outputs = calc_expected_outputs(config.range)';
	min_range = min(config.range);
	max_range = max(config.range);
	% network.range /=max_range;
	network.range = ((network.range - min_range)/max(max_range - min_range) *2) -1;

	network.const_E_growth = 0;
end

function weights = init_weights(arch, rand_limit)
	for i = 1:length(arch) - 1
		weights{i} = (rand(arch(i) + 1, arch(i + 1)) * (2 * rand_limit)) - rand_limit;
		% weights{i} = ones(arch(i) + 1, arch(i + 1));
	end
end

function betas = init_betas(range)
	betas = [];
	betas = ones(1, length(range)) * 0.3;
	% betas = [betas, [ones(1, length(find(range >= 10 & range  <= 14))) * 0.3]];
	% betas = [betas, [ones(1, length(find(range > 14 & range  <= 16))) * 0.1]];
	% betas = [betas, [ones(1, length(find(range > 25 & range  <= 33))) * 0.3]];
	% betas = [betas, [ones(1, length(find(range > 33 & range  <= 45))) * 0.1]];
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
	expected_outputs = (((expected_outputs - min_output)/(max_output - min_output))*2)-1;
	% expected_outputs = (expected_outputs + 1)/2;
end

% function outputs = init_inputs(arch)
% 	for i = 1:length(arch)-1
% 		outputs{i} = zeros(length(range), arch(i+1));
% 	end
% end
