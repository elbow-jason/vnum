module base

import math

pub struct Tensor {
pub mut:
	shape    []int
	strides  []int
	ndims    int
	size     int
	flags    map[string]bool
pub:
	itemsize int
	buffer   &f64
}

pub fn allocate_tensor(shape []int) Tensor {
	size := shape_size(shape)
	return Tensor {
		shape: shape
		strides: cstrides(shape)
		ndims: shape.len
		size: size
		flags: default_flags('C')
		itemsize: sizeof(f64)
		buffer: *f64(calloc(size * sizeof(f64)))
	}
}

pub fn allocate_tensor_fortran(shape []int) Tensor {
	size := shape_size(shape)
	return Tensor {
		shape: shape
		strides: fstrides(shape)
		ndims: shape.len
		size: size
		flags: default_flags('F')
		itemsize: sizeof(f64)
		buffer: *f64(calloc(size * sizeof(f64)))
	}
}

fn offset(t Tensor, idx []int) int {
	mut offset := 0
	for i, stride in t.strides {
		mut idxer := idx[i]
		if idxer < 0 {
			idxer += t.shape[i]
		}
		offset += idxer * stride
	}
	return offset
}

pub fn (t Tensor) get_at(idx []int) f64 {
	mut buf := t.buffer
	for i := 0; i < t.ndims; i++ {
		if t.strides[i] < 0 {
			buf += (t.shape[i] - 1) * int(math.abs(t.strides[i]))
		}
	}
	return *(buf + offset(t, idx))
}

pub fn (t Tensor) set_at(idx []int, val f64) {
	mut buf := t.buffer
	for i := 0; i < t.ndims; i++ {
		if t.strides[i] < 0 {
			buf += (t.shape[i] - 1) * int(math.abs(t.strides[i]))
		}
	}
	mut ptr := buf + offset(t, idx)
	*ptr = val
}

pub fn (t Tensor) get(idx1 []int, idx2 []int) Tensor {
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
	newshape_ := newshape.filter(it != 0)
	newstrides_ := newstrides.filter(it != 0)
	mut ptr := t.buffer
	mut i := 0
	for i < t.ndims {
		ptr += t.strides[i] * idx[i]
		i++
	}
	mut ret := Tensor {
		shape: newshape_
		strides: newstrides_
		ndims: newshape_.len
		size: shape_size(newshape_)
		buffer: ptr
		flags: newflags
	}
	ret.update_flags(all_flags())
	return ret
}

pub fn (t Tensor) set(idx1 []int, idx2 []int, val Tensor) {
	slice := t.get(idx1, idx2)
	mut ia := slice.flat_iter()
	mut ib := val.flat_iter()
	mut i := 0
	for i < slice.size {
		mut ptr := ia.next()
		*ptr = *ib.next()
		i++
	}
}

fn (t Tensor) is_fortran_contiguous() bool {
	if (t.ndims == 0) {
		return true
	}
	if (t.ndims == 1) {
		return t.shape[0] == 1 || t.strides[0] == 1
	}
	mut sd := 1
	mut i := 0
	for i < t.ndims {
		dim := t.shape[i]
		if (dim == 0) {
			return true
		}
		if (t.strides[i] != sd) {
			return false
		}
		sd *= dim
		i++
	}
	return true
}

fn (t Tensor) is_contiguous() bool {
	if (t.ndims == 0) {
		return true
	}
	if (t.ndims == 1) {
		return t.shape[0] == 1 || t.strides[0] == 1
	}
	mut sd := 1
	mut i := t.ndims - 1
	for i > 0 {
		dim := t.shape[i]
		if (dim == 0) {
			return true
		}
		if (t.strides[i] != sd) {
			return false
		}
		sd *= dim
		i--
	}
	return true
}

fn (t mut Tensor) update_flags(d map[string]bool) {
	if (d['fortran'] && t.flags['fortran']) {
		if t.is_fortran_contiguous() {
			t.flags['fortran'] = true
			if t.ndims > 1 {
				t.flags['contiguous'] = false
			}
		}
		else {
			t.flags['fortran'] = false
		}
	}
	if (d['contiguous'] && t.flags['contiguous']) {
		if t.is_contiguous() {
			t.flags['contiguous'] = true
			if t.ndims > 1 {
				t.flags['fortran'] = false
			}
		}
		else {
			t.flags['contiguous'] = false
		}
	}
}

pub fn (t Tensor) flat_iter() NdIter {
	mut ptr := t.buffer
	for i := 0; i < t.ndims; i++ {
		if t.strides[i] < 0 {
			ptr += (t.shape[i] - 1) * int(math.abs(t.strides[i]))
		}
	}
	shape := t.shape
	dim := t.ndims - 1
	track := [0].repeat(dim + 1)
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
	tmp := Tensor {
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
	return array2string(t, ', ', '')
}

pub fn (t Tensor) copy(order string) Tensor {
	mut ret := Tensor {
		buffer: *f64(calloc(1))
	}
	if order == 'F' {
		ret = allocate_tensor_fortran(t.shape)
	}
	else if order == 'C' {
		ret = allocate_tensor(t.shape)
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

pub fn (t Tensor) dup_view() Tensor {
	mut newflags := dup_flags(t.flags)
	newflags['owndata'] = false
	ret := Tensor {
		shape: t.shape.clone()
		strides: t.strides.clone()
		buffer: t.buffer
		flags: newflags
		size: t.size
		ndims: t.ndims
	}
	return ret
}

pub fn (t Tensor) reshape(shape []int) Tensor {
	mut ret := t.dup_view()
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
		newshape[autosize] = newsize / cur_size
		newsize *= newshape[autosize]
	}
	if (newsize != cur_size) {
		panic('Cannot reshape')
	}
	mut newstrides := [0].repeat(newshape.len)
	if (t.flags['fortran'] && !t.flags['contiguous']) {
		newstrides = fstrides(newshape)
	}
	else {
		newstrides = cstrides(newshape)
	}
	if (t.flags['contiguous'] || t.flags['fortran']) {
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

pub fn (t Tensor) transpose(order []int) Tensor {
	mut ret := t.dup_view()
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
		if (reverse_permutation[axis] == -1) {
			panic('Bad permutation')
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

pub fn from_array(a []f64, shape []int) Tensor {
	data := a.clone().data
	size := shape_size(shape)
	if size != a.len {
		panic('Cannot fit array into $shape')
	}
	return base.Tensor {
		buffer: data
		size: size
		ndims: shape.len
		flags: default_flags('C')
		itemsize: sizeof(f64)
		strides: cstrides(shape)
		shape: shape
	}
}
