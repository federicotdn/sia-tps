function network = calculate_deltas(network, pattern)
	network.deltas{length(network.weights)}(pattern, :) = (network.expected_outputs(pattern) - network.outputs{end}(pattern));
	for i = length(network.weights)-1:-1:1
		der = network.act_fn_der(network.inputs{i + 1}(pattern, 2:end), network.beta_fn);
		network.deltas{i}(pattern, :) = der.*(network.deltas{i + 1}(pattern, :)*network.weights{i + 1}(2:end, :)');
	end
end