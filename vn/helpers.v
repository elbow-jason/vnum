module vn

import vnum.ndarray
import vnum.internal

fn assert_all_1d(arrs []ndarray.NdArray) {
	for arr in arrs {
		if arr.ndims != 1 {
			panic("All arrays must be one dimensional")
		}
	}
}

fn assert_shape(shape []int, arrs []ndarray.NdArray) {
	for arr in arrs {
		if !internal.array_equal(shape, arr.shape) {
			panic("All shapes must be equal")
		}
	}
}