source('parser.m');
source('feed_forward.m');
source('deltas.m');
source('weights.m');

function network = train(network)
	epochs = 1;
	while epochs <= network.max_epochs
		aux = randperm(length(network.range));
		for pattern = aux
			network = feed_forward(network, pattern);
			network = calculate_deltas(network, pattern);
			network = update_weights(network, pattern);
		end

		cuadratic_error(epochs) = calculate_cuadratic_error(network);
		
		if ( mod(epochs, 10) == 0)
			printf('E = %f epoca = %d\n ', cuadratic_error(epochs), epochs);
			hold on;
			subplot(2,1,1);
			plot(network.range, network.expected_outputs, network.range, network.outputs{end});
			subplot(2,1,2);
			plot((1:length(cuadratic_error)), cuadratic_error);
			hold off;
			refresh();
		endif
		epochs++;
	end
end

function cuadratic_error = calculate_cuadratic_error(network)
	cuadratic_error = (1/(2*length(network.range)))*sum((network.expected_outputs - network.outputs{end}).^2);
end

function network  = init()
	[eta, beta_fn, act_fn, act_fn_der, max_epochs, range, min_cuadratic_error, arch, rand_limit] = parse();
	network.eta = eta;
	network.beta_fn = beta_fn;
	network.act_fn = act_fn;
	network.act_fn_der = act_fn_der;
	network.max_epochs = max_epochs;
	network.range = range;
	network.min_cuadratic_error = min_cuadratic_error;
	network.weights = init_weights(arch, rand_limit);
	network.inputs{1} = [(ones(size(range',1),1)*-1) range'];
	network.expected_outputs = calc_expected_outputs(range)';
end

function weights = init_weights(arch, rand_limit)
	for i = 1:length(arch) - 1
		weights{i} = (rand(arch(i) + 1, arch(i + 1)) * (2 * rand_limit)) - rand_limit;
		% weights{i} = ones(arch(i) + 1, arch(i + 1));
	end
end

function expected_outputs = calc_expected_outputs(range)
	for x = range
		% expected_outputs(end + 1) = sin(x) + (6 * (cos(x))^2);
		expected_outputs(end + 1) = tanh(0.1 * x) + sin(3*x);
		% expected_outputs(end + 1) = sin(x + 2*x^2 + 3*x^3);
	end
	max_output = max(abs(expected_outputs));
	expected_outputs /= max_output;
end

% function outputs = init_inputs(arch)
% 	for i = 1:length(arch)-1
% 		outputs{i} = zeros(length(range), arch(i+1));
% 	end
% end
