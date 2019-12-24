module tensor

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
	return empty_contig(shape)
}

pub fn empty_contig(shape []int) Tensor {
	strides := cstrides(shape)
	ndims := shape.len
	size := shape_size(shape)
	buffer := *f64(calloc(size * sizeof(f64)))
	return Tensor {
		shape: shape
		strides: strides
		ndims: ndims
		size: size
		buffer: buffer
		itemsize: sizeof(f64)
		flags: default_flags('C')
	}
}

pub fn empty_fortran(shape []int) Tensor {
	strides := fstrides(shape)
	size := shape_size(shape)
	buffer := *f64(calloc(size * sizeof(f64)))
	return Tensor {
		shape: shape
		strides: strides
		ndims: shape.len
		size: size
		buffer: buffer
		itemsize: sizeof(f64)
		flags: default_flags('F')
	}
}

fn (t Tensor) is_fortran_contiguous() bool {
	if (t.ndims == 0) { return true }
	if (t.ndims == 1) { return t.shape[0] == 1 || t.strides[0] == 1}

	mut sd := 1
	mut i := 0

	for i < t.ndims {
		dim := t.shape[i]
		if (dim == 0) { return true }
		if (t.strides[i] != sd) { return false }
		sd *= dim
		i++
	}

	return true
}

fn (t Tensor) is_contiguous() bool {
	if (t.ndims == 0) { return true }
	if (t.ndims == 1) { return t.shape[0] == 1 || t.strides[0] == 1 }

	mut sd := 1
	mut i := t.ndims - 1

	for i > 0 {
		dim := t.shape[i]
		if (dim == 0) { return true }
		if (t.strides[i] != sd) { return false }
		sd *= dim
		i--
	}
	return true
}

fn (t mut Tensor) update_flags(d map[string]bool) {
	if (d["fortran"] && t.flags["fortran"]) {
		if t.is_fortran_contiguous() {
			t.flags["fortran"] = true
			if t.ndims > 1 {
				t.flags["contiguous"] = false
			}
		} else {
			t.flags["fortran"] = false
		}
	}
	if (d["contiguous"] && t.flags["contiguous"]) {
		if t.is_contiguous() {
			t.flags["contiguous"] = true
			if t.ndims > 1 {
				t.flags["fortran"] = false
			}
		} else {
			t.flags["contiguous"] = false
		}
	}
}

fn delete_at(a []int, index int) []int {
	mut ret := []int
	for i, d in a {
		if (i != index) {
			ret << d
		}
	}
	return ret
}

fn pad_with_zeros(pad []int, ndims int) []int {
	diff := ndims - pad.len
	mut newpad := pad.clone()
	mut i := 0
	for i < diff {
		newpad << 0
		i++
	}
	return newpad
}

fn pad_with_max(pad []int, shape []int, ndims int) []int {
	mut newpad := pad.clone()
	diff := ndims - pad.len
	if diff > 0 {
		newpad << shape[pad.len..]
	}
	return newpad
}