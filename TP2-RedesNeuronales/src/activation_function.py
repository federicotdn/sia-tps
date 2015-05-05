import numpy as np
import pdb

def exponential_fn(x):
	return 1 / (1 + np.exp([(- 2) * x * 1/2])[0])

def exponential_fn_derivative(x):
	exp = exponential_fn(x)
	return 2 * 1/2 * exp * (1 - exp)

def tanh_fn(x):
	return np.tanh(1 *x)

def tanh_fn_derivative(x):
	return 1*(1 - np.power(tanh_fn(x), 2))
