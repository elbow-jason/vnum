module ndarray

import vnum.internal
import math

// The core array object.  Contains information about the memory
// layout of data (flags), as well as the shape and strides describing
// how to iterate over data.
pub struct NdArray {
pub mut:
	shape   []int
	strides []int
	ndims   int
	size    int
	flags   ArrayFlags
pub:
	buffer  &f64
}


// get gets a scalar value from an ndarray at a given index
pub fn (t NdArray) get(idx []int) f64 {
	mut buf := t.buffer
	for i := 0; i < t.ndims; i++ {
		if t.strides[i] < 0 {
			buf += (t.shape[i] - 1) * int(math.abs(t.strides[i]))
		}
	}
	return *(buf + offset(t, idx))
}

// set sets a provided index to a provided scalar value in an
// ndarray
pub fn (t NdArray) set(idx []int, val f64) {
	mut buf := t.buffer
	for i := 0; i < t.ndims; i++ {
		if t.strides[i] < 0 {
			buf += (t.shape[i] - 1) * int(math.abs(t.strides[i]))
		}
	}
	mut ptr := buf + offset(t, idx)
	*ptr = val
}

// slice returns a view of an ndarray from a variadic list
// of indexing operations.  The returned view does not
// own its new data, but shares data with another ndarray
pub fn (t NdArray) slice(idx ...[]int) NdArray {
	mut newshape := t.shape.clone()
	mut newstrides := t.strides.clone()
	newflags := default_flags('C')
	mut indexer := []int
	for i, dex in idx {
		mut fi := 0
		mut li := 0
		if dex.len == 1 {
			newshape[i] = 0
			newstrides[i] = 0
			fi = dex[0]
			if fi < 0 {
				fi += t.shape[i]
			}
			indexer << fi
		}
		else if dex.len == 2 {
			fi = dex[0]
			li = dex[1]
			if fi < 0 {
				fi += t.shape[i]
			}
			if li < 0 {
				li += t.shape[i]
			}
			if fi == li {
				newshape[i] = 0
				newstrides[i] = 0
				indexer << fi
			}
			else {
				newshape[i] = li - fi
			}
		}
		else if dex.len == 3 {
			fi = dex[0]
			li = dex[1]
			step := dex[2]
			abstep := int(math.abs(step))
			if fi < 0 {
				fi += t.shape[i]
			}
			if li < 0 {
				li += t.shape[i]
			}
			offset := li - fi
			newshape[i] = offset / abstep + offset % abstep
			newstrides[i] = step * newstrides[i]
			indexer << fi
		}
	}
	newshape_,newstrides_ := internal.filter_shape_not_strides(newshape, newstrides)
	mut ptr := t.buffer
	mut i := 0
	for i < indexer.len {
		ptr += t.strides[i] * indexer[i]
		i++
	}
	mut ret := NdArray{
		shape: newshape_
		strides: newstrides_
		ndims: newshape_.len
		size: internal.shape_size(newshape_)
		buffer: ptr
		flags: newflags
	}
	ret.update_flags(all_flags())
	return ret
}

// slice_hilo returns a view of an array from a list of starting
// indices and a list of closing indices.  This is slightly less
// general than slice, but is used for internal methods since
// it doesn't use variadic arguments.  This method will be used
// until V has better support for 2D arrays.
pub fn (t NdArray) slice_hilo(idx1 []int, idx2 []int) NdArray {
	mut newshape := t.shape.clone()
	mut newstrides := t.strides.clone()
	newflags := default_flags('C')
	mut ii := 0
	idx_start := pad_with_zeros(idx1, t.ndims)
	idx_end := pad_with_max(idx2, t.shape, t.ndims)
	mut idx := []int
	for ii < t.ndims {
		mut fi := idx_start[ii]
		if fi < 0 {
			fi += t.shape[ii]
		}
		mut li := idx_end[ii]
		if li < 0 {
			li += t.shape[ii]
		}
		if (fi == li) {
			newshape[ii] = 0
			newstrides[ii] = 0
			idx << fi
		}
		else {
			offset := li - fi
			newshape[ii] = offset
			idx << fi
		}
		ii++
	}
	newshape_,newstrides_ := internal.filter_shape_not_strides(newshape, newstrides)
	mut ptr := t.buffer
	mut i := 0
	for i < t.ndims {
		ptr += t.strides[i] * idx[i]
		i++
	}
	mut ret := NdArray{
		shape: newshape_
		strides: newstrides_
		ndims: newshape_.len
		size: internal.shape_size(newshape_)
		buffer: ptr
		flags: newflags
	}
	ret.update_flags(all_flags())
	return ret
}

// iter returns a flat iterator over an ndarray, commonly used
// for reduction operations
pub fn (t NdArray) iter() NdIter {
	return NdIter{
		ptr: offset_ptr(t.buffer, t.shape, t.strides)
		done: false
		size: t.size
		shape: t.shape
		strides: t.strides
		track: [0].repeat(t.ndims)
		dim: t.ndims - 1
	}
}

// axis returns an iterator over the axis of an ndarray, commonly
// used for reduction operations along an axis.
pub fn (t NdArray) axis(i int) AxesIter {
	mut shape := t.shape.clone()
	shape.delete(i)
	mut strides := t.strides.clone()
	strides.delete(i)
	ptr := t.buffer
	inc := t.strides[i]
	tmp := NdArray{
		shape: shape
		strides: strides
		buffer: ptr
		size: internal.shape_size(shape)
		ndims: shape.len
		flags: no_flags()
	}
	return AxesIter{
		ptr: ptr
		shape: shape
		strides: strides
		tmp: tmp
		inc: inc
		axis: i
		size: t.shape[i]
	}
}

// axis_with_dims returns an iterator along the axis
// of an ndarray where the axis in question is not removed
// from the resulting array, but instead reduced to 1.
//
// This makes broadcasting operations on the result more 
// consistent.
pub fn (t NdArray) axis_with_dims(i int) AxesIter {
	mut shape := t.shape.clone()
	shape[i] = 1
	mut strides := t.strides.clone()
	strides[i] = 0
	ptr := t.buffer
	inc := t.strides[i]
	tmp := NdArray{
		shape: shape
		strides: strides
		buffer: ptr
		size: internal.shape_size(shape)
		ndims: shape.len
		flags: no_flags()
	}
	return AxesIter{
		ptr: ptr
		shape: shape
		strides: strides
		tmp: tmp
		inc: inc
		axis: i
		size: t.shape[i]
	}
}

// with returns an iterator through two arrays pairwise.
// Broadcasts inputs to match shape, independent of strides,
// Stores of a copy of an ndarray that the result of any modification
// operation will be stored in.
pub fn (t NdArray) with(other NdArray) NdIterWith {
	a, b := broadcast_arrays(t, other)
	ret := a.copy('C')
	return NdIterWith{
		ret: ret
		ptr_a: offset_ptr(ret.buffer, ret.shape, ret.strides)
		ptr_b: offset_ptr(b.buffer, b.shape, b.strides)
		done: false
		shape: ret.shape
		strides_a: ret.strides
		strides_b: b.strides
		track: [0].repeat(ret.ndims)
		dim: ret.ndims - 1
	}
}

// with returns an iterator through two arrays pairwise.
// Broadcasts inputs to match shape, independent of strides,
// Stores of a reference of an ndarray that the result of 
// any modification operation will be stored in.
pub fn (t NdArray) with_inpl(other NdArray) NdIterWith {
	b := broadcast_to(other, t.shape)
	return NdIterWith{
		ret: t
		ptr_a: offset_ptr(t.buffer, t.shape, t.strides)
		ptr_b: offset_ptr(b.buffer, b.shape, b.strides)
		done: false
		shape: t.shape
		strides_a: t.strides
		strides_b: b.strides
		track: [0].repeat(t.ndims)
		dim: t.ndims - 1
	}
}

pub fn (t NdArray) scalar(other f64) ScalarIter {
	ret := t.copy('C')
	return ScalarIter{
		ret: ret
		scalar: other
		ptr: offset_ptr(ret.buffer, ret.shape, ret.strides)
		done: false
		size: ret.size
		shape: ret.shape
		strides: ret.strides
		track: [0].repeat(ret.ndims)
		dim: ret.ndims - 1
	}
}

// assigns an ndarray to an existing ndarray in place.
// The input will be broadcast to the shape of the
// existing ndarray if possible.
pub fn (t NdArray) assign(val NdArray) {
	for iter := t.with_inpl(val); !iter.done; iter.next() {
		*iter.ptr_a = *iter.ptr_b
	}
}

// assigns a scalar value to an existing ndarray in place.
// The input is broadcast across the entire shape of the
// existing ndarray
pub fn (t NdArray) fill(val f64) {
	for iter := t.iter(); !iter.done; iter.next() {
		*iter.ptr = val
	}
}

// str returns the string representation of an ndarray.
pub fn (t NdArray) str() string {
	return array2string(t, ', ', '')
}

// returns a copy of an array with a particular memory
// layout, either c-contiguous or fortran contiguous
pub fn (t NdArray) copy(order string) NdArray {
	mut ret := allocate_ndarray(t.shape, order)
	for iter := ret.with_inpl(t); !iter.done; iter.next() {
		*iter.ptr_a = *iter.ptr_b
	}
	ret.update_flags(all_flags())
	return ret
}

// returns a view of an ndarray, identical to the
// parent but not owning its own data.
pub fn (t NdArray) view() NdArray {
	mut newflags := dup_flags(t.flags)
	newflags.owndata = false
	return NdArray{
		shape: t.shape.clone()
		strides: t.strides.clone()
		buffer: t.buffer
		flags: newflags
		size: t.size
		ndims: t.ndims
	}
}

// diagonal returns a view of the diagonal entries
// of a two dimensional ndarray
pub fn (t NdArray) diagonal() NdArray {
	nel := shape_min(t.shape)
	newshape := [nel]
	newstrides := [shape_sum(t.strides)]
	mut newflags := dup_flags(t.flags)
	newflags.owndata = false
	mut ret := NdArray{
		buffer: t.buffer
		ndims: 1
		shape: newshape
		strides: newstrides
		flags: newflags
		size: nel
	}
	ret.update_flags(all_flags())
	return ret
}

// reshape returns an ndarray with a new shape, as a
// view if possible.  If a view is not possible, copies
// data and returns a c-contiguous array
pub fn (t NdArray) reshape(shape []int) NdArray {
	mut ret := t.view()
	mut newshape := shape.clone()
	mut newsize := 1
	cur_size := t.size
	mut autosize := -1
	for i, val in newshape {
		if (val < 0) {
			if (autosize >= 0) {
				panic('Only one dimension can be autosized')
			}
			autosize = i
		}
		else {
			newsize *= val
		}
	}
	if (autosize >= 0) {
		newshape = newshape.clone()
		newshape[autosize] = cur_size / newsize
		newsize *= newshape[autosize]
	}
	if (newsize != cur_size) {
		panic('Cannot reshape')
	}
	mut newstrides := [0].repeat(newshape.len)
	if (t.flags.fortran && !t.flags.contiguous) {
		newstrides = internal.fstrides(newshape)
	}
	else {
		newstrides = internal.cstrides(newshape)
	}
	if (t.flags.contiguous || t.flags.fortran) {
		ret.shape = newshape
		ret.strides = newstrides
		ret.ndims = newshape.len
	}
	else {
		ret = t.copy('C')
		ret.shape = newshape
		ret.strides = newstrides
		ret.ndims = newshape.len
	}
	ret.update_flags(all_flags())
	return ret
}

// transpose permutes the axes of an ndarray in a specified
// order and returns a view of the data
pub fn (t NdArray) transpose(order []int) NdArray {
	mut ret := t.view()
	n := order.len
	if (n != t.ndims) {
		panic('Bad number of dimensions')
	}
	mut permutation := [0].repeat(32)
	mut reverse_permutation := [-1].repeat(32)
	mut i := 0
	for i < n {
		mut axis := order[i]
		if (axis < 0) {
			axis = t.ndims + axis
		}
		if (axis < 0 || axis >= t.ndims) {
			panic('Bad permutation')
		}
		if (reverse_permutation[axis] != -1) {
			panic('Bad permutation')
		}
		reverse_permutation[axis] = i
		permutation[i] = axis
		i++
	}
	mut ii := 0
	for ii < n {
		ret.shape[ii] = t.shape[permutation[ii]]
		ret.strides[ii] = t.strides[permutation[ii]]
		ii++
	}
	ret.update_flags(all_flags())
	return ret
}

// t returns a ful transpose of an ndarray, with the axes
// reversed
pub fn (t NdArray) t() NdArray {
	order := range(0, t.ndims)
	return t.transpose(order.reverse())
}

// swapaxes returns a view of an ndarray with two axes
// swapped.
pub fn (t NdArray) swapaxes(a1 int, a2 int) NdArray {
	mut order := range(0, t.ndims)
	tmp := order[a1]
	order[a1] = order[a2]
	order[a2] = tmp
	return t.transpose(order)
}

// ravel returns a flattened view of an ndarray if possible,
// otherwise a flattened copy
pub fn (t NdArray) ravel() NdArray {
	return t.reshape([-1])
}

// adds two ndarrays elementwise
pub fn (lhs NdArray) +(rhs NdArray) NdArray {
	return lhs.with(rhs).add()
}

// subtracts two ndarrays elementwise
pub fn (lhs NdArray) -(rhs NdArray) NdArray {
	return lhs.with(rhs).subtract()
}

// multiplies two ndarrays elementwise
pub fn (lhs NdArray) *(rhs NdArray) NdArray {
	return lhs.with(rhs).multiply()
}

// divides two ndarrays elementwise
pub fn (lhs NdArray) /(rhs NdArray) NdArray {
	return lhs.with(rhs).divide()
}

// applies a provided operation to an ndarray, returning a copy
pub fn (n NdArray) apply(op fn(f64)f64) NdArray {
	return apply(n, op)
}
