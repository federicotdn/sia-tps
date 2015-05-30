function network = update_weights(network, pattern)
	for i = 1:length(network.weights)
		network.weights{i} += network.eta*(bsxfun(@times, network.deltas{i}(pattern,:), network.inputs{i}(pattern, :)'));
	endfor
end