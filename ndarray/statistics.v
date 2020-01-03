module ndarray

fn max(a NdArray) f64 {
	mut mx := 0.0
	mut i := 0
	for iter := a.iter(); !iter.done; iter.next() {
		if i == 0 {
			mx = *iter.ptr
		}
		if *iter.ptr > mx {
			mx = *iter.ptr
		}
		i++
	}
	return mx
}

fn min(a NdArray) f64 {
	mut mn := 0.0
	mut i := 0
	for iter := a.iter(); !iter.done; iter.next() {
		if i == 0 {
			mn = *iter.ptr
		}
		if *iter.ptr < mn {
			mn = *iter.ptr
		}
		i++
	}
	return mn
}

fn sum(a NdArray) f64 {
	mut res := 0.0
	for i := a.iter(); !i.done; i.next() {
		res += *i.ptr
	}
	return res
}

fn prod(a NdArray) f64 {
	mut res := 1.0
	for i := a.iter(); !i.done; i.next() {
		res *= *i.ptr
	}
	return res
}

fn mean(a NdArray) f64 {
	return sum(a) / a.size
}

fn sum_axis(a NdArray, axis int) NdArray {
	mut ai := a.axis(axis)
	mut ii := 1
	ret := ai.next().copy('C')
	for ii < a.shape[axis] {
		ret.add_inpl(ai.next())
		ii++
	}
	return ret
}

pub fn mean_axis(a NdArray, axis int) NdArray {
	ret := sum_axis(a, axis)
	return ret.divides(a.shape[axis])
}

// pub fn max_axis(a NdArray, axis int) NdArray { // mut ai := a.axis_iter(axis) // mut ii := 1 // mut ret := ai.next() // for ii < a.shape[axis] { // ret = maximum(ret, ai.next()) // ii++ // } // return ret // }
// pub fn min_axis(a NdArray, axis int) NdArray { // mut ai := a.axis_iter(axis) // mut ii := 1 // mut ret := ai.next() // for ii < a.shape[axis] { // ret = minimum(ret, ai.next()) // ii++ // } // return ret // }
