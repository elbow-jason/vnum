module ndarray

import math

fn offset(n NdArray, idx []int) int {
	mut offset := 0
	for i, stride in n.strides {
		mut idxer := idx[i]
		if idxer < 0 {
			idxer += n.shape[i]
		}
		offset += idxer * stride
	}
	return offset
}

fn offset_ptr(ptr &f64, shape []int, strides []int) &f64 {
	mut ret := ptr
	for i := 0; i < shape.len; i++ {
		if strides[i] < 0 {
			ret += (shape[i] - 1) * int(math.abs(strides[i]))
		}
	}
	return ret
}

fn assert_shape_off_axis(ts []NdArray, axis int, shape []int) []int {
	mut retshape := shape.clone()
	for t in ts {
		if (t.shape.len != retshape.len) {
			panic('All inputs must share the same number of axes')
		}
		mut i := 0
		for i < shape.len {
			if (i != axis) && (t.shape[i] != shape[i]) {
				panic('All inputs must share a shape off axis')
			}
			i++
		}
		retshape[axis] += t.shape[axis]
	}
	return retshape
}

fn pad_with_zeros(pad []int, ndims int) []int {
	diff := ndims - pad.len
	mut newpad := pad.clone()
	mut i := 0
	for i < diff {
		newpad << 0
		i++
	}
	return newpad
}

fn pad_with_max(pad []int, shape []int, ndims int) []int {
	mut newpad := pad.clone()
	diff := ndims - pad.len
	if diff > 0 {
		newpad << shape[pad.len..]
	}
	return newpad
}

fn shape_min(shape []int) int {
	mut mn := 0
	for i, dim in shape {
		if i == 0 {
			mn = dim
		}
		if dim < mn {
			mn = dim
		}
	}
	return mn
}

fn shape_sum(shape []int) int {
	mut ret := 0
	for i in shape {
		ret += i
	}
	return ret
}

pub fn range(start int, stop int) []int {
	mut ret := []int
	for i in start .. stop {
		ret << i
	}
	return ret
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
