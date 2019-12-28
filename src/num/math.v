module num

fn add_(a f64, b f64) f64 {
	return a + b
}

fn subtract_(a f64, b f64) f64 {
	return a - b
}

fn divide_(a f64, b f64) f64 {
	return a / b
}

fn multiply_(a f64, b f64) f64 {
	return a * b
}

fn minimum_(a f64, b f64) f64 {
	if a < b {
		return a
	}
	return b
}

fn maximum_(a f64, b f64) f64 {
	if a > b {
		return a
	}
	return b
}

fn op(a Tensor, b Tensor, op fn(f64, f64)f64) Tensor {
	ret := a.copy('C')
	mut ret_iter := ret.flat_iter()
	mut rhs_iter := b.flat_iter()
	mut ii := 0

	for ii < a.size {
		mut ptr := ret_iter.next()
		*ptr = op(*ptr, *rhs_iter.next())
		ii++
	}
	return ret
}

fn op_scalar(a Tensor, b f64, op fn(f64, f64)f64) Tensor {
	ret := a.copy('C')
	mut ret_iter := ret.flat_iter()
	mut ii := 0

	for ii < a.size {
		mut ptr := ret_iter.next()
		*ptr = op(*ptr, b)
		ii++
	}
	return ret
}

pub fn add(a Tensor, b Tensor) Tensor {
	return op(a, b, add_)
}

pub fn add_scalar(a Tensor, b f64) Tensor {
	return op_scalar(a, b, add_)
}

pub fn subtract(a Tensor, b Tensor) Tensor {
	return op(a, b, subtract_)
}

pub fn subtract_scalar(a Tensor, b f64) Tensor {
	return op_scalar(a, b, subtract_)
}

pub fn divide(a Tensor, b Tensor) Tensor {
	return op(a, b, divide_)
}

pub fn divide_scalar(a Tensor, b f64) Tensor {
	return op_scalar(a, b, divide_)
}

pub fn multiply(a Tensor, b Tensor) Tensor {
	return op(a, b, multiply_)
}

pub fn multiply_scalar(a Tensor, b f64) Tensor {
	return op_scalar(a, b, divide_)
}

pub fn minimum(a Tensor, b Tensor) Tensor {
	return op(a, b, minimum_)
}

pub fn maximum(a Tensor, b Tensor) Tensor {
	return op(a, b, maximum_)
}