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

// pub fn repeat(a base.Tensor, n int, axis int) {
// mut newshape := a.shape.clone()
// newshape[axis] *= n
// ret := empty(newshape)
// mut ret_iter := ret.axis_iter(axis)
// }
