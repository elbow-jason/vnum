module num

import vnum.ndarray
// Return a new array of given shape and type, // without initializing entries.
pub fn empty(shape []int) ndarray.NdArray {
	return ndarray.allocate_ndarray(shape, 'C')
}

// Return a new array with the same shape and type as a // given array.
pub fn empty_like(t ndarray.NdArray) ndarray.NdArray {
	return empty(t.shape)
}

// Return a 2-D array with ones on the diagonal and zeros elsewhere.
pub fn eye(m int, n int, k int) ndarray.NdArray {
	ret := zeros([m, n])
	mut iter := ret.iter()
	for i := 0; i < m; i++ {
		for j := 0; j < n; j++ {
			if i == j - k {
				*iter.ptr = f64(1.0)
			}
			iter.next()
		}
	}
	return ret
}

// Return the identity array. //  // The identity array is a square array with ones on the main diagonal.
pub fn identity(n int) ndarray.NdArray {
	return eye(n, n, 0)
}

// Return a new array of given shape and type, filled with fill_value.
pub fn full(shape []int, val f64) ndarray.NdArray {
	ret := empty(shape)
	for iter := ret.iter(); !iter.done; iter.next() {
		*iter.ptr = val
	}
	return ret
}

// Return a full array with the same shape and type as a given array.
pub fn full_like(t ndarray.NdArray, val f64) ndarray.NdArray {
	return full(t.shape, val)
}

// Return a new array of given shape and type, filled with zeros.
pub fn zeros(shape []int) ndarray.NdArray {
	return full(shape, 0.0)
}

// Return an array of zeros with the same shape and type as a given array.
pub fn zeros_like(t ndarray.NdArray) ndarray.NdArray {
	return zeros(t.shape)
}

// Return a new array of given shape and type, filled with ones.
pub fn ones(shape []int) ndarray.NdArray {
	return full(shape, 1.0)
}

// Return an array of ones with the same shape and type as a given array.
pub fn ones_like(t ndarray.NdArray) ndarray.NdArray {
	return full(t.shape, 0.0)
}
