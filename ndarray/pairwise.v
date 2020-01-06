module ndarray

import math

// adds two ndarrays elementwise, reducing using
// an nd_iter_with
pub fn (iterator NdIterWith) add() NdArray {
	return with_op(iterator, add_)
}

// subtracts two ndarrays elementwise, reducing using
// an nd_iter_with
pub fn (iterator NdIterWith) subtract() NdArray {
	return with_op(iterator, subtract_)
}

// multiplies two ndarrays elementwise, reducing using
// an nd_iter_with
pub fn (iterator NdIterWith) multiply() NdArray {
	return with_op(iterator, multiply_)
}

// divides two ndarrays elementwise, reducing using
// an nd_iter_with
pub fn (iterator NdIterWith) divide() NdArray {
	return with_op(iterator, divide_)
}

// maximizes two ndarrays elementwise, reducing using
// an nd_iter_with
pub fn (iterator NdIterWith) maximum() NdArray {
	return with_op(iterator, math.max)
}

// minimizes two ndarrays elementwise, reducing using
// an nd_iter_with
pub fn (iterator NdIterWith) minimum() NdArray {
	return with_op(iterator, math.min)
}

// adds an ndarray and a scalar elementwise, reducing using
// a scalar iter
pub fn (iterator ScalarIter) add() NdArray {
	return with_scalar_op(iterator, add_)
}

// subtracts an ndarray and a scalar elementwise, reducing using
// a scalar iter
pub fn (iterator ScalarIter) subtract() NdArray {
	return with_scalar_op(iterator, subtract_)
}

// multiplies an ndarray and a scalar elementwise, reducing using
// a scalar iter
pub fn (iterator ScalarIter) multiply() NdArray {
	return with_scalar_op(iterator, multiply_)
}

// divides an ndarray and a scalar elementwise, reducing using
// a scalar iter
pub fn (iterator ScalarIter) divide() NdArray {
	return with_scalar_op(iterator, divide_)
}