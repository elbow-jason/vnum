module num

import vnum.ndarray

// t + t
pub fn add(a ndarray.NdArray, b ndarray.NdArray) ndarray.NdArray {
	return a.add(b)
}

// t outer add t
pub fn add_outer(a ndarray.NdArray, b ndarray.NdArray) ndarray.NdArray {
	return ndarray.op_outer(a, b, ndarray.add_)
}

// t + 6
pub fn adds(a ndarray.NdArray, b f64) ndarray.NdArray {
	return a.adds(b)
}

// 6 + t
pub fn sadd(a f64, b ndarray.NdArray) ndarray.NdArray {
	return b.sadd(a)
}

// t - t
pub fn subtract(a ndarray.NdArray, b ndarray.NdArray) ndarray.NdArray {
	return a.subtract(b)
}

// t outer subtract t
pub fn subtract_outer(a ndarray.NdArray, b ndarray.NdArray) ndarray.NdArray {
	return ndarray.op_outer(a, b, ndarray.subtract_)
}

// t - 6
pub fn subtracts(a ndarray.NdArray, b f64) ndarray.NdArray {
	return a.subtracts(b)
}

// 6 - t
pub fn ssubtract(a f64, b ndarray.NdArray) ndarray.NdArray {
	return b.ssubtract(a)
}

// t * t
pub fn multiply(a ndarray.NdArray, b ndarray.NdArray) ndarray.NdArray {
	return a.multiply(b)
}

// t outer multiply t
pub fn multiply_outer(a ndarray.NdArray, b ndarray.NdArray) ndarray.NdArray {
	return ndarray.op_outer(a, b, ndarray.multiply_)
}

// t * 6
pub fn multiplys(a ndarray.NdArray, b f64) ndarray.NdArray {
	return a.multiplys(b)
}

// 6 * t
pub fn smultiply(a f64, b ndarray.NdArray) ndarray.NdArray {
	return b.smultiply(a)
}

// t / t
pub fn divide(a ndarray.NdArray, b ndarray.NdArray) ndarray.NdArray {
	return a.divide(b)
}

// t outer divide t
pub fn divide_outer(a ndarray.NdArray, b ndarray.NdArray) ndarray.NdArray {
	return ndarray.op_outer(a, b, ndarray.divide_)
}


// t / 6
pub fn divides(a ndarray.NdArray, b f64) ndarray.NdArray {
	return a.divides(b)
}

// 6 / t
pub fn sdivide(a f64, b ndarray.NdArray) ndarray.NdArray {
	return b.sdivide(a)
}
