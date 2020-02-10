module num
// amap maps a function to a single ndarray
pub fn amap(n NdArray, op fn(f64)f64) NdArray {
	ret := allocate_cpu(n.shape, 'C')
	for iter := ret.iter2(n); !iter.done; iter.next() {
		*iter.ptr_a = op(*iter.ptr_b)
	}
	return ret
}

// apply applies a function in place on a single ndarray
pub fn apply(n NdArray, op fn(f64)f64) {
	for iter := n.iter(); !iter.done; iter.next() {
		*iter.ptr = op(*iter.ptr)
	}
}

// map_scalar maps a function with a scalar input to an ndarray
pub fn map_scalar(a NdArray, b f64, op fn(f64, f64)f64) NdArray {
	ret := allocate_cpu(a.shape, 'C')
	for iter := ret.iter2(a); !iter.done; iter.next() {
		*iter.ptr_a = op(*iter.ptr_b, b)
	}
	return ret
}

// map_scalar_lhs maps a function to a scalar and an ndarray
pub fn map_scalar_lhs(a f64, b NdArray, op fn(f64, f64)f64) NdArray {
	ret := allocate_cpu(b.shape, 'C')
	for iter := ret.iter2(b); !iter.done; iter.next() {
		*iter.ptr_a = op(a, *iter.ptr_b)
	}
	return ret
}

// map2 maps a function along two ndarrays
pub fn map2(a NdArray, b NdArray, op fn(f64, f64)f64) NdArray {
	ab,bb := broadcast2(a, b)
	ret := allocate_cpu(ab.shape, 'C')
	for iter := ret.iter3(ab, bb); !iter.done; iter.next() {
		*iter.ptr_a = op(*iter.ptr_b, *iter.ptr_c)
	}
	return ret
}

// apply2 applies a function to two ndarrays, storing the result in // the first ndarray
pub fn apply2(a NdArray, b NdArray, op fn(f64, f64)f64) {
	bb := broadcast_if(b, a.shape)
	for iter := a.iter2(bb); !iter.done; iter.next() {
		*iter.ptr_a = op(*iter.ptr_a, *iter.ptr_b)
	}
}

// map3 maps a function along three ndarrays
pub fn map3(a NdArray, b NdArray, c NdArray, op fn(f64, f64, f64)f64) NdArray {
	ab,bb,cb := broadcast3(a, b, c)
	ret := allocate_cpu(ab.shape, 'C')
	for iter := ret.iter4(ab, bb, cb); !iter.done; iter.next() {
		*iter.ptr_a = op(*iter.ptr_b, *iter.ptr_c, *iter.ptr_d)
	}
	return ret
}

// apply3 applies a function to three ndarrays, storing the result in the // first ndarray
pub fn apply3(a NdArray, b NdArray, c NdArray, op fn(f64, f64, f64)f64) {
	bb := broadcast_if(b, a.shape)
	cb := broadcast_if(c, a.shape)
	for iter := a.iter3(bb, cb); !iter.done; iter.next() {
		*iter.ptr_a = op(*iter.ptr_a, *iter.ptr_b, *iter.ptr_c)
	}
}
