module num

pub fn max(a Tensor) f64 {
	mut mx := 0.0
	mut iter := a.flat_iter()
	mut i := 0
	for i < a.size {
		ptr := *iter.next()
		if i == 0 {
			mx = ptr
		}
		if ptr > mx {
			mx = ptr
		}
		i++
	}
	return mx
}

pub fn min(a Tensor) f64 {
	mut mn := 0.0
	mut iter := a.flat_iter()
	mut i := 0
	for i < a.size {
		ptr := *iter.next()
		if i == 0 {
			mn = ptr
		}
		if ptr < mn {
			mn = ptr
		}
		i++
	}
	return mn
}

pub fn sum_axis(a Tensor, axis int) Tensor {
	mut ai := a.axis_iter(axis)
	mut ii := 1
	mut ret := ai.next()
	for ii < a.shape[axis] {
		ret = add(ret, ai.next())
		ii++
	}
	return ret
}

pub fn mean_axis(a Tensor, axis int) Tensor {
	ret := sum_axis(a, axis)
	return divide_scalar(ret, a.shape[axis])
}

pub fn max_axis(a Tensor, axis int) Tensor {
	mut ai := a.axis_iter(axis)
	mut ii := 1
	mut ret := ai.next()
	for ii < a.shape[axis] {
		ret = maximum(ret, ai.next())
		ii++
	}
	return ret
}

pub fn min_axis(a Tensor, axis int) Tensor {
	mut ai := a.axis_iter(axis)
	mut ii := 1
	mut ret := ai.next()
	for ii < a.shape[axis] {
		ret = minimum(ret, ai.next())
		ii++
	}
	return ret
}
