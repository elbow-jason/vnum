module num

struct NdIter {
pub mut:
	ptr     &f64
	shape   []int
	strides []int
	track   []int
	dim     int
}

pub fn (iter mut NdIter) next() &f64 {
	ret := iter.ptr
	mut i := iter.dim
	mut track := iter.track
	for i >= 0 {
		track[i]++
		shape_i := iter.shape[i]
		stride_i := iter.strides[i]
		if (track[i] == iter.shape[i]) {
			track[i] = 0
			iter.ptr -= (shape_i - 1) * stride_i
			i--
			continue
		}
		iter.ptr += stride_i
		break
	}
	return ret
}

struct AxesIter {
pub mut:
	ptr     &f64
	shape   []int
	strides []int
	inc     int
	tmp     Tensor
	axis    int
}

pub fn (iter mut AxesIter) next() Tensor {
	ret := iter.tmp
	iter.ptr += iter.inc
	iter.tmp = Tensor {
		buffer: iter.ptr
		shape: ret.shape
		strides: iter.strides
		flags: ret.flags
		ndims: ret.ndims
		size: ret.size
		itemsize: ret.itemsize
	}
	return ret
}
