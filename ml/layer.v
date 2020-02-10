module ml

import vnum.num

struct Layer {
pub mut:
	n_type              string
	l_size              int
	activation_function ActivationFunction
	neurons             []&Neuron
	input_sums          num.NdArray
	weights             num.NdArray
	biases              num.NdArray
	activations         num.NdArray
	sigma_primes        num.NdArray
}

pub fn create_layer(n_type string, l_size int, activation_function ActivationFunction) &Layer {
	mat := num.zeros([1, l_size])
	mut layer := &Layer{
		n_type: n_type
		l_size: l_size
		activation_function: activation_function
		neurons: []
		input_sums: mat.copy('C')
		weights: mat.copy('C')
		biases: mat.copy('C')
		activations: mat.copy('C')
		sigma_primes: mat.copy('C')
	}
	for i := 0; i < l_size; i++ {
		neuron := create_neuron(n_type)
		layer.neurons << neuron
		layer.input_sums.set([0, i], neuron.input_sum)
		layer.biases.set([0, i], neuron.bias)
		layer.activations.set([0, i], neuron.activation)
		layer.sigma_primes.set([0, i], neuron.sigma_prime)
	}
	return layer
}

pub fn (l Layer) str() string {
	mut s := ''
	s += 'Layer Type: $l.n_type\n'
	s += 'Neurons:\n$l.neurons\n'
	return s
}

pub fn (l Layer) size() int {
	return l.l_size
}
