module tensor

pub fn concatenate(ts []Tensor, axis int) {
	mut newshape := ts[0].shape.clone()
	newshape[axis] = 0
	newshape = assert_shape_off_axis(ts, axis, newshape)
	ret := empty_contig(newshape)
}

fn assert_shape_off_axis(ts []Tensor, axis int, shape []int) []int {
	mut retshape := shape.clone()
	for t in ts {
		if (t.shape.len != shape.len) {
			// panic here
		}

		mut i := 0
		for i < shape.len {
			if (i != axis && t.shape[axis] != shape[i]) {
				// panic here
			}
			i++
		}
		retshape[axis] += t.shape[axis]
	}
	return retshape
}