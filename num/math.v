module num

import base
import math

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

fn power_(a f64, b f64) f64 {
	return math.pow(a, b)
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

fn op1d(a base.Tensor, op fn(f64)f64) base.Tensor {
	ret := a.copy('C')
	mut ret_iter := ret.flat_iter()
	for i := 0; i < a.size; i++ {
		mut ptr := ret_iter.next()
		*ptr = op(*ptr)
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

pub fn minimum_scalar(a base.Tensor, b f64) base.Tensor {
	return op_scalar(a, b, minimum_)
}

pub fn maximum(a base.Tensor, b base.Tensor) base.Tensor {
	return op(a, b, maximum_)
}

pub fn maximum_scalar(a base.Tensor, b f64) base.Tensor {
	return op_scalar(a, b, maximum_)
}

pub fn acos(a base.Tensor) base.Tensor {
	return op1d(a, math.acos)
}

pub fn abs(a base.Tensor) base.Tensor {
	return op1d(a, math.abs)
}

pub fn asin(a base.Tensor) base.Tensor {
	return op1d(a, math.asin)
}

pub fn atan(a base.Tensor) base.Tensor {
	return op1d(a, math.atan)
}

pub fn atan2(a base.Tensor, b base.Tensor) base.Tensor {
	return op(a, b, math.atan2)
}

pub fn atan2_scalar(a base.Tensor, b f64) base.Tensor {
	return op_scalar(a, b, math.atan2)
}

pub fn cbrt(a base.Tensor) base.Tensor {
	return op1d(a, math.cbrt)
}

pub fn ceil(a base.Tensor) base.Tensor {
	return op1d(a, math.ceil)
}

pub fn cos(a base.Tensor) base.Tensor {
	return op1d(a, math.cos)
}

pub fn cosh(a base.Tensor) base.Tensor {
	return op1d(a, math.cosh)
}

pub fn degrees(a base.Tensor) base.Tensor {
	return op1d(a, math.degrees)
}

pub fn exp(a base.Tensor) base.Tensor {
	return op1d(a, math.exp)
}

pub fn erf(a base.Tensor) base.Tensor {
	return op1d(a, math.erf)
}

pub fn erfc(a base.Tensor) base.Tensor {
	return op1d(a, math.erfc)
}

pub fn exp2(a base.Tensor) base.Tensor {
	return op1d(a, math.exp2)
}

pub fn floor(a base.Tensor) base.Tensor {
	return op1d(a, math.floor)
}

pub fn fmod(a base.Tensor, b base.Tensor) base.Tensor {
	return op(a, b, math.fmod)
}

pub fn fmod_scalar(a base.Tensor, b f64) base.Tensor {
	return op_scalar(a, b, math.fmod)
}

pub fn gamma(a base.Tensor) base.Tensor {
	return op1d(a, math.gamma)
}

pub fn log(a base.Tensor) base.Tensor {
	return op1d(a, math.log)
}

pub fn log2(a base.Tensor) base.Tensor {
	return op1d(a, math.log2)
}

pub fn log10(a base.Tensor) base.Tensor {
	return op1d(a, math.log10)
}

pub fn lgamma(a base.Tensor) base.Tensor {
	return op1d(a, math.log_gamma)
}

pub fn logn(a base.Tensor, b base.Tensor) base.Tensor {
	return op(a, b, math.log_n)
}

pub fn logn_scalar(a base.Tensor, b f64) base.Tensor {
	return op_scalar(a, b, math.log_n)
}

pub fn pow(a base.Tensor, b base.Tensor) base.Tensor {
	return op(a, b, math.pow)
}

pub fn pow_scalar(a base.Tensor, b f64) base.Tensor {
	return op_scalar(a, b, math.pow)
}

pub fn radians(a base.Tensor) base.Tensor {
	return op1d(a, math.radians)
}

pub fn round(a base.Tensor) base.Tensor {
	return op1d(a, math.round)
}

pub fn sin(a base.Tensor) base.Tensor {
	return op1d(a, math.sin)
}

pub fn sinh(a base.Tensor) base.Tensor {
	return op1d(a, math.sinh)
}

pub fn sqrt(a base.Tensor) base.Tensor {
	return op1d(a, math.sqrt)
}

pub fn tan(a base.Tensor) base.Tensor {
	return op1d(a, math.tan)
}

pub fn tanh(a base.Tensor) base.Tensor {
	return op1d(a, math.tanh)
}
