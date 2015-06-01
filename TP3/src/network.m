source('feed_forward.m');
source('deltas.m');
source('weights.m');

function network = train(network, debug_mode, backpropagate)
	epochs = 1;
	network.cuadratic_error = realmax;
	running = true;
	while running
		if backpropagate
			aux = randperm(length(network.range));
			for pattern = aux
				network = feed_forward(network, pattern);
				network = calculate_deltas(network, pattern);
				network = update_weights(network, pattern);
			end
		end

		network = feed_forward_batch(network);
		cuadratic_error(epochs) = calculate_cuadratic_error(network);

		network.cuadratic_error = cuadratic_error(epochs);
		if debug_mode
			printf('E = %f epoca = %d\n ', cuadratic_error(epochs), epochs);
			if ( mod(epochs, 20) == 0)
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
		running = epochs <= network.max_epochs && network.cuadratic_error >= network.min_cuadratic_error && backpropagate;
	end
end

function cuadratic_error = calculate_cuadratic_error(network)
	cuadratic_error = (1/(length(network.range)))*sum((network.expected_outputs - network.outputs{end}).^2);
end

function network  = init_network(config)
	network.eta = config.eta;
	network.beta_fn = config.beta_fn;
	network.act_fn = config.act_fn;
	network.act_fn_der = config.act_fn_der;
	network.output_act_fn = config.output_act_fn;
	network.output_act_fn_der = config.output_act_fn_der;
	network.max_epochs = config.max_epochs;
	network.range = config.range;
	network.min_cuadratic_error = config.min_cuadratic_error;
	network.inputs{1} = [(ones(size(config.range',1),1)*-1) config.range'];
end
