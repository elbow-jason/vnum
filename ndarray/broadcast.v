module ndarray

import vnum.internal


// broadcastable takes two ndarrays as inputs, and finds the proper
// shape that they both broadcast to in order to find the proper output.
// This may require a change to the shapes of both tensors, so for assignment
// and in-place modification, only the right hand side should be broadcasted.
fn broadcastable(arr NdArray, other NdArray) []int {
	sz := arr.shape.len
	osz := other.shape.len
	if sz == osz {
		if broadcast_equal(arr.shape, other.shape) {
			return broadcastable_shape(arr.shape, other.shape)
		}
	}
	else {
		if sz > osz {
			mut othershape := [1].repeat(sz - osz)
			othershape << other.shape
			if broadcast_equal(arr.shape, othershape) {
				return broadcastable_shape(arr.shape, othershape)
			}
		}
		else {
			mut selfshape := [1].repeat(osz - sz)
			selfshape << arr.shape
			if broadcast_equal(selfshape, other.shape) {
				return broadcastable_shape(selfshape, other.shape)
			}
		}
	}
	panic('Shapes $arr.shape and $other.shape are not broadcastable')
}

// broadcast_equal checks two shapes, asserting that they can be broadcasted
// according to a couple basic rules: either they are equal or one is equal
// to 1
fn broadcast_equal(a []int, b []int) bool {
	mut bc := true
	for i, v in a {
		if !(v == b[i] || v == 1 || b[i] == 1) {
			bc = false
		}
	}
	return bc
}

// broadcasts_strides broadcasts the strides of an existing array into a new shape that it is able
// to be broadcast into.  Since a copy is not made, the new strides will
// be heavily dependent on the current memory layout of the existing array
// This will almost never result in a contiguous array
fn broadcast_strides(dest_shape []int, src_shape []int, dest_strides []int, src_strides []int) []int {
	dims := dest_shape.len
	start := dims - src_shape.len
	mut ret := [0].repeat(dims)
	mut i := dims - 1
	for i >= start {
		s := src_shape[i - start]
		if s == 1 {
			ret[i] = 0
		}
		else if s == dest_shape[i] {
			ret[i] = src_strides[i - start]
		}
		else {
			panic('Cannot broadcast from $src_shape to $dest_shape')
		}
		i--
	}
	return ret
}

// Returns the final broadcastable shape between two arrays of shapes
// This takes the maximum at each index of the two shapes, and
// the smaller dimension is where the broadcast occurs in
// the derived arrays.
fn broadcastable_shape(a []int, b []int) []int {
	mut ret := []int
	for i, aval in a {
		if aval > b[i] {
			ret << aval
		}
		else {
			ret << b[i]
		}
	}
	return ret
}

// broadcast_to broadcasts an ndarray to a new shape, panicking if
// the ndarray cannot be viewed as the new shape
pub fn broadcast_to(t NdArray, newshape []int) NdArray {
	defstrides := internal.cstrides(newshape)
	newstrides := broadcast_strides(newshape, t.shape, defstrides, t.strides)
	newflags := no_flags()
	return NdArray {
		buffer: t.buffer
		shape: newshape
		strides: newstrides
		flags: newflags
		size: internal.shape_size(newshape)
		ndims: newshape.len
	}
}

// as_strided as a highly unsafe method that views an array given
// an arbitrary shape and stride.  The result is not writeable, and
// many elements may share the same memory location.  Be very careful
// using this method, as using it incorrectly can lead to dangerous
// memory access.
pub fn as_strided(t NdArray, newshape []int, newstrides []int) NdArray {
	return NdArray {
		buffer: t.buffer
		shape: newshape
		strides: newstrides
		flags: no_flags()
		size: internal.shape_size(newshape)
		ndims: newshape.len
	}
}

// broadcast_arrays takes two input arrays, and if possible, broadcasts
// them into compatible shapes, returning the two modified arrays.
// No copies of data are made, that must be handled later.  If the arrays
// cannot be broadcast against each other, panic.
pub fn broadcast_arrays(a NdArray, b NdArray) (NdArray, NdArray) {
	if internal.array_equal(a.shape, b.shape) {
		return a, b
	}
	newshape := broadcastable(a, b)
	newa := match(internal.array_equal(a.shape, newshape)) {
		true { a }
		else { broadcast_to(a, newshape) }
	}
	newb := match(internal.array_equal(b.shape, newshape)) {
		true { b }
		else { broadcast_to(b, newshape) }
	}
	return newa, newb
}

pub fn expand_dims(a NdArray, axis int) NdArray {
	mut newshape := []int
	newaxis := match(axis < 0) {
		true { axis + a.ndims + 1 }
		else { axis }
	}
	newshape << a.shape[..newaxis]
	newshape << 1
	newshape << a.shape[newaxis..]
	return a.reshape(newshape)
}

pub fn broadcast_op(a NdArray, b NdArray, op fn(f64, f64)f64) NdArray {
	ba, bb := broadcast_arrays(a, b)
	ret := ba.copy('C')
	for iter := ret.iter_with(bb); !iter.done; iter.next() {
		*iter.ptr_a = op(*iter.ptr_a, *iter.ptr_b)
	}
	return ret
}

pub fn scalar_op(a NdArray, b f64, op fn(f64, f64)f64) NdArray {
	ret := a.copy('C')
	for iter := ret.iter(); !iter.done; iter.next() {
		*iter.ptr = op(*iter.ptr, b)
	}
	return ret
}

pub fn scalar_op_lhs(a NdArray, b f64, op fn(f64, f64)f64) NdArray {
	ret := a.copy('C')
	for iter := ret.iter(); !iter.done; iter.next() {
		*iter.ptr = op(b, *iter.ptr)
	}
	return ret	
}

pub fn apply(a NdArray, op fn(f64)f64) NdArray {
	ret := a.copy('C')
	for iter := ret.iter(); !iter.done; iter.next() {
		*iter.ptr = op(*iter.ptr)
	}
	return ret
}

pub fn op_outer(a NdArray, b NdArray, op fn(f64, f64)f64) NdArray {
	mut shape := a.shape.clone()
	shape << b.shape
	ret := allocate_ndarray(shape, 'C')
	mut iter := ret.iter()
	for i := a.iter(); !i.done; i.next() {
		for j := b.iter(); !j.done; j.next() {
			*iter.ptr = op(*i.ptr, *j.ptr)
			iter.next()
		}
	}
	return ret
}