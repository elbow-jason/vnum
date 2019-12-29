module num

import base

fn squash_warning_math() {
	base.allocate_tensor([1])
}

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

fn op(a base.Tensor, b base.Tensor, op fn(f64, f64)f64) base.Tensor {
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

fn op_scalar(a base.Tensor, b f64, op fn(f64, f64)f64) base.Tensor {
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

pub fn add(a base.Tensor, b base.Tensor) base.Tensor {
	return op(a, b, add_)
}

pub fn add_scalar(a base.Tensor, b f64) base.Tensor {
	return op_scalar(a, b, add_)
}

pub fn subtract(a base.Tensor, b base.Tensor) base.Tensor {
	return op(a, b, subtract_)
}

pub fn subtract_scalar(a base.Tensor, b f64) base.Tensor {
	return op_scalar(a, b, subtract_)
}

pub fn divide(a base.Tensor, b base.Tensor) base.Tensor {
	return op(a, b, divide_)
}

pub fn divide_scalar(a base.Tensor, b f64) base.Tensor {
	return op_scalar(a, b, divide_)
}

pub fn multiply(a base.Tensor, b base.Tensor) base.Tensor {
	return op(a, b, multiply_)
}

pub fn multiply_scalar(a base.Tensor, b f64) base.Tensor {
	return op_scalar(a, b, multiply_)
}

pub fn minimum(a base.Tensor, b base.Tensor) base.Tensor {
	return op(a, b, minimum_)
}

pub fn maximum(a base.Tensor, b base.Tensor) base.Tensor {
	return op(a, b, maximum_)
}
