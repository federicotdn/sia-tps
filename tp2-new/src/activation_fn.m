function ans = act_tanh(x, beta_fn)
	ans = tanh(beta_fn * x);
end

function ans = act_tanh_der(g, beta_fn)
	ans = beta_fn * (1 - (g.^2));
end

