module num

import vnum.ndarray

// Construct a diagonal array.
// Input must be one dimensional and will be placed along
// the resulting diagonal
pub fn diag(a ndarray.NdArray) ndarray.NdArray {
	if a.ndims != 1 {
		panic("Input array must be 1D.  Use diag_flat for higher dimensional arrays")
	}
	ret := zeros([a.size, a.size])
	ret.diagonal().assign(a)
	return ret
}

// Construct a diagonal array.
// The flattened input is placed along the diagonal
// of the resulting matrix
pub fn diag_flat(a ndarray.NdArray) ndarray.NdArray {
	ret := zeros([a.size, a.size])
	ret.diagonal().assign(a.ravel())
	return ret
}

// Lower triangle of an array.
// Modifies an array inplace with elements above the k-th diagonal zeroed.
fn tril_inplace_offset(t ndarray.NdArray, offset int) {
	mut i := 0
	for i < t.shape[0] {
		mut j := 0
		for j < t.shape[1] {
			if i < j - offset {
				t.set([i, j], 0)
			}
			j++
		}
		i++
	}
}

// Upper triangle of an array.
// Modifies an array inplace with elements below the k-th diagonal zeroed.
fn triu_inplace_offset(t ndarray.NdArray, offset int) {
	mut i := 0
	for i < t.shape[0] {
		mut j := 0
		for j < t.shape[1] {
			if i > j - offset {
				t.set([i, j], 0)
			}
			j++
		}
		i++
	}
}

// Lower triangle of an array.
// Returns a copy of an array with elements above the diagonal zeroed
pub fn tril(t ndarray.NdArray) ndarray.NdArray {
	ret := t.copy('C')
	tril_inplace_offset(ret, 0)
	return ret
}

// Lower triangle of an array.
// Returns a copy of an array with elements above the kth diagonal zeroed
pub fn tril_offset(t ndarray.NdArray, offset int) ndarray.NdArray {
	ret := t.copy('C')
	tril_inplace_offset(ret, offset)
	return ret
}

// Lower triangle of an array.
// Modifies an array inplace with elements above the diagonal zeroed.
pub fn tril_inpl(t ndarray.NdArray) {
	tril_inplace_offset(t, 0)
}

// Lower triangle of an array.
// Modifies an array inplace with elements above the k-th diagonal zeroed.
pub fn tril_inpl_offset(t ndarray.NdArray, offset int) {
	tril_inplace_offset(t, offset)
}


// Upper triangle of an array.
// Returns a copy of an array with elements below the diagonal zeroed
pub fn triu(t ndarray.NdArray) ndarray.NdArray {
	ret := t.copy('C')
	triu_inplace_offset(ret, 0)
	return ret
}

// Upper triangle of an array.
// Returns a copy of an array with elements below the kth diagonal zeroed
pub fn triu_offset(t ndarray.NdArray, offset int) ndarray.NdArray {
	ret := t.copy('C')
	triu_inplace_offset(ret, offset)
	return ret
}

// Upper triangle of an array.
// Modifies an array inplace with elements below the diagonal zeroed.
pub fn triu_inpl(t ndarray.NdArray) {
	triu_inplace_offset(t, 0)
}

// Upper triangle of an array.
// Modifies an array inplace with elements below the k-th diagonal zeroed.
pub fn triu_inpl_offset(t ndarray.NdArray, offset int) {
	triu_inpl_offset(t, offset)
}