module num

import vnum.ndarray
// concatenate joins a sequence of arrays along an existing axis. // The arrays must have the same shape, except in the dimension // corresponding to axis.
pub fn concatenate(ts []ndarray.NdArray, axis int) ndarray.NdArray {
	return ndarray.concatenate(ts, axis)
}

// Stack arrays in sequence vertically (row wise). //  // This is equivalent to concatenation along the first axis after 1-D arrays of // shape (N,) have been reshaped to (1,N). Rebuilds arrays divided by vsplit. //  // This function makes most sense for arrays with up to 3 dimensions. // For instance, for pixel-data with a height (first axis), width (second axis), // and r/g/b channels (third axis). The functions concatenate and stack // provide more general stacking and concatenation operations.
pub fn vstack(ts []ndarray.NdArray) ndarray.NdArray {
	return concatenate(ts, 0)
}

// Stack arrays in sequence horizontally (column wise). //  // This is equivalent to concatenation along the second axis, // except for 1-D arrays where it concatenates along the first axis. // Rebuilds arrays divided by hsplit. //  // This function makes most sense for arrays with up to 3 dimensions. // For instance, for pixel-data with a height (first axis), width (second axis), // and r/g/b channels (third axis). The functions concatenate and stack // provide more general stacking and concatenation operations.
pub fn hstack(ts []ndarray.NdArray) ndarray.NdArray {
	return concatenate(ts, 1)
}

// Stack arrays in sequence depth wise (along third axis). // This is equivalent to concatenation along the third axis after 2-D arrays // of shape (M,N) have been reshaped to (M,N,1) and 1-D arrays of shape // (N,) have been reshaped to (1,N,1). Rebuilds arrays divided by dsplit. //  // This function makes most sense for arrays with up to 3 dimensions. // For instance, for pixel-data with a height (first axis), width (second axis), // and r/g/b channels (third axis). The functions concatenate and stack // provide more general stacking and concatenation operations.
pub fn dstack(ts []ndarray.NdArray) ndarray.NdArray {
	assert_all_1d(ts)
	first := ts[0]
	assert_shape(first.shape, ts)
	if first.ndims > 2 {
		panic('dstack was given arrays with more than two dimensions')
	}
	if first.ndims == 1 {
		arrs := ts.map(it.reshape([1, it.size, 1]))
		return concatenate(arrs, 2)
	}
	else {
		mut arrs := []ndarray.NdArray
		for t in ts {
			mut newshape := t.shape.clone()
			newshape << 1
			arrs << t.reshape(newshape)
		}
		return concatenate(arrs, 2)
	}
}

// Stack 1-D arrays as columns into a 2-D array. //  // Take a sequence of 1-D arrays and stack them as columns to make a single 2-D array. // 2-D arrays are stacked as-is, just like with hstack. // 1-D arrays are turned into 2-D columns first.
pub fn column_stack(ts []ndarray.NdArray) ndarray.NdArray {
	assert_all_1d(ts)
	first := ts[0]
	assert_shape(first.shape, ts)
	if first.ndims > 2 {
		panic('column_stack was given arrays with more than two dimensions')
	}
	if first.ndims == 1 {
		arrs := ts.map(it.reshape([it.size, 1]))
		return concatenate(arrs, 1)
	}
	else {
		return concatenate(ts, 1)
	}
}

// Join a sequence of arrays along a new axis.
// The axis parameter specifies the index of the new axis in the dimensions // of the result. For example, if axis=0 it will be the first dimension // and if axis=-1 it will be the last dimension.
pub fn stack(ts []ndarray.NdArray, axis int) ndarray.NdArray {
	assert_shape(ts[0].shape, ts)
	assert_all_1d(ts)
	expanded := ts.map(ndarray.expand_dims(it, axis))
	return concatenate(expanded, axis)
}

pub fn atleast_2d(a ndarray.NdArray) ndarray.NdArray {
	dim := 2 - a.ndims
	if dim > 0 {
		mut pad := [1].repeat(dim)
		pad << a.shape
		return a.reshape(pad)
	}
	return a
}
