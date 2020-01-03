module ndarray

struct NdIter {
pub mut:
	ptr     &f64
	done    bool
	shape   []int
	strides []int
	track   []int
	dim     int
}

pub fn (iter mut NdIter) next() bool {
	if iter.done {
		return true
	}
	mut i := iter.dim
	mut track := iter.track
	for i >= 0 {
		track[i]++
		shape_i := iter.shape[i]
		stride_i := iter.strides[i]
		if (track[i] == iter.shape[i]) {
			if i == 0 {
				iter.done = true
			}
			track[i] = 0
			iter.ptr -= (shape_i - 1) * stride_i
			i--
			continue
		}
		iter.ptr += stride_i
		break
	}
	return false
}

struct NdIterWith {
pub mut:
	ptr_a     &f64
	ptr_b     &f64
	done      bool
	shape     []int
	strides_a []int
	strides_b []int
	track     []int
	dim       int
}

pub fn (iter mut NdIterWith) next() bool {
	if iter.done {
		return true
	}
	mut i := iter.dim
	mut track := iter.track
	for i >= 0 {
		track[i]++
		shape_i := iter.shape[i]
		stride_ia := iter.strides_a[i]
		stride_ib := iter.strides_b[i]
		if (track[i] == iter.shape[i]) {
			if i == 0 {
				iter.done = true
			}
			track[i] = 0
			iter.ptr_a -= (shape_i - 1) * stride_ia
			iter.ptr_b -= (shape_i - 1) * stride_ib
			i--
			continue
		}
		iter.ptr_a += stride_ia
		iter.ptr_b += stride_ib
		break
	}
	return false
}

struct AxesIter {
pub mut:
	ptr     &f64
	shape   []int
	strides []int
	inc     int
	tmp     NdArray
	axis    int
}

pub fn (iter mut AxesIter) next() NdArray {
	ret := iter.tmp
	iter.ptr += iter.inc
	iter.tmp = NdArray{
		buffer: iter.ptr
		shape: ret.shape
		strides: iter.strides
		flags: ret.flags
		ndims: ret.ndims
		size: ret.size
	}
	return ret
}
