module ml

struct Synapse {
pub mut:
	id             string
	source_neuron  &Neuron
	dest_neuron    &Neuron
	weight         f64
	gradient       f64
	gradient_sum   f64
	gradient_batch f64
	prev_weight    f64
	prev_gradient  f64
	prev_delta     f64
	prev_delta_w   f64
	m_current      f64
	v_current      f64
	m_prev         f64
	v_prev         f64
}

pub fn create_synapse(source &Neuron, dest &Neuron) &Synapse {
	return &Synapse{
		source_neuron: source
		dest_neuron: dest
		weight: rand_between(-0.1, 0.1)
		gradient: rand_between(-0.1, 0.1)
		gradient_sum: 0.0
		gradient_batch: 0.0
		prev_weight: 0.0
		prev_gradient: 0.0
		prev_delta: 0.1
		prev_delta_w: 0.1
		m_current: 0.0
		v_current: 0.0
		m_prev: 0.0
		v_prev: 0.0
	}
}

pub fn (s &Synapse) propogate_forward() f64 {
	mem := s.source_neuron.activation * s.weight
	typ := s.source_neuron.n_type
	if typ == 'memory' {
		return mem
	}
	else if typ == 'eraser' {
		return -1.0 * mem
	}
	else {
		panic('Unsupported neuron type')
	}
}

pub fn (s &Synapse) propogate_backwards() f64 {
	return s.dest_neuron.gradient * s.weight
}

pub fn (s mut Synapse) randomize_weight() {
	s.weight = rand_between(-0.1, 0.1)
}

pub fn (s Synapse) str() string {
	mut t := ''
	t += 'Weight : $s.weight\n'
	t += 'Source_Neuron:\n$s.source_neuron\n'
	t += 'Dest Neuron:\n$s.dest_neuron\n'
	return t
}
