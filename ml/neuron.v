module ml

pub const (
	NEURON_TYPES = ['memory', 'eraser', 'amplifier', 'fader', 'sensor']
)

struct Neuron {
pub mut:
	n_type         string
	id             string
	synapses_in    []string
	synapses_out   []string
	activation     f64
	gradient       f64
	bias           f64
	prev_bias      f64
	input_sum      f64
	sigma_prime    f64
	gradient_sum   f64
	gradeint_batch f64
	prev_gradient  f64
	prev_delta     f64
	prev_delta_b   f64
	m_current      f64
	v_current      f64
	m_prev         f64
	v_prev         f64
}

pub fn create_neuron(n_type string) Neuron {
	return Neuron{
		n_type: n_type
		id: rand_id()
		synapses_in: []
		synapses_out: []
		activation: 0.0
		gradient: 0.0
		bias: rand_between(-1.0, 1.0)
		prev_bias: rand_between(-1.0, 1.0)
		input_sum: 0.0
		sigma_prime: 1.0
		gradient_sum: 0.0
		gradeint_batch: 0.0
		prev_gradient: rand_between(-0.1, 0.1)
		prev_delta: rand_between(0.0, 0.1)
		prev_delta_b: rand_between(-0.1, 0.1)
		m_current: 0.0
		v_current: 0.0
		m_prev: 0.0
		v_prev: 0.0
	}
}

pub fn (n Neuron) str() string {
	mut s := ''
	s += 'Neuron Type: $n.n_type\n'
	s += 'Activation:  $n.activation\n'
	s += 'Gradient:    $n.gradient\n'
	s += 'Sigma Prime: $n.sigma_prime'
	return s
}

pub fn (n mut Neuron) randomize_bias() {
	n.bias = rand_between(-1.0, 1.0)
}

pub fn (n mut Neuron) update_bias(value f64) {
	n.bias = value
}

pub fn (n mut Neuron) activate(activation_function ActivationFunction, synapse_map map[string]Synapse, neuron_map map[string]Neuron) {
	mut sum := 0.0
	for i in n.synapses_in {
		sum += synapse_map[i].propogate_forward(neuron_map)
	}
	n.input_sum = sum + n.bias
	activation, sigma_prime := activation_function.call(n.input_sum)
	n.activation = activation
	n.sigma_prime = sigma_prime
}

pub fn (n mut Neuron) hidden_error_prop(synapse_map map[string]Synapse, neuron_map map[string]Neuron) {
	mut weighted_error_sum := 0.0
	for synapse in n.synapses_out {
		weighted_error_sum += synapse_map[synapse].propogate_backwards(neuron_map)
	}
	n.gradient = weighted_error_sum * n.sigma_prime
}
