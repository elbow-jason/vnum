module ndarray

// The core iterator for an ndarray, iterates through a flattened
// view of an array, always treating the memory layout as
// c-contigious, so it doesn't matter what the memory layout
// of arrays passed is.
struct NdIter {
pub mut:
	ptr     &f64
	done    bool
	size 	int
	shape   []int
	strides []int
	track   []int
	dim     int
}

// next increments an nd-iterator by a single value, returning true
// if the iterator has been exhausted and updating the `done` flag.
// This function always increments arrays that are fortran contiguous
// and c-contiguous in the same order, so no adjustments need to be
// made.
//
// TODO: optimize for c-contiguous arrays that can be iterated over
// in a flat order.
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

// The core iterator for an ndarray, iterates through a flattened
// view of an array, always treating the memory layout as
// c-contigious, so it doesn't matter what the memory layout
// of arrays passed is.
struct ScalarIter {
pub mut:
	ret 	NdArray
	ptr     &f64
	done    bool
	size 	int
	shape   []int
	strides []int
	track   []int
	dim     int
	scalar  f64
}

// next increments an nd-iterator by a single value, returning true
// if the iterator has been exhausted and updating the `done` flag.
// This function always increments arrays that are fortran contiguous
// and c-contiguous in the same order, so no adjustments need to be
// made.
//
// TODO: optimize for c-contiguous arrays that can be iterated over
// in a flat order.
pub fn (iter mut ScalarIter) next() bool {
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

// The core iterator of pairwise operations on two ndarrays.
// Iterates through two flattened ndarrays, updating the stored
// pointers of each array.
struct NdIterWith {
pub mut:
	ret 	  NdArray
	ptr_a     &f64
	ptr_b     &f64
	done      bool
	shape     []int
	strides_a []int
	strides_b []int
	track     []int
	dim       int
}

// next increments an nd-iterator by a single value, returning true
// if the iterator has been exhausted and updating the `done` flag.
// This function always increments arrays that are fortran contiguous
// and c-contiguous in the same order, so no adjustments need to be
// made.
//
// TODO: optimize for c-contiguous arrays that can be iterated over
// in a flat order.
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

// AxesIter is the core iterator for axis-wise operations.
// Stores a copy of an ndarray reduced along a given axis
struct AxesIter {
pub mut:
	ptr     &f64
	shape   []int
	strides []int
	inc     int
	tmp     NdArray
	axis    int
	size	int
}

// next increments the axes iter to store the next reduced
// ndarray along an axis
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
