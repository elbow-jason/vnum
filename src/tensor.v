struct Tensor {
	shape []int
	strides []int
	ndims int
	size int
	itemsize int
	buffer &f64
}

fn cstrides(shape []int) []int {
	mut sz := 1
	mut ii := 0
	ndims := shape.len
	mut strides := [0].repeat(ndims)

	for ii < ndims {
		strides[ndims - ii - 1] = sz
		sz *= shape[ndims - ii - 1]
		ii++
	}

	return strides
}

fn fstrides(shape []int) []int {
	mut sz := 1
	mut ii := 0
	ndims := shape.len
	mut strides := [0].repeat(ndims)

	for ii < ndims {
		strides[ii] = sz
		sz *= shape[ii]
		ii++
	}

	return strides
}

fn shape_size(shape []int) int {
	mut sz := 1
	for s in shape {
		sz *= s
	}
	return sz
}

fn from_shape(shape []int) Tensor {
	strides := cstrides(shape)
	ndims := shape.len
	size := shape_size(shape)
	buffer := *f64(calloc(size * 8))
	return Tensor {
		shape: shape
		strides: strides
		ndims: ndims
		size: size
		buffer: buffer
		itemsize: 8
	}
}

fn (t Tensor) get(idx []int) f64 {
	mut offset := 0
	mut i := 0
	for i < t.ndims {
		offset += idx[i] * t.strides[i]
		i++
	}
	return *(t.buffer + offset)
}

fn (t Tensor) set(idx []int, val f64) {
	mut offset := 0
	mut i := 0
	for i < t.ndims {
		offset += idx[i] * t.strides[i]
		i++
	}
	mut ptr := t.buffer + offset
	*ptr = val
}

struct NdIter {
	pub mut:
		ptr &f64
		shape []int
		strides []int
		track []int
		dim int
}

fn (t Tensor) flat_iter() NdIter {
	ptr := t.buffer
	shape := t.shape
	dim := t.ndims - 1
	track := [0].repeat(dim+1)
	strides := t.strides
	return NdIter{
		ptr: ptr
		shape: shape
		dim: dim
		track: track
		strides: strides
	}
}

fn (iter mut NdIter) next() &f64 {
	mut ret := iter.ptr
	mut i := iter.dim
	for i >= 0 {
		iter.track[i] += 1
		shape_i := iter.shape[i]
		stride_i := iter.strides[i]

		if (iter.track[i] == iter.shape[i]) {
			iter.track[i] = 0
			ret -= (shape_i - 1) * stride_i
			i--
			continue
		}
		ret += stride_i
		break
	}
	iter.ptr = ret
	return ret
}