module ndarray

import vnum.internal
import math

pub struct NdArray {
pub mut:
	shape    []int
	strides  []int
	ndims    int
	size     int
	flags    ArrayFlags
pub:
	buffer   &f64
}

pub fn (t NdArray) get(idx []int) f64 {
	mut buf := t.buffer
	for i := 0; i < t.ndims; i++ {
		if t.strides[i] < 0 {
			buf += (t.shape[i] - 1) * int(math.abs(t.strides[i]))
		}
	}
	return *(buf + offset(t, idx))
}

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
		} else if dex.len == 2 {
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
			} else {
				newshape[i] = li - fi
			}
		} else if dex.len == 3 {
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
	newshape_, newstrides_ := internal.filter_shape_not_strides(newshape, newstrides)
	mut ptr := t.buffer
	mut i := 0
	for i < indexer.len {
		ptr += t.strides[i] * indexer[i]
		i++
	}
	mut ret := NdArray {
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

pub fn (t NdArray) slice_hilo(idx1 []int, idx2[]int) NdArray {
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
	newshape_, newstrides_ := internal.filter_shape_not_strides(newshape, newstrides)

	mut ptr := t.buffer
	mut i := 0
	for i < t.ndims {
		ptr += t.strides[i] * idx[i]
		i++
	}
	mut ret := NdArray {
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

pub fn (t NdArray) iter() NdIter {
	return NdIter{
		ptr: offset_ptr(t.buffer, t.shape, t.strides)
		done: false
		shape: t.shape
		strides: t.strides
		track: [0].repeat(t.ndims)
		dim: t.ndims - 1
	}
}

pub fn (t NdArray) axis(i int) AxesIter {
	mut shape := t.shape.clone()
	shape.delete(i)
	mut strides := t.strides.clone()
	strides.delete(i)
	ptr := t.buffer
	inc := t.strides[i]
	tmp := NdArray {
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
	}
}

pub fn (t NdArray) iter_with(other NdArray) NdIterWith {
	return NdIterWith{
		ptr_a: offset_ptr(t.buffer, t.shape, t.strides)
		ptr_b: offset_ptr(other.buffer, other.shape, other.strides)
		done: false
		shape: t.shape
		strides_a: t.strides
		strides_b: other.strides
		track: [0].repeat(t.ndims)
		dim: t.ndims - 1
	}
}

pub fn (t NdArray) assign(val NdArray) {
	for iter := t.iter_with(val); !iter.done; iter.next() {
		*iter.ptr_a = *iter.ptr_b
	}
}

pub fn (t NdArray) fill(val f64) {
	for iter := t.iter(); !iter.done; iter.next() {
		*iter.ptr = val
	}
}

pub fn (t NdArray) str() string {
	return array2string(t, ', ', '')
}

pub fn (t NdArray) copy(order string) NdArray {
	mut ret := allocate_ndarray(t.shape, order)

	for iter := ret.iter_with(t); !iter.done; iter.next() {
		*iter.ptr_a = *iter.ptr_b
	}
	ret.update_flags(all_flags())
	return ret
}

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

pub fn (t NdArray) t() NdArray {
	order := range(0, t.ndims)
	return t.transpose(order.reverse())
}

pub fn (t NdArray) swapaxes(a1 int, a2 int) NdArray {
	mut order := range(0, t.ndims)
	tmp := order[a1]
	order[a1] = order[a2]
	order[a2] = tmp
	return t.transpose(order)
}

pub fn (t NdArray) ravel() NdArray {
	return t.reshape([-1])
}

pub fn (lhs NdArray) + (rhs NdArray) NdArray {
	a, b := broadcast_arrays(lhs, rhs)
	ret := a.copy('C')
	for iter := ret.iter_with(b); !iter.done; iter.next() {
		*iter.ptr_a += *iter.ptr_b
	}
	return ret
}

pub fn (lhs NdArray) - (rhs NdArray) NdArray {
	a, b := broadcast_arrays(lhs, rhs)
	ret := a.copy('C')
	for iter := ret.iter_with(b); !iter.done; iter.next() {
		*iter.ptr_a -= *iter.ptr_b
	}
	return ret
}

pub fn (lhs NdArray) * (rhs NdArray) NdArray {
	a, b := broadcast_arrays(lhs, rhs)
	ret := a.copy('C')
	for iter := ret.iter_with(b); !iter.done; iter.next() {
		*iter.ptr_a *= *iter.ptr_b
	}
	return ret
}

pub fn (lhs NdArray) / (rhs NdArray) NdArray {
	a, b := broadcast_arrays(lhs, rhs)
	ret := a.copy('C')
	for iter := ret.iter_with(b); !iter.done; iter.next() {
		*iter.ptr_a /= *iter.ptr_b
	}
	return ret
}

pub fn (lhs NdArray) add(rhs NdArray) NdArray {
	return lhs + rhs
}

pub fn (lhs NdArray) add_inpl(rhs NdArray) {
	brhs := broadcast_to(rhs, lhs.shape)
	for iter := lhs.iter_with(brhs); !iter.done; iter.next() {
		*iter.ptr_a += *iter.ptr_b
	}
}

pub fn (lhs NdArray) subtract(rhs NdArray) NdArray {
	return lhs - rhs
}

pub fn (lhs NdArray) subtract_inpl(rhs NdArray) {
	brhs := broadcast_to(rhs, lhs.shape)
	for iter := lhs.iter_with(brhs); !iter.done; iter.next() {
		*iter.ptr_a -= *iter.ptr_b
	}
}

pub fn (lhs NdArray) multiply(rhs NdArray) NdArray {
	return lhs * rhs
}

pub fn (lhs NdArray) multiply_inpl(rhs NdArray) {
	brhs := broadcast_to(rhs, lhs.shape)
	for iter := lhs.iter_with(brhs); !iter.done; iter.next() {
		*iter.ptr_a *= *iter.ptr_b
	}
}

pub fn (lhs NdArray) divide(rhs NdArray) NdArray {
	return lhs / rhs
}

pub fn (lhs NdArray) divide_inpl(rhs NdArray) {
	brhs := broadcast_to(rhs, lhs.shape)
	for iter := lhs.iter_with(brhs); !iter.done; iter.next() {
		*iter.ptr_a += *iter.ptr_b
	}
}

pub fn (lhs NdArray) adds(rhs f64) NdArray {
	return scalar_op(lhs, rhs, add_)
}

pub fn (lhs NdArray) subtracts(rhs f64) NdArray {
	return scalar_op(lhs, rhs, subtract_)
}

pub fn (lhs NdArray) multiplys(rhs f64) NdArray {
	return scalar_op(lhs, rhs, multiply_)
}

pub fn (lhs NdArray) divides(rhs f64) NdArray {
	return scalar_op(lhs, rhs, divide_)
}

pub fn (lhs NdArray) sadd(rhs f64) NdArray {
	return scalar_op_lhs(lhs, rhs, add_)
}

pub fn (lhs NdArray) ssubtract(rhs f64) NdArray {
	return scalar_op_lhs(lhs, rhs, subtract_)
}

pub fn (lhs NdArray) smultiply(rhs f64) NdArray {
	return scalar_op_lhs(lhs, rhs, multiply_)
}

pub fn (lhs NdArray) sdivide(rhs f64) NdArray {
	return scalar_op_lhs(lhs, rhs, divide_)
}

pub fn (n NdArray) apply(op fn(f64)f64) NdArray {
	return apply(n, op)
}

pub fn (n NdArray) sum_axis(axis int) NdArray {
	return sum_axis(n, axis)
}

pub fn (n NdArray) mean_axis(axis int) NdArray {
	return mean_axis(n, axis)
}

pub fn (n NdArray) min() f64 {
	return min(n)
}

pub fn (n NdArray) max() f64 {
	return max(n)
}

pub fn (n NdArray) sum() f64 {
	return sum(n)
}

pub fn (n NdArray) prod() f64 {
	return prod(n)
}

pub fn (n NdArray) mean() f64 {
	return mean(n)
}