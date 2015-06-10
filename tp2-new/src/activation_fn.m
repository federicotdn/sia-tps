function ans = act_tanh(x, beta_fn)
	ans = tanh(bsxfun(@times, x, beta_fn));
end

function ans = act_tanh_der(g, beta_fn)
	ans = beta_fn .* (1 - (g.^2));
end

function ans  = exp_fn(x, beta_fn)
	ans =  1./(1 + exp(-2 .* bsxfun(@times, x, beta_fn)));
end

function ans  = exp_fn_der(g, beta_fn)
	ans =  (2 .* beta_fn .*g) .* (1 - g);
end

function ans = linear(x, beta_fn)
	ans = x;
end

function ans = linear_der(g, beta_fn)
	ans = 1;
end
