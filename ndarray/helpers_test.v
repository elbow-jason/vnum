import vnum.ndarray as nd
import vnum.internal

fn test_offset() {
	a := nd.allocate_ndarray([3, 3], 'C')
	index := [1, 1]
	expected := 4
	assert (nd.offset(a, index) == expected)
}

fn test_negative_strides() {
	a := nd.from_int([1, 2, 3], [3])
	view := nd.as_strided(a, [3], [-1])
	ptr := view.buffer
	off := nd.offset_ptr(ptr, view.shape, view.strides)
	assert (*off == f64(3.0))
}

fn test_pad_zeros() {
	arr := [1]
	ndims := 3
	expected := [1, 0, 0]
	assert (internal.array_equal(expected, nd.pad_with_zeros(arr, ndims)))
}

fn test_pad_max() {
	arr := [1]
	max := [3, 4, 5]
	ndims := 3
	expected := [1, 4, 5]
	assert (internal.array_equal(expected, nd.pad_with_max(arr, max, ndims)))
}
