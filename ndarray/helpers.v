module ndarray

import math
import vnum.internal
// offset finds the proper offset for an ndarray given
// and indexer and the strides of the ndarray
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

// offset_ptr updates the pointer of an ndarray to account for
// negative strides.
fn offset_ptr(ptr &f64, shape []int, strides []int) &f64 {
	mut ret := ptr
	for i := 0; i < shape.len; i++ {
		if strides[i] < 0 {
			ret += (shape[i] - 1) * int(math.abs(strides[i]))
		}
	}
	return ret
}

// assert_shape_off_axis ensures that the shapes of ndarrays match
// for concatenation, except along the axis being joined.
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

// pad_with_zeros pads a shape with zeros to support an indexing
// operation
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

// pad_with_max pads a shape with the maximum axis value to support
// an indexing operation
fn pad_with_max(pad []int, shape []int, ndims int) []int {
	mut newpad := pad.clone()
	diff := ndims - pad.len
	if diff > 0 {
		newpad << shape[pad.len..]
	}
	return newpad
}

// shape_min returns the minimum value from the shape of an ndarray
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

// shape_sum sums a shape to get the total size of dimensions in
// an ndarray
fn shape_sum(shape []int) int {
	mut ret := 0
	for i in shape {
		ret += i
	}
	return ret
}

// range returns an array between start and stop, incremented by
// 1
pub fn range(start int, stop int) []int {
	mut ret := []int
	for i in start .. stop {
		ret << i
	}
	return ret
}

// add_ adds two floats, used as a callback for ndarray
// operations
fn add_(a f64, b f64) f64 {
	return a + b
}

// subtract_ subtracts two floats, used as a callback for ndarray
// operations
fn subtract_(a f64, b f64) f64 {
	return a - b
}

// divide_ divides two floats, used as a callback for ndarray
// operations
fn divide_(a f64, b f64) f64 {
	return a / b
}

// multiply_ multiplies two floats, used as a callback for ndarray
// operations
fn multiply_(a f64, b f64) f64 {
	return a * b
}

// checks if two floating point ndarrays are close within a tolerance
pub fn allclose(a NdArray, b NdArray) bool {
	rtol := 1e-5
	atol := 1e-8
	if !internal.array_equal(a.shape, b.shape) {
		panic('Shapes must be equal')
	}
	else {
		for iter := a.with_inpl(b); !iter.done; iter.next() {
			i := *iter.ptr_a
			j := *iter.ptr_b
			if math.abs(i - j) > (atol + rtol * math.abs(j)) {
				return false
			}
		}
	}
	return true
}
