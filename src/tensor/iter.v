module tensor

struct NdIter {
	pub mut:
		ptr &f64
		shape []int
		strides []int
		track []int
		dim int
}

fn (iter mut NdIter) next() &f64 {
	ret := iter.ptr
	mut i := iter.dim
	for i >= 0 {
		iter.track[i] += 1
		shape_i := iter.shape[i]
		stride_i := iter.strides[i]

		if (iter.track[i] == iter.shape[i]) {
			iter.track[i] = 0
			iter.ptr -= (shape_i - 1) * stride_i
			i--
			continue
		}
		iter.ptr += stride_i
		break
	}
	return ret
}