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

pub fn vstack(ts []Tensor) Tensor {
	return concatenate(ts, 0)
}

pub fn hstack(ts []Tensor) Tensor {
	return concatenate(ts, 1)
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

pub fn seq_between(start int, end int) Tensor {
	d := end - start
	ret := seq(d)
	return add_scalar(ret, start)
}

pub fn empty(shape []int) Tensor {
	return allocate_tensor(shape)
}

pub fn empty_like(t Tensor) Tensor {
	return empty(t.shape)
}

pub fn full(shape []int, val f64) Tensor {
	ret := empty(shape)
	mut iter := ret.flat_iter()
	mut i := 0
	for i < ret.size {
		mut ptr := iter.next()
		*ptr = val
		i++
	}
	return ret
}

pub fn full_like(t Tensor, val f64) Tensor {
	return full(t.shape, val)
}

pub fn zeros(shape []int) Tensor {
	return full(shape, 0.0)
}

pub fn zeros_like(t Tensor) Tensor {
	return zeros(t.shape)
}

pub fn ones(shape []int) Tensor {
	return full(shape, 1.0)
}

pub fn linspace(start f64, stop f64, num int) Tensor {
	div := num - 1
	mut y := seq(num)
	delta := stop - start
	if num > 1 {
		step := delta / div
		if step == 0 {
			panic('Cannot have a step of 0')
		}
		y = multiply_scalar(y, step)
	}
	else {
		y = multiply_scalar(y, delta)
	}
	y = add_scalar(y, start)
	y.set_at([y.shape[0] - 1], stop)
	return y
}

fn tril_inplace_offset(t Tensor, offset int) {
	mut i := 0
	for i < t.shape[0] {
		mut j := 0
		for j < t.shape[1] {
			if i < j - offset {
				t.set_at([i, j], 0)
			}
			j++
		}
		i++
	}
}

fn triu_inplace_offset(t Tensor, offset int) {
	mut i := 0
	for i < t.shape[0] {
		mut j := 0
		for j < t.shape[1] {
			if i > j - offset {
				t.set_at([i, j], 0)
			}
			j++
		}
		i++
	}
}

pub fn tril(t Tensor) Tensor {
	ret := t.copy('C')
	tril_inplace_offset(ret, 0)
	return ret
}

pub fn tril_inpl(t Tensor) {
	tril_inplace_offset(t, 0)
}

pub fn triu(t Tensor) Tensor {
	ret := t.copy('C')
	triu_inplace_offset(ret, 0)
	return ret
}

pub fn triu_inpl(t Tensor) {
	triu_inplace_offset(t, 0)
}
