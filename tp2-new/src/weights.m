function network = update_weights(network, pattern)
	for i = 1:length(network.weights)
		network.deltas_w = network.eta .*(bsxfun(@times, network.deltas{i}(pattern,:), network.inputs{i}(pattern, :)'));
		if (isfield('network', 'monmentum_weights'))
			network.deltas_w += network.monmentum_weights * network.momentum;
		end
		network.weights{i} += network.deltas_w;
	end
end

function network = update_weights_batch(network)
	for i = 1:length(network.weights)
		% network.deltas_w = network.eta.*(bsxfun(@times, network.deltas{i}, network.inputs{i}'));
		network.deltas_w = network.eta * (network.deltas{i}'*network.inputs{i})';
		if (isfield('network', 'monmentum_weights'))
			network.deltas_w += network.monmentum_weights * network.momentum;
		end
		network.weights{i} += network.deltas_w;
	end
end