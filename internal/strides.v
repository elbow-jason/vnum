module internal

pub fn cstrides(shape []int) []int {
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

pub fn fstrides(shape []int) []int {
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

pub fn is_fortran_contiguous(shape []int, strides []int, ndims int) bool {
	if (ndims == 0) {
		return true
	}
	if (ndims == 1) {
		return shape[0] == 1 || strides[0] == 1
	}
	mut sd := 1
	mut i := 0
	for i < ndims {
		dim := shape[i]
		if (dim == 0) {
			return true
		}
		if (strides[i] != sd) {
			return false
		}
		sd *= dim
		i++
	}
	return true
}

pub fn is_contiguous(shape []int, strides []int, ndims int) bool {
	if (ndims == 0) {
		return true
	}
	if (ndims == 1) {
		return shape[0] == 1 || strides[0] == 1
	}
	mut sd := 1
	mut i := ndims - 1
	for i > 0 {
		dim := shape[i]
		if (dim == 0) {
			return true
		}
		if (strides[i] != sd) {
			return false
		}
		sd *= dim
		i--
	}
	return true
}

pub fn filter_shape_not_strides(shape []int, strides []int) ([]int,[]int) {
	mut newshape := []int
	mut newstrides := []int
	for i := 0; i < shape.len; i++ {
		if shape[i] != 0 {
			newshape << shape[i]
			newstrides << strides[i]
		}
	}
	return newshape,newstrides
}
