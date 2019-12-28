module num

pub fn concatenate(ts []Tensor, axis int) Tensor {
	mut newshape := ts[0].shape.clone()
	newshape[axis] = 0
	newshape = assert_shape_off_axis(ts, axis, newshape)
	ret := allocate_tensor(newshape)
	mut lo := [0].repeat(newshape.len)
	mut hi := newshape.clone()
	hi[axis] = 0
	for t in ts {
		if t.shape[axis] != 0 {
			hi[axis] += t.shape[axis]
			ret.set(lo, hi, t)
			lo[axis] = hi[axis]
		}
	}
	return ret
}

pub fn seq(n int) Tensor {
	ret := allocate_tensor([n])
	mut ii := 0
	mut iter := ret.flat_iter()
	for ii < n {
		mut ptr := iter.next()
		*ptr = f64(ii)
		ii++
	}
	return ret
}