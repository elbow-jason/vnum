module ndarray


// sum reduces an iterator to a scalar value, the sum of an
// entire ndarray
pub fn (iter NdIter) sum() f64 {
	mut res := 0.0
	for i := iter; !i.done; i.next() {
		res += *i.ptr
	}
	return res
}

// prod reduces an iterator to a scalar value, the product of an
// ndarray
pub fn (iter NdIter) prod() f64 {
	mut res := 1.0
	for i := iter; !i.done; i.next() {
		res *= *i.ptr
	}
	return res
}

// mean computes the mean of an iterator, exhausting the iterator in
// the process
pub fn (iter NdIter) mean() f64 {
	return iter.sum() / iter.size
}

// max computes the max of an ndarray from its iterator
pub fn (iterator NdIter) max() f64 {
	mut mx := 0.0
	mut i := 0
	for iter := iterator; !iter.done; iter.next() {
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

// min computes the minimum of an ndarray from an iterator
pub fn (iterator NdIter) min() f64 {
	mut mn := 0.0
	mut i := 0
	for iter := iterator; !iter.done; iter.next() {
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

// ptp computes the difference between the maximum value of an
// ndarray and the minimum value
pub fn (iterator NdIter) ptp() f64 {
	mut mx := 0.0
	mut mn := 0.0
	mut i := 0
	for iter := iterator; !iter.done; iter.next() {
		if i == 0 {
			mx = *iter.ptr
			mn = *iter.ptr
		}
		if *iter.ptr > mx {
			mx = *iter.ptr
		} else if *iter.ptr < mn {
			mn = *iter.ptr
		}
		i++
	}
	return mx - mn
}

// sum computes the sum of an ndarray along an axis specified by
// an axis iterator
pub fn (iterator AxesIter) sum() NdArray {
	mut ai := iterator
	mut ii := 1
	ret := ai.next().copy('C')
	for ii < ai.size {
		ret.with_inpl(ai.next()).add()
		ii++
	}
	return ret
}

// mean returns the mean of an ndarray along an axis specified by
// an axis iterator
pub fn (iterator AxesIter) mean() NdArray {
	ret := iterator.sum()
	return ret.scalar(iterator.size).divide()
}

// minimum returns the minimum of an ndarray along an axis specified
// by an axis iterator
pub fn (iterator AxesIter) minimum() NdArray {
	mut ai := iterator
	mut ii := 1
	ret := ai.next().copy('C')
	for ii < ai.size {
		ret.with_inpl(ai.next()).minimum()
		ii++
	}
	return ret
}

// maximum returns the maximum of an ndarray along an axis specified
// by an axis iterator
pub fn (iterator AxesIter) maximum() NdArray {
	mut ai := iterator
	mut ii := 1
	ret := ai.next().copy('C')
	for ii < ai.size {
		ret.with_inpl(ai.next()).maximum()
		ii++
	}
	return ret
}