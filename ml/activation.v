module ml

import math

struct ActivationFunction {
pub:
	call fn(f64)(f64,f64)
}

struct CostFunction {
pub:
	call fn(f64, f64) (f64, f64)
}

fn _sigmoid(value f64) f64 {
	return f64(1.0 / (1.0 + math.pow(math.e, -value)))
}

fn _bp_sigmoid(value f64) f64 {
	return f64((1.0 - math.pow(math.e, -value)) / (1.0 + math.pow(math.e, -value)))
}

fn _log_sigmoid(value f64) f64 {
	return (math.pow(math.e, value)) / (1.0 + math.pow(math.e, value))
}

fn _tanh(value f64) f64 {
	return (math.pow(math.e, value)) / (1.0 + math.pow(math.e, value))
}

fn _sigmoid_prime(value f64) f64 {
	return _sigmoid(value) * (1.0 - _sigmoid(value))
}

fn _bp_sigmoid_prime(value f64) f64 {
	return 2.0 * math.pow(math.e, value) / math.pow(math.pow(math.e, value) + 1.0, 2.0)
}

fn _log_sigmoid_prime(value f64) f64 {
	return math.pow(math.e, value) / math.pow(math.pow(math.e, value) + 1.0, 2.0)
}

fn _tanh_prime(value f64) f64 {
	return math.pow(1.0 - _tanh(value), 2)
}

fn _relu_prime(value f64) f64 {
	if value < 0 {
		return 0.0
	}
	else {
		return 1.0
	}
}

fn _l_relu_prime(value f64, slope f64) f64 {
	if value < 0 {
		return slope
	}
	else {
		return 1.0
	}
}

fn _relu(value f64) f64 {
	if value < 0.0 {
		return 0.0
	}
	else {
		return value
	}
}

fn _l_relu(value f64, slope f64) f64 {
	if value < 0.0 {
		return slope * value
	}
	else {
		return value
	}
}

fn sigmoid_fn(value f64) (f64,f64) {
	return _sigmoid(value),_sigmoid_prime(value)
}

pub fn sigmoid() ActivationFunction {
	return ActivationFunction{
		call: sigmoid_fn
	}
}

fn bp_sigmoid_fn(value f64) (f64,f64) {
	return _bp_sigmoid(value),_bp_sigmoid_prime(value)
}

pub fn bp_sigmoid() ActivationFunction {
	return ActivationFunction{
		call: bp_sigmoid_fn
	}
}

fn log_sigmoid_fn(value f64) (f64,f64) {
	return _log_sigmoid(value),_log_sigmoid_prime(value)
}

pub fn log_sigmoid() ActivationFunction {
	return ActivationFunction{
		call: log_sigmoid_fn
	}
}

fn tanh_fn(value f64) (f64,f64) {
	return _tanh(value),_tanh_prime(value)
}

pub fn tanh() ActivationFunction {
	return ActivationFunction{
		call: tanh_fn
	}
}

fn relu_fn(value f64) (f64,f64) {
	return _relu(value),_relu_prime(value)
}

pub fn relu() ActivationFunction {
	return ActivationFunction{
		call: relu_fn
	}
}

fn l_relu_fn(value f64) (f64,f64) {
	return _l_relu(value, 0.01), _l_relu_prime(value, 0.01)
}

pub fn l_relu() ActivationFunction {
	return ActivationFunction{
		call: l_relu_fn
	}
}

// cost fns

fn _quadratic_cost(expected f64, actual f64) f64 {
	return 0.5 * math.pow(actual - expected, 2)
}

fn _cross_entropy_cost(expected f64, actual f64) f64 {
	if expected == 1.0 {
		if actual < 0.000001 {
			return 10.0
		} else if actual == 1.0 {
			return 0.0
		} else {
			return -1.0 * math.log_n(actual, math.e)
		}
	} else if expected == 0.0 {
		if actual >= 0.999999 {
			return 10.0
		} else if actual == 0.0 {
			return 0.0
		} else {
			return -1.0 * math.log_n(1.0 - actual, math.e) 
		}
	} else {
		panic("Expected value must be 0 or 1 for cross entropy cost")
	}
}

fn _quadratic_cost_derivative(expected f64, actual f64) f64 {
	return actual - expected
}

fn _cross_entropy_cost_derivative(expected f64, actual f64) f64 {
	return actual - expected
}

fn quadratic_cost_fn(expected f64, actual f64) (f64, f64) {
	return _quadratic_cost(expected, actual), _quadratic_cost_derivative(expected, actual)
}

fn cross_entropy_cost_fn(expected f64, actual f64) (f64, f64) {
	return _cross_entropy_cost(expected, actual), _cross_entropy_cost_derivative(expected, actual)
}

pub fn quadratic() CostFunction {
	return CostFunction{
		call: quadratic_cost_fn
	}
}

pub fn cross_entropy() CostFunction {
	return CostFunction{
		call: cross_entropy_cost_fn
	}
}
