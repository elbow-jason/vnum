import vnum.ndarray as nd
import vnum.internal

fn test_broadcast_to() {
	m := nd.from_int_1d([1, 2, 3])
	b := nd.broadcast_to(m, [3, 3])
	expected := nd.from_int([1, 2, 3, 1, 2, 3, 1, 2, 3], [3, 3])
	assert (nd.allclose(b, expected))
}

fn test_broadcast_column() {
	m := nd.from_int([1, 2, 3], [3, 1])
	b := nd.broadcast_to(m, [3, 3])
	expected := nd.from_int([1, 1, 1, 2, 2, 2, 3, 3, 3], [3, 3])
	assert (nd.allclose(b, expected))
}

fn test_broadcastable_same_shape() {
	m := nd.from_int([1, 2, 3, 4], [2, 2])
	shape := nd.broadcastable(m, m)
	assert internal.array_equal(m.shape, shape)
}

fn test_broadcastable_different_shape() {
	a := nd.allocate_ndarray([8, 1, 6, 1], 'C')
	b := nd.allocate_ndarray([7, 1, 5], 'C')
	shape := nd.broadcastable(a, b)
	assert internal.array_equal(shape, [8, 7, 6, 5])
}

fn test_as_strided() {
	a := nd.from_int_1d([0, 1, 2, 3, 4, 5, 6, 7])
	n := a.strides[0]
	res := nd.as_strided(a, [5, 3], [n, n])
	expected := nd.from_int([0, 1, 2, 1, 2, 3, 2, 3, 4, 3, 4, 5, 4, 5, 6], [5, 3])
	assert (nd.allclose(res, expected))
}

fn test_expand_dims() {
	a := nd.from_int([1, 2, 3, 4], [2, 2])
	res := nd.expand_dims(a, 1)
	expected := nd.from_int([1, 2, 3, 4], [2, 1, 2])
	assert (nd.allclose(res, expected))
}
