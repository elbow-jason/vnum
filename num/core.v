module num

import base

pub fn concatenate(ts []base.Tensor, axis int) base.Tensor {
	return base.concatenate(ts, axis)
}

pub fn vstack(ts []base.Tensor) base.Tensor {
	return concatenate(ts, 0)
}

pub fn hstack(ts []base.Tensor) base.Tensor {
	return concatenate(ts, 1)
}

pub fn seq(n int) base.Tensor {
	ret := base.allocate_tensor([n])
	mut ii := 0
	mut iter := ret.flat_iter()
	for ii < n {
		mut ptr := iter.next()
		*ptr = f64(ii)
		ii++
	}
	return ret
}

pub fn seq_between(start int, end int) base.Tensor {
	d := end - start
	ret := seq(d)
	return add_scalar(ret, start)
}

pub fn empty(shape []int) base.Tensor {
	return base.allocate_tensor(shape)
}

pub fn empty_like(t base.Tensor) base.Tensor {
	return empty(t.shape)
}

pub fn full(shape []int, val f64) base.Tensor {
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

pub fn full_like(t base.Tensor, val f64) base.Tensor {
	return full(t.shape, val)
}

pub fn zeros(shape []int) base.Tensor {
	return full(shape, 0.0)
}

pub fn zeros_like(t base.Tensor) base.Tensor {
	return zeros(t.shape)
}

pub fn ones(shape []int) base.Tensor {
	return full(shape, 1.0)
}

pub fn linspace(start f64, stop f64, num int) base.Tensor {
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

fn tril_inplace_offset(t base.Tensor, offset int) {
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

fn triu_inplace_offset(t base.Tensor, offset int) {
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

pub fn tril(t base.Tensor) base.Tensor {
	ret := t.copy('C')
	tril_inplace_offset(ret, 0)
	return ret
}

pub fn tril_offset(t base.Tensor, offset int) base.Tensor {
	ret := t.copy('C')
	tril_inplace_offset(ret, offset)
	return ret
}

pub fn tril_inpl(t base.Tensor) {
	tril_inplace_offset(t, 0)
}

pub fn tril_inpl_offset(t base.Tensor, offset int) {
	tril_inplace_offset(t, offset)
}

pub fn triu(t base.Tensor) base.Tensor {
	ret := t.copy('C')
	triu_inplace_offset(ret, 0)
	return ret
}

pub fn triu_offset(t base.Tensor, offset int) base.Tensor {
	ret := t.copy('C')
	triu_inplace_offset(ret, offset)
	return ret
}

pub fn triu_inpl(t base.Tensor) {
	triu_inplace_offset(t, 0)
}

pub fn triu_inpl_offset(t base.Tensor, offset int) {
	triu_inpl_offset(t, offset)
}

pub fn from_f32(a []f32, shape []int) base.Tensor {
	ret := a.map(f64(it))
	return base.from_array(ret, shape)
}

pub fn from_int(a []int, shape []int) base.Tensor {
	ret := a.map(f64(it))
	return base.from_array(ret, shape)
}

pub fn from_f64(a []f64, shape []int) base.Tensor {
	return base.from_array(a, shape)
}
