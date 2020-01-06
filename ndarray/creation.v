module ndarray

import vnum.internal
// allocate_ndarray Low level allocation method that takes an arbitrary
// shape, and a memory order for the underlying array, and returns an empty
// ndarray.
pub fn allocate_ndarray(shape []int, order string) NdArray {
	size := internal.shape_size(shape)
	strides := match (order) {
		'C'{
			internal.cstrides(shape)
		}
		else {
			internal.fstrides(shape)}
	}
	return NdArray{
		shape: shape
		strides: strides
		ndims: shape.len
		size: size
		flags: default_flags(order)
		buffer: *f64(calloc(size * sizeof(f64)))
	}
}

// from_f64 takes a one dimensional array of floating point values
// and coerces it into an arbitrary shaped ndarray if possible.
// Panics if the shape provided does not hold the provided array
pub fn from_f64(a []f64, shape []int) NdArray {
	data := a.clone().data
	size := internal.shape_size(shape)
	if size != a.len {
		panic('Bad shape for array, shape [$a.len] cannot fit into shape $shape')
	}
	return NdArray{
		buffer: data
		size: size
		ndims: shape.len
		strides: internal.cstrides(shape)
		shape: shape
		flags: default_flags('C')
	}
}

// from_f64_1d takes a one dimensional array of floating point values
// and returns a one dimensional ndarray if possible.
pub fn from_f64_1d(a []f64) NdArray {
	return from_f64(a, [a.len])
}

// from_f64_2d takes a two dimensional array of floating point values
// and returns a two-dimensional ndarray if possible
pub fn from_f64_2d(a [][]f64) NdArray {
	ret := allocate_ndarray([a.len, a[0].len], 'C')
	mut iter := ret.iter()
	for i := 0; i < a.len; i++ {
		for j := 0; j < a[0].len; j++ {
			*iter.ptr = a[i][j]
			iter.next()
		}
	}
	return ret
}

// from_f32 takes a one dimensional array of floating point values
// and coerces it into an arbitrary shaped ndarray if possible.
// Panics if the shape provided does not hold the provided array
pub fn from_f32(a []f32, shape []int) NdArray {
	data := a.map(f64(it)).data
	size := internal.shape_size(shape)
	if size != a.len {
		panic('Bad shape for array, shape [$a.len] cannot fit into shape $shape')
	}
	return NdArray{
		buffer: data
		size: size
		ndims: shape.len
		strides: internal.cstrides(shape)
		shape: shape
		flags: default_flags('C')
	}
}

// from_f32_1d takes a one dimensional array of floating point values
// and returns a one dimensional ndarray if possible.
pub fn from_f32_1d(a []f32) NdArray {
	ret := a.map(f64(it))
	return NdArray{
		buffer: ret.data
		size: a.len
		ndims: 1
		flags: default_flags('C')
		strides: [1]
		shape: [a.len]
	}
}

// from_f32_2d takes a two dimensional array of floating point values
// and returns a two-dimensional ndarray if possible
pub fn from_f32_2d(a [][]f32) NdArray {
	ret := allocate_ndarray([a.len, a[0].len], 'C')
	mut iter := ret.iter()
	for i := 0; i < a.len; i++ {
		for j := 0; j < a[0].len; j++ {
			*iter.ptr = f64(a[i][j])
			iter.next()
		}
	}
	return ret
}

// from_int takes a one dimensional array of uinteger values
// and coerces it into an arbitrary shaped ndarray if possible.
// Panics if the shape provided does not hold the provided array
pub fn from_int(a []int, shape []int) NdArray {
	data := a.map(f64(it)).data
	size := internal.shape_size(shape)
	if size != a.len {
		panic('Bad shape for array, shape [$a.len] cannot fit into shape $shape')
	}
	return NdArray{
		buffer: data
		size: size
		ndims: shape.len
		strides: internal.cstrides(shape)
		shape: shape
		flags: default_flags('C')
	}
}

// from_int_1d takes a one dimensional array of integer values
// and returns a one dimensional ndarray if possible.
pub fn from_int_1d(a []int) NdArray {
	ret := a.map(f64(it))
	return NdArray{
		buffer: ret.data
		size: a.len
		ndims: 1
		flags: default_flags('C')
		strides: [1]
		shape: [a.len]
	}
}

// from_int_2d takes a two dimensional array of integer values
// and returns a two-dimensional ndarray if possible
pub fn from_int_2d(a [][]int) NdArray {
	ret := allocate_ndarray([a.len, a[0].len], 'C')
	mut iter := ret.iter()
	for i := 0; i < a.len; i++ {
		for j := 0; j < a[0].len; j++ {
			*iter.ptr = f64(a[i][j])
			iter.next()
		}
	}
	return ret
}
