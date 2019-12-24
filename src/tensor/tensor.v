module tensor

pub struct Tensor {
	itemsize int
	buffer &f64
	pub mut:
		shape []int
		strides []int
		ndims int
		size int
		flags map[string]bool
}

pub fn (t Tensor) get(idx []int) f64 {
	mut offset := 0
	mut i := 0
	for i < t.ndims {
		mut idxer := idx[i]
		if idxer < 0 {
			idxer += t.shape[i]
		}
		offset += idxer * t.strides[i]
		i++
	}
	return *(t.buffer + offset)
}

pub fn (t Tensor) set(idx []int, val f64) {
	mut offset := 0
	mut i := 0
	for i < t.ndims {
		offset += idx[i] * t.strides[i]
		i++
	}
	mut ptr := t.buffer + offset
	*ptr = val
}

pub fn (t Tensor) set_view(idx1 []int, idx2 []int, val Tensor) {
	slice := t.view(idx1, idx2)
	mut ia := slice.flat_iter()
	mut ib := val.flat_iter()
	mut i := 0
	
	for i < slice.size {
		mut ptr := ia.next()
		*ptr = *ib.next()
		i++
	}
}

pub fn (t Tensor) flat_iter() NdIter {
	ptr := t.buffer
	shape := t.shape
	dim := t.ndims - 1
	track := [0].repeat(dim+1)
	strides := t.strides
	return NdIter{
		ptr: ptr
		shape: shape
		dim: dim
		track: track
		strides: strides
	}
}

pub fn (t Tensor) axis_iter(axis int) AxesIter {
	shape := delete_at(t.shape.clone(), axis)
	strides := delete_at(t.strides.clone(), axis)
	ptr := t.buffer
	inc := t.strides[axis]
	tmp := Tensor{
		shape: shape
		strides: strides
		buffer: ptr
		size: shape_size(shape)
		ndims: shape.len
		flags: no_flags()
	}

	return AxesIter{
		ptr: ptr
		shape: shape
		strides: strides
		tmp: tmp
		inc: inc
		axis: axis
	}
}

pub fn (t Tensor) str() string {
	mut printer := init_printer(t)
	return printer.print()
}

pub fn (t Tensor) view(idx1 []int, idx2 []int) Tensor {
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
		} else {
			offset := li - fi
			newshape[ii] = offset
			idx << fi
		}
		ii++
	}
	newshape_ := newshape.filter(it != 0)
	newstrides_ := newstrides.filter(it != 0)
	mut ptr := t.buffer
	mut i := 0
	for i < t.ndims {
		ptr += t.strides[i] * idx[i]
		i++
	}
	mut ret := Tensor{
		shape: newshape_
		strides: newstrides_
		ndims: newshape_.len
		size: tensor.shape_size(newshape_)
		buffer: ptr
		flags: newflags
	}
	ret.update_flags(all_flags())
	return ret
}

pub fn (t Tensor) dup_view() Tensor {
	mut newflags := dup_flags(t.flags)
	newflags["owndata"] = false

	ret := Tensor{
		shape: t.shape.clone()
		strides: t.strides.clone()
		buffer: t.buffer
		flags: newflags
		size: t.size
		ndims: t.ndims
	}
	return ret
}

fn min(a int, b int) int {
	if a > b { return b }
	return a
}

pub fn (t Tensor) diag_view() Tensor {
	nel := min(t.shape[0], t.shape[1])
	mut newflags := dup_flags(t.flags)
	newflags["owndata"] = false

	ret := Tensor{
		shape: [nel]
		strides: [t.strides[0] + t.strides[1]]
		buffer: t.buffer
		flags: newflags
		size: t.size
		ndims: 1
	}
	return ret
}

pub fn (t Tensor) memory_into(order string) Tensor {
	mut ret := Tensor{buffer: *f64(calloc(1))}
	if order == 'F' {
		ret = empty_fortran(t.shape)
	} else if order == 'C' {
		ret = empty_contig(t.shape)
	}
	mut ia := ret.flat_iter()
	mut ib := t.flat_iter()
	mut i := 0
	for i < t.size {
		mut ptr := ia.next()
		*ptr = *ib.next()
		i++
	}
	ret.update_flags(all_flags())
	return ret
}

pub fn seq(n int) Tensor {
	ret := empty_contig([n])
	mut ii := 0
	mut iter := ret.flat_iter()
	for ii < n {
		mut ptr := iter.next()
		*ptr = f64(ii)
		ii++
	}
	return ret
}

pub fn reshape(t Tensor, shape []int) Tensor {
	mut ret := t.dup_view()
	mut newshape := shape.clone()
	mut newsize := 1
	cur_size := t.size
	mut autosize := -1

	for i, val in newshape {
		if (val < 0) {
			if (autosize >= 0) {
				// panic here
			}
			autosize = i
		} else {
			newsize *= val
		}
	}

	if (autosize >= 0) {
		newshape = newshape.clone()
		newshape[autosize] = newsize/cur_size
		newsize *= newshape[autosize]
	}

	if (newsize != cur_size) {
		// panic here
	}

	mut newstrides := [0].repeat(newshape.len)

	if (t.flags["fortran"] && !t.flags["contiguous"]) {
		newstrides = fstrides(newshape)
	} else {
		newstrides = cstrides(newshape)
	}

	if (t.flags["contiguous"] || t.flags["fortran"]) {
		ret.shape = newshape
		ret.strides = newstrides
		ret.ndims = newshape.len
	} else {
		ret = t.memory_into('C')
		ret.shape = newshape
		ret.strides = newstrides
		ret.ndims = newshape.len
	}
	ret.update_flags(all_flags())
	return ret
}

pub fn (t Tensor) axes_into(order []int) Tensor {
	mut ret := t.dup_view()
	n := order.len
	if (n != t.ndims) {
		// panic here
	}
	mut permutation := [0].repeat(32)
	mut reverse_permutation := [-1].repeat(32)

	mut i := 0
	for i < n {
		mut axis := order[i]
		if (axis < 0) { axis = t.ndims + axis }
		if (axis < 0 || axis >= t.ndims) {
			// panic here
		}
		if (reverse_permutation[axis] == -1) {
			// panic here
		}
		reverse_permutation[i] = i
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

