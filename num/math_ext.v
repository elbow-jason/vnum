module num

import vnum.ndarray
import math
// acos(t)
pub fn acos(a ndarray.NdArray) ndarray.NdArray {
	return a.apply(math.cos)
}

// abs(t)
pub fn abs(a ndarray.NdArray) ndarray.NdArray {
	return a.apply(math.abs)
}

// asin(t)
pub fn asin(a ndarray.NdArray) ndarray.NdArray {
	return a.apply(math.asin)
}

// atan(t)
pub fn atan(a ndarray.NdArray) ndarray.NdArray {
	return a.apply(math.atan)
}

// atan2(t, t)
pub fn atan2(a ndarray.NdArray, b ndarray.NdArray) ndarray.NdArray {
	return ndarray.broadcast_op(a, b, math.atan2)
}

// atan2(t, 1)
pub fn atan2s(a ndarray.NdArray, b f64) ndarray.NdArray {
	return ndarray.scalar_op(a, b, math.atan2)
}

// atan2(1, t)
pub fn satan2(a f64, b ndarray.NdArray) ndarray.NdArray {
	return ndarray.scalar_op_lhs(b, a, math.atan2)
}

// atan2 outer t t
pub fn atan2_outer(a ndarray.NdArray, b ndarray.NdArray) ndarray.NdArray {
	return ndarray.op_outer(a, b, math.atan2)
}

// cbrt(t)
pub fn cbrt(a ndarray.NdArray) ndarray.NdArray {
	return a.apply(math.cbrt)
}

// ceil(t)
pub fn ceil(a ndarray.NdArray) ndarray.NdArray {
	return a.apply(math.ceil)
}

// cos(t)
pub fn cos(a ndarray.NdArray) ndarray.NdArray {
	return a.apply(math.cos)
}

// cosh(t)
pub fn cosh(a ndarray.NdArray) ndarray.NdArray {
	return a.apply(math.cosh)
}

// degrees(t)
pub fn degrees(a ndarray.NdArray) ndarray.NdArray {
	return a.apply(math.degrees)
}

// exp(t)
pub fn exp(a ndarray.NdArray) ndarray.NdArray {
	return a.apply(math.exp)
}

// erf(t)
pub fn erf(a ndarray.NdArray) ndarray.NdArray {
	return a.apply(math.erf)
}

// erfc(t)
pub fn erfc(a ndarray.NdArray) ndarray.NdArray {
	return a.apply(math.erfc)
}

// exp2(t)
pub fn exp2(a ndarray.NdArray) ndarray.NdArray {
	return a.apply(math.exp2)
}

// floor(t)
pub fn floor(a ndarray.NdArray) ndarray.NdArray {
	return a.apply(math.floor)
}

// fmod(t, t)
pub fn fmod(a ndarray.NdArray, b ndarray.NdArray) ndarray.NdArray {
	return ndarray.broadcast_op(a, b, math.fmod)
}

// fmod outer t t
pub fn fmod_outer(a ndarray.NdArray, b ndarray.NdArray) ndarray.NdArray {
	return ndarray.op_outer(a, b, math.fmod)
}

// fmod(t, 1)
pub fn fmods(a ndarray.NdArray, b f64) ndarray.NdArray {
	return ndarray.scalar_op(a, b, math.fmod)
}

// fmod(1, t)
pub fn scalar_fmod(a f64, b ndarray.NdArray) ndarray.NdArray {
	return ndarray.scalar_op_lhs(b, a, math.fmod)
}

// gamma(t)
pub fn gamma(a ndarray.NdArray) ndarray.NdArray {
	return a.apply(math.gamma)
}

// log(t)
pub fn log(a ndarray.NdArray) ndarray.NdArray {
	return a.apply(math.log)
}

// log2(t)
pub fn log2(a ndarray.NdArray) ndarray.NdArray {
	return a.apply(math.log2)
}

// log10(t)
pub fn log10(a ndarray.NdArray) ndarray.NdArray {
	return a.apply(math.log10)
}

// lgamma(t)
pub fn lgamma(a ndarray.NdArray) ndarray.NdArray {
	return a.apply(math.log_gamma)
}

// logn(t)
pub fn logn(a ndarray.NdArray, b ndarray.NdArray) ndarray.NdArray {
	return ndarray.broadcast_op(a, b, math.log_n)
}

// logn outer t t
pub fn logn_outer(a ndarray.NdArray, b ndarray.NdArray) ndarray.NdArray {
	return ndarray.op_outer(a, b, math.log_n)
}

// logn(t, 1)
pub fn logns(a ndarray.NdArray, b f64) ndarray.NdArray {
	return ndarray.scalar_op(a, b, math.log_n)
}

// logn(1, t)
pub fn slogn(a f64, b ndarray.NdArray) ndarray.NdArray {
	return ndarray.scalar_op_lhs(b, a, math.log_n)
}

// pow(t, t)
pub fn pow(a ndarray.NdArray, b ndarray.NdArray) ndarray.NdArray {
	return ndarray.broadcast_op(a, b, math.pow)
}

// pow(t, 2)
pub fn pows(a ndarray.NdArray, b f64) ndarray.NdArray {
	return ndarray.scalar_op(a, b, math.pow)
}

// pow(2, t)
pub fn spow(a f64, b ndarray.NdArray) ndarray.NdArray {
	return ndarray.scalar_op_lhs(b, a, math.pow)
}

// pow_outer(t, t)
pub fn pow_outer(a ndarray.NdArray, b ndarray.NdArray) ndarray.NdArray {
	return ndarray.op_outer(a, b, math.pow)
}

// radians(t)
pub fn radians(a ndarray.NdArray) ndarray.NdArray {
	return a.apply(math.radians)
}

// round(t)
pub fn round(a ndarray.NdArray) ndarray.NdArray {
	return a.apply(math.round)
}

// sin(t)
pub fn sin(a ndarray.NdArray) ndarray.NdArray {
	return a.apply(math.sin)
}

// sinh(t)
pub fn sinh(a ndarray.NdArray) ndarray.NdArray {
	return a.apply(math.sinh)
}

// sqrt(t)
pub fn sqrt(a ndarray.NdArray) ndarray.NdArray {
	return a.apply(math.sqrt)
}

// tan(t)
pub fn tan(a ndarray.NdArray) ndarray.NdArray {
	return a.apply(math.tan)
}

// tanh(t)
pub fn tanh(a ndarray.NdArray) ndarray.NdArray {
	return a.apply(math.tanh)
}
