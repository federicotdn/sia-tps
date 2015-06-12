function network = feed_forward(network, pattern)
	for i = 1:length(network.weights)
		network.outputs{i}(pattern, :) = network.inputs{i}(pattern, :) * network.weights{i};
		if (i < length(network.weights))
			if (i == 1)
				temp_output = network.act_fn(network.outputs{i}(pattern, :), network.betas);
			else
				temp_output = network.act_fn(network.outputs{i}(pattern, :), network.beta_fn);
			end
			network.inputs{i + 1}(pattern, :) = [(ones(size(temp_output,1),1)*-1) temp_output];
		end
	end
	index = length(network.weights);
	network.inputs{index + 1}(pattern, :) = network.outputs{index}(pattern, :);
	network.outputs{index + 1}(pattern, :) = network.output_act_fn(network.inputs{end}(pattern, :), network.beta_fn);
end

function network = feed_forward_batch(network)
	for i = 1:length(network.weights)
		network.outputs{i} = network.inputs{i} * network.weights{i};
		if (i < length(network.weights))
			if (i == 1)
				temp_output = network.act_fn(network.outputs{i}, network.betas);
			else
				temp_output = network.act_fn(network.outputs{i}, network.beta_fn);
			end
			network.inputs{i + 1} = [(ones(size(temp_output,1),1)*-1) temp_output];
		end
	end
	index = length(network.weights);
	network.inputs{index + 1} = network.outputs{index};
	network.outputs{index + 1} = network.output_act_fn(network.inputs{end}, network.beta_fn);
end
