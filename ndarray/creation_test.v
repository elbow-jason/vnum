import vnum.ndarray as nd
import vnum.internal

fn test_empty_shape() {
	a := nd.allocate_ndarray([], 'C')
	assert (a.shape.len == 0)
	assert (a.strides.len == 1)
	assert (a.strides[0] == 1)
	assert (a.size == 1)
}

fn test_shape_contig() {
	a := nd.allocate_ndarray([2, 2], 'C')
	assert (a.size == 4)
	assert (internal.array_equal(a.strides, [2, 1]))
	assert (a.flags.contiguous)
	assert (!a.flags.fortran)
}

fn test_shape_fortran() {
	a := nd.allocate_ndarray([2, 2], 'F')
	assert (a.size == 4)
	assert (internal.array_equal(a.strides, [1, 2]))
	assert (a.flags.fortran)
	assert (!a.flags.contiguous)
}
