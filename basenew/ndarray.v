module basenew

import vnum.internal

pub struct NdArray {
pub mut:
	shape    []int
	strides  []int
	ndims    int
	size     int
	flags    ArrayFlags
pub:
	buffer   &f64
}