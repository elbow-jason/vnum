module basenew

import math.complex
import math
import vnum.internal

pub struct NdArrayComplex {
pub mut:
	shape    []int
	strides  []int
	ndims    int
	size     int
	flags    ArrayFlags
pub:
	buffer   &complex.Complex
}

pub fn (t NdArrayComplex) get(idx []int) complex.Complex {
	mut buf := t.buffer
	for i := 0; i < t.ndims; i++ {
		if t.strides[i] < 0 {
			buf += (t.shape[i] - 1) * int(math.abs(t.strides[i]))
		}
	}
	return *(buf + offset(t.shape, t.strides, idx))
}

pub fn (t NdArrayComplex) set(idx []int, val complex.Complex) {
	mut buf := t.buffer
	for i := 0; i < t.ndims; i++ {
		if t.strides[i] < 0 {
			buf += (t.shape[i] - 1) * int(math.abs(t.strides[i]))
		}
	}
	mut ptr := buf + offset(t.shape, t.strides, idx)
	*ptr = val
}