module num

import base

pub fn repeat_flat(a base.Tensor, n int) base.Tensor {
	ret := empty([a.size * n])
	mut ret_iter := ret.flat_iter()
	mut a_iter := a.flat_iter()
	for i := 0; i < ret.size; i++ {
		val := *a_iter.next()
		for j := 0; j < n; j++ {
			mut ptr := ret_iter.next()
			*ptr = val
		}
	}
	return ret
}

pub fn repeat(a base.Tensor, n int, axis int) base.Tensor {
	mut newshape := a.shape.clone()
	newshape[axis] *= n
	ret := empty(newshape)
	mut ret_iter := ret.axis_iter(axis)
	mut a_iter := a.axis_iter(axis)
	for i := 0; i < a.shape[axis]; i++ {
		tmp := a_iter.next()
		for j := 0; j < n; j++ {
			retmp := ret_iter.next()
			retmp.set([0], [a.shape[axis]], tmp)
		}
	}
	return ret
}

fn _tile(a base.Tensor, reps []int) base.Tensor {
	mut ary := a.dup_view()
	mut shape_out := []int
	for i := 0; i < reps.len; i++ {
		shape_out << a.shape[i] * reps[i]
	}
	mut n := a.size
	if n > 0 {
		for i := 0; i < reps.len; i++ {
			dim := a.shape[i]
			nrep := reps[i]
			if nrep != 1 {
				ary = repeat(ary.reshape([-1, n]), nrep, 0)
			}
			n /= dim
		}
	}
	return ary.reshape(shape_out)
}

pub fn tile(a base.Tensor, n int) base.Tensor {
	mut d := []int
	if a.ndims > 1 {
		d << [1].repeat(a.ndims - 1)
		d << n
	}
	else {
		d << [n]
	}
	return _tile(a, d)
}

pub fn flip(a base.Tensor) base.Tensor {
	newstrides := a.strides.clone()
	strides := newstrides.map(-1 * it)
	return strided_update_flags(a, a.shape, strides)
}

fn strided_update_flags(a base.Tensor, shape []int, strides []int) base.Tensor {
	mut ret := as_strided(a, shape, strides)
	ret.flags = base.all_flags()
	ret.update_flags(base.all_flags())
	return ret
}

pub fn flip_axis(a base.Tensor, axis int) base.Tensor {
	mut newstrides := a.strides.clone()
	newstrides[axis] *= -1
	return strided_update_flags(a, a.shape, newstrides)
}

pub fn fliplr(a base.Tensor) base.Tensor {
	if a.ndims < 2 {
		panic('Tensor must be >= 2-d')
	}
	mut newstrides := a.strides
	newstrides[1] *= -1
	return strided_update_flags(a, a.shape, newstrides)
}

fn splitter(a base.Tensor, axis int, n int, div_points []int) []base.Tensor {
	mut subary := []base.Tensor
	sary := a.swapaxes(axis, 0)
	for i := 0; i < n; i++ {
		st := div_points[i]
		en := div_points[i + 1]
		subary << sary.get([st], [en]).swapaxes(axis, 0)
	}
	return subary
}

pub fn array_split(a base.Tensor, ind int, axis int) []base.Tensor {
	ntotal := a.shape[axis]
	neach := ntotal / ind
	extras := ntotal % ind
	mut sizes := [0]
	sizes << [neach + 1].repeat(extras)
	sizes << [neach].repeat(ind - extras)
	mut rt := 0
	for i := 0; i < sizes.len; i++ {
		tmp := rt
		rt += sizes[i]
		sizes[i] = sizes[i] + tmp
	}
	return splitter(a, axis, ind, sizes)
}

pub fn array_split_expl(a base.Tensor, ind []int, axis int) []base.Tensor {
	nsections := ind.len + 1
	mut div_points := [0]
	div_points << ind
	div_points << [a.shape[axis]]
	return splitter(a, axis, nsections, div_points)
}

pub fn split(a base.Tensor, ind int, axis int) []base.Tensor {
	n := a.shape[axis]
	if n % ind != 0 {
		panic('Array split does not result in an equal division')
	}
	return array_split(a, ind, axis)
}

pub fn split_expl(a base.Tensor, ind []int, axis int) []base.Tensor {
	return array_split_expl(a, ind, axis)
}

pub fn hsplit(a base.Tensor, ind int) []base.Tensor {
	return match (a.ndims) {
		1{
			split(a, ind, 0)
		}
		else {
			split(a, ind, 1)}
	}
}

pub fn hsplit_expl(a base.Tensor, ind []int) []base.Tensor {
	return match (a.ndims) {
		1{
			split_expl(a, ind, 0)
		}
		else {
			split_expl(a, ind, 1)}
	}
}

pub fn vsplit(a base.Tensor, ind int) []base.Tensor {
	if a.ndims < 2 {
		panic('vsplit only works on tensors of >= 2 dimensions')
	}
	return split(a, ind, 0)
}

pub fn vsplit_expl(a base.Tensor, ind []int) []base.Tensor {
	if a.ndims < 2 {
		panic('vsplit only works on tensors of >= 2 dimensions')
	}
	return split_expl(a, ind, 0)
}
