module ml

import vnum.num
import time
import math

pub const (
	LAYER_TYPES = ['input', 'hidden', 'output']
	CONNECTION_TYPES = ['full', 'ind_to_ind', 'random']
	COST_FUNCTIONS = ['mse', 'c_ent']
)

struct Network {
pub mut:
	input_layers  []&Layer
	output_layers []&Layer
	hidden_layers []&Layer
	all_neurons   []&Neuron
	all_synapses  []&Synapse
	error_signal  []f64
	total_error   f64
	mse           f64
	w_gradient    []f64
	b_gradient    []f64
	learning_rate f64
	momentum      f64
	etah_plus     f64
	etah_minus    f64
	delta_max     f64
	delta_min     f64
	prev_mse      f64
	alpha         f64
	beta1         f64
	beta2         f64
	epsilon       f64
	time_step     int
}

pub fn create_network() Network {
	return Network{
		total_error: 1.0
		mse: 1.0
		learning_rate: 0.005
		momentum: 0.05
		etah_plus: 1.2
		etah_minus: 0.5
		delta_max: 50.0
		delta_min: 0.1
		prev_mse: 1.0
		alpha: 0.001
		beta1: 0.9
		beta2: 0.999
		epsilon: 10e-8
		time_step: 0
	}
}

pub fn (n mut Network) add_layer(l_type string, l_size int, n_type string, activation_function ActivationFunction) {
	layer := create_layer(n_type, l_size, activation_function)
	for i := 0; i < layer.neurons.len; i++ {
		n.all_neurons << layer.neurons[i]
	}
	if l_type == 'input' {
		n.input_layers << layer
	}
	else if l_type == 'hidden' {
		n.hidden_layers << layer
	}
	else if l_type == 'output' {
		n.output_layers << layer
	}
	else {
		panic('Must specify a valid layer type')
	}
}

pub fn (n mut Network) fully_connect() {
	if n.hidden_layers.len == 0 {
		for i := 0; i < n.output_layers.len; i++ {
			mut out_layer := n.output_layers[i]
			for j := 0; j < n.input_layers.len; j++ {
				in_layer := n.input_layers[j]
				n.connect_layers(in_layer, mut out_layer, 'full')
			}
		}
	}
	else {
		for i := 0; i < n.input_layers.len; i++ {
			in_layer := n.input_layers[i]
			n.connect_layers(in_layer, mut n.hidden_layers[0], 'full')
		}
		for l := 0; l < n.hidden_layers.len; l++ {
			if (l + 1) == n.hidden_layers.len {
				continue
			}
			n.connect_layers(n.hidden_layers[l], mut n.hidden_layers[l + 1], 'full')
		}
		for i := 0; i < n.output_layers.len; i++ {
			n.connect_layers(n.hidden_layers[n.hidden_layers.len - 1], mut n.output_layers[i], 'full')
		}
	}
}

fn (n mut Network) connect_layers(src_layer &Layer, dest_layer mut Layer, connection_type string) {
	if !(connection_type in CONNECTION_TYPES) {
		panic('Invalid connection type')
	}
	match connection_type {
		'full' {
			dest_layer.weights = num.zeros([dest_layer.size(), src_layer.size()])
			for i := 0; i < src_layer.neurons.len; i++ {
				mut src_neuron := src_layer.neurons[i]
				for j := 0; j < dest_layer.neurons.len; j++ {
					mut dest_neuron := dest_layer.neurons[j]
					synapse := create_synapse(src_neuron, dest_neuron)
					src_neuron.synapses_out << synapse
					dest_neuron.synapses_in << synapse
					n.all_synapses << synapse
					dest_layer.weights.set([j, i], synapse.weight)
				}
			}
		}
		else {}
	}
}

pub fn (n &Network) log_summary(e int) {
	println('Epoch $e, Total error $n.total_error, MSE: $n.mse')
}

pub fn (n mut Network) run(input num.NdArray, show bool) num.NdArray {
	mut iter := input.iter()
	for i := 0; i < input.size; i++ {
		n.input_layers[0].neurons[i].activation = *iter.ptr
		iter.next()
	}
	for l in n.hidden_layers {
		for i := 0; i < l.neurons.len; i++ {
			mut neuron := l.neurons[i]
			neuron.activate(l.activation_function)
		}
	}
	for l in n.output_layers {
		for i := 0; i < l.neurons.len; i++ {
			mut neuron := l.neurons[i]
			neuron.activate(l.activation_function)
		}
	}
	last_out := n.output_layers[n.output_layers.len - 1].neurons
	ret_size := last_out.len
	out := num.empty([ret_size])
	for i, outneuron in last_out {
		out.set([i], outneuron.activation)
	}
	if show {
		println('Input -> $input, Output -> $out')
	}
	return out
}

fn (n mut Network) evaluate(input_data num.NdArray, expected_output num.NdArray, cost_function CostFunction) {
	actual_output := n.run(input_data, false)
	n.error_signal = []
	for i := 0; i < actual_output.size; i++ {
		mut neuron := n.output_layers[n.output_layers.len - 1].neurons[i]
		value,derivative := cost_function.call(expected_output.get([i]), actual_output.get([i]))
		neuron.gradient = derivative * neuron.sigma_prime
		n.error_signal << value
	}
	n.total_error = num.from_f64_1d(n.error_signal).sum()
}

fn (net mut Network) update_weights(learn_type string) {
	for i := 0; i < net.all_synapses.len; i++ {
		mut synapse := net.all_synapses[i]
		synapse.gradient = net.w_gradient[i]
		if learn_type == 'sgdm' {
			delta_weight := (-1.0) * net.learning_rate * synapse.gradient + net.momentum * (synapse.weight - synapse.prev_weight)
			synapse.weight += delta_weight
			synapse.prev_weight = synapse.weight
		}
		else if learn_type == 'rprop' {
			calc := synapse.prev_gradient * synapse.gradient
			if calc > 0 {
				delta := math.min(net.etah_plus * synapse.prev_delta, net.delta_max)
				delta_weight := -1.0 * num.sign_scalar(synapse.gradient) * delta
				synapse.weight += delta_weight
				synapse.prev_weight = synapse.weight
				synapse.prev_delta = delta
				synapse.prev_delta_w = delta_weight
			}
			else if calc < 0.0 {
				delta := math.max(net.etah_minus * synapse.prev_delta, net.delta_min)
				if net.mse >= net.prev_mse {
					synapse.weight -= synapse.prev_delta_w
				}
				synapse.prev_gradient = 0.0
				synapse.prev_delta = delta
			}
			else if calc == 0.0 {
				delta_weight := -1.0 * num.sign_scalar(synapse.gradient) * synapse.prev_delta
				synapse.weight += delta_weight
				synapse.prev_delta = net.delta_min
				synapse.prev_delta_w = delta_weight
			}
		}
		else if learn_type == 'adam' {
			synapse.m_current = net.beta1 * synapse.m_prev + (1.0 - net.beta1) * synapse.gradient
			synapse.v_current = net.beta2 * synapse.v_prev + (1.0 - net.beta2) * math.pow(synapse.gradient, 2)
			m_hat := synapse.m_current / (1.0 - math.pow(net.beta1, net.time_step))
			v_hat := synapse.v_current / (1.0 - math.pow(net.beta2, net.time_step))
			synapse.weight -= (net.alpha * m_hat) / (math.pow(v_hat, 0.5) + net.epsilon)
			synapse.m_prev = synapse.m_current
			synapse.v_prev = synapse.v_current
		}
	}
}

fn (net &Network) update_biases(learn_type string) {
	for i := 0; i < net.all_neurons.len; i++ {
		mut neuron := net.all_neurons[i]
		if learn_type == 'sgdm' {
			delta_bias := -1.0 * net.learning_rate * neuron.gradient + net.momentum * (neuron.bias - neuron.prev_bias)
			neuron.bias += delta_bias
			neuron.prev_bias = neuron.bias
		}
		else if learn_type == 'rprop' {
			calc := neuron.prev_gradient * neuron.gradient
			if calc > 0.0 {
				delta := math.min(net.etah_plus * neuron.prev_delta, net.delta_max)
				delta_bias := -1.0 * num.sign_scalar(neuron.gradient) * delta
				neuron.bias += delta_bias
				neuron.prev_bias = neuron.bias
				neuron.prev_delta = delta
				neuron.prev_delta_b = delta_bias
			}
			else if calc < 0.0 {
				delta := math.max(net.etah_minus * neuron.prev_delta, net.delta_min)
				if net.mse >= net.prev_mse {
					neuron.bias -= neuron.prev_delta_b
				}
				neuron.prev_bias = 0.0
				neuron.prev_delta = delta
			}
			else if calc == 0.0 {
				delta_bias := -1.0 * num.sign_scalar(neuron.gradient) * neuron.prev_delta
				neuron.bias += delta_bias
				neuron.prev_delta = net.delta_min
				neuron.prev_delta_b = delta_bias
			}
		}
		else if learn_type == 'adam' {
			neuron.m_current = net.beta1 * neuron.m_prev + (1.0 - net.beta1) * neuron.gradient
			neuron.v_current = net.beta2 * neuron.v_prev + (1.0 - net.beta2) * math.pow(neuron.gradient, 2)
			m_hat := neuron.m_current / (1.0 - math.pow(net.beta1, net.time_step))
			v_hat := neuron.v_current / (1.0 - math.pow(net.beta2, net.time_step))
			neuron.bias -= (net.alpha * m_hat) / (math.pow(v_hat, 0.5) + net.epsilon)
			neuron.m_prev = neuron.m_current
			neuron.v_prev = neuron.v_current
		}
	}
}

pub fn (net mut Network) train(input num.NdArray, output num.NdArray, training_type string, cost_function CostFunction, epochs int, error_threshold f64, log_each int, show_slice bool) {
	start_time := time.now()
	net.time_step = 0
	mut counter := 0
	for {
		if counter >= epochs || ((error_threshold >= net.mse) && (counter > 1)) {
			elapsed := time.now().unix - start_time.unix
			println('Training finished. (Elapsed: $elapsed)')
			break
		}
		if counter % log_each == 0 {
			net.log_summary(counter)
		}
		mut display_counter := 0
		mut epoch_mse := 0.0
		mut epoc_error_sum := [0.0].repeat(net.output_layers[net.output_layers.len - 1].neurons.len)
		mut mean := 0.0
		mut all_errors := 0.0
		net.w_gradient = [f64(0.0)].repeat(net.all_synapses.len)
		net.b_gradient = [f64(0.0)].repeat(net.all_neurons.len)
		mut input_iter := input.axis(0)
		mut output_iter := output.axis(0)
		for i := 0; i < input.shape[0]; i++ {
			inp := input_iter.next()
			outp := output_iter.next()
			net.evaluate(inp, outp, cost_function)
			all_errors += net.total_error
			for l in net.hidden_layers.reverse() {
				for j := 0; j < l.neurons.len; j++ {
					mut neuron := l.neurons[j]
					neuron.hidden_error_prop()
				}
			}
			for l in net.input_layers.reverse() {
				for j := 0; j < l.neurons.len; j++ {
					mut neuron := l.neurons[j]
					neuron.hidden_error_prop()
				}
			}
			for k := 0; k < net.all_synapses.len; k++ {
				synapse := net.all_synapses[k]
				net.w_gradient[k] += synapse.source_neuron.activation * synapse.dest_neuron.gradient
			}
			for k := 0; k < net.all_neurons.len; k++ {
				neuron := net.all_neurons[k]
				net.b_gradient[k] += neuron.gradient
			}
			error_avg := match (net.error_signal.len) {
				1{
					f64(0.0)
				}
				else {
					net.total_error / net.output_layers[net.output_layers.len - 1].neurons.len}
	}
			mut sqrd_dists := 0.0
			for e in net.error_signal {
				sqrd_dists += math.pow(e - error_avg, 2)
			}
			net.mse = sqrd_dists / net.output_layers[net.output_layers.len - 1].neurons.len
			mean += net.mse
		}
		net.total_error = all_errors
		net.mse = mean
		net.time_step++
		net.update_weights(training_type)
		net.update_biases(training_type)
		epoch_mse += net.mse
		for i := 0; i < net.error_signal.len; i++ {
			epoc_error_sum[i] += net.error_signal[i]
		}
		net.prev_mse = net.mse
		display_counter++
		net.mse = epoch_mse
		for i := 0; i < net.error_signal.len; i++ {
			net.error_signal[i] = epoc_error_sum[i]
		}
		counter++
	}
}
