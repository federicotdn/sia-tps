function network = update_weights(network, pattern)
	for i = 1:length(network.weights)
		network.deltas_w{i} = network.eta .*(bsxfun(@times, network.deltas{i}(pattern,:), network.inputs{i}(pattern, :)'));
		if (isfield(network, 'momentum_weights'))
			network.deltas_w{i} += network.momentum_weights{i} * network.momentum;
		end
		network.weights{i} += network.deltas_w{i};
	end
end

function network = update_weights_batch(network)
	for i = 1:length(network.weights)
		network.deltas_w{i} = network.eta * (network.deltas{i}'*network.inputs{i})';
		if (isfield(network, 'momentum_weights'))
			network.deltas_w{i} += network.momentum_weights{i} * network.momentum;
		end
		network.weights{i} += network.deltas_w{i};
	end
end