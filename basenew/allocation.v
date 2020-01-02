module basenew

import vnum.internal
import math.complex

pub fn allocate_ndarray_complex(shape []int, order string) NdArrayComplex {
	size := internal.shape_size(shape)
	mut strides := []int
	if order == 'C' {
		strides = internal.cstrides(shape)
	} else if order == 'F' {
		strides = internal.fstrides(shape)
	} else {
		panic("Bad order")
	}
	return NdArrayComplex {
		shape: shape,
		strides: strides,
		ndims: shape.len,
		size: size,
		flags: default_flags(order),
		buffer: *complex.Complex(calloc(size * sizeof(complex.Complex)))
	}
}