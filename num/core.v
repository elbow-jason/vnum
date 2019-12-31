module num

import vnum.base
import math

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

pub fn logspace(start f64, stop f64, num int) base.Tensor {
	return logspace_base(start, stop, num, 10.0)
}

pub fn logspace_base(start f64, stop f64, num int, base f64) base.Tensor {
	return scalar_pow(base, linspace(start, stop, num))
}

pub fn geomspace(start f64, stop f64, num int) base.Tensor {
	if start == 0 || stop == 0 {
		panic("Geometric sequence cannot include 0")
	}
	mut out_sign := 1.0
	mut ustart := start
	mut ustop := stop

	if start < 0 && stop < 0 {
		ustart = -start
		ustop = -stop
		out_sign = -out_sign
	}

	log_start := math.log10(ustart)
	log_stop := math.log10(ustop)

	return multiply_scalar(logspace(log_start, log_stop, num), out_sign)
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

pub fn eye(m int, n int, k int) base.Tensor {
	ret := zeros([m, n])
	mut ret_iter := ret.flat_iter()
	for i := 0; i < m; i++ {
		for j := 0; j < n; j++ {
			mut ptr := ret_iter.next()
			if i == j - k {
				*ptr = f64(1.0)
			}
		}
	}
	return ret
}

pub fn identity(n int) base.Tensor {
	return eye(n, n, 0)
}

pub fn diag(a base.Tensor, k int) base.Tensor {
	if a.ndims > 1 {
		panic("A must be one dimensional")
	}
	mut aiter := a.flat_iter()
	n := a.size
	ret := zeros([n, n])
	for i := 0; i < n; i++ {
		for j := 0; j < n; j++ {
			if i == j - k {
				ret.set_at([i, j], *aiter.next())
			}
		}
	}
	return ret
}

pub fn vander(x base.Tensor, n int) base.Tensor {
	if x.ndims > 1 {
		panic("Vandermonde matrices must be initialized from 1-d data")
	}
	ret := empty([x.size, n])
	mut iter := ret.flat_iter()
	for i := 0; i < x.size; i++ {
		for j := 0; j < n; j++ {
			mut ptr := iter.next()
			offset := n - j - 1
			*ptr = math.pow(x.get_at([i]), offset)
		}
	}
	return ret
}

pub fn vanderi(x base.Tensor n int) base.Tensor {
	if x.ndims > 1 {
		panic("Vandermonde matrices must be initialized from 1-d data")
	}
	ret := empty([x.size, n])
	mut iter := ret.flat_iter()
	for i := 0; i < x.size; i++ {
		for j := 0; j < n; j++ {
			mut ptr := iter.next()
			offset := j
			*ptr = math.pow(x.get_at([i]), offset)
		}
	}
	return ret
}
