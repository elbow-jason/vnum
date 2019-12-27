module num
import tensor
import internal

fn op(a tensor.Tensor, b tensor.Tensor, op fn(f64, f64)f64) tensor.Tensor {
	ret := a.memory_into('C')
	mut ret_iter := ret.flat_iter()
	mut rhs_iter := b.flat_iter()
	mut ii := 0

	for ii < a.size {
		mut ptr := ret_iter.next()
		*ptr = op(*ptr, *rhs_iter.next())
		ii++
	}
	return ret
}

fn op_scalar(a tensor.Tensor, b f64, op fn(f64, f64)f64) tensor.Tensor {
	ret := a.memory_into('C')
	mut ret_iter := ret.flat_iter()
	mut ii := 0

	for ii < a.size {
		mut ptr := ret_iter.next()
		*ptr = op(*ptr, b)
		ii++
	}
	return ret
}

pub fn add(a tensor.Tensor, b tensor.Tensor) tensor.Tensor {
	return op(a, b, internal.add_)
}

pub fn add_scalar(a tensor.Tensor, b f64) tensor.Tensor {
	return op_scalar(a, b, internal.add_)
}

pub fn subtract(a tensor.Tensor, b tensor.Tensor) tensor.Tensor {
	return op(a, b, internal.subtract_)
}

pub fn subtract_scalar(a tensor.Tensor, b f64) tensor.Tensor {
	return op_scalar(a, b, internal.subtract_)
}

pub fn divide(a tensor.Tensor, b tensor.Tensor) tensor.Tensor {
	return op(a, b, internal.divide_)
}

pub fn divide_scalar(a tensor.Tensor, b f64) tensor.Tensor {
	return op_scalar(a, b, internal.divide_)
}

pub fn multiply(a tensor.Tensor, b tensor.Tensor) tensor.Tensor {
	return op(a, b, internal.multiply_)
}

pub fn multiply_scalar(a tensor.Tensor, b f64) tensor.Tensor {
	return op_scalar(a, b, internal.divide_)
}

pub fn sum_axis(a tensor.Tensor, axis int) tensor.Tensor {
	mut ai := a.axis_iter(axis)
	mut ii := 1
	mut ret := ai.next()
	for ii < a.shape[axis] {
		ret = add(ret, ai.next())
		ii++
	}
	return ret
}

pub fn mean_axis(a tensor.Tensor, axis int) tensor.Tensor {
	ret := sum_axis(a, axis)
	return divide_scalar(ret, a.shape[axis])
}

pub fn max(a tensor.Tensor) f64 {
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

pub fn min(a tensor.Tensor) f64 {
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