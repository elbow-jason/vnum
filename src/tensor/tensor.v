module tensor

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

pub fn from_shape(shape []int) Tensor {
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

pub fn (t Tensor) set(idx []int, val f64) {
	mut offset := 0
	mut i := 0
	for i < t.ndims {
		offset += idx[i] * t.strides[i]
		i++
	}
	mut ptr := t.buffer + offset
	*ptr = val
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

pub fn (t Tensor) str() string {
	mut printer := init_printer(t)
	return printer.print()
}