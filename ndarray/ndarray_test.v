import vnum.ndarray as nd

fn test_get() {
	a := nd.from_int([1, 2, 3, 4], [2, 2])
	assert (a.get([1, 1]) == 4.0)
}

fn test_set() {
	a := nd.allocate_ndarray([3, 3], 'C')
	a.set([1, 1], 3.0)
	expected := nd.from_int([0, 0, 0, 0, 3, 0, 0, 0, 0], [3, 3])
	assert (nd.allclose(a, expected))
}

fn test_slice() {
	a := nd.from_int([0, 1, 2, 3, 4, 5, 6, 7, 8], [3, 3])
	slice := a.slice([0])
	expected := nd.from_int([0, 1, 2], [3])
	assert (nd.allclose(expected, slice))
}

fn test_slice_implicit() {
	a := nd.from_int([0, 1, 2, 3], [2, 2])
	slice := a.slice([]int,[1])
	expected := nd.from_int([1, 3], [2])
	assert (nd.allclose(slice, expected))
}

fn test_negative_slice() {
	a := nd.from_int([1, 2, 3], [3])
	slice := a.slice([0, 3, -1])
	expected := nd.from_int([3, 2, 1], [3])
	assert (nd.allclose(slice, expected))
}

fn test_slice_hilo() {
	a := nd.from_int([1, 2, 3, 4], [2, 2])
	slice := a.slice_hilo([0], [2])
	assert (nd.allclose(a, slice))
}

fn test_slice_flags() {
	a := nd.from_int([1, 2, 3], [3])
	assert (a.flags.owndata)
	slice := a.slice([]int)
	assert (!slice.flags.owndata)
}

fn test_assign_broadcast() {
	a := nd.from_int([1, 2, 3, 4], [2, 2])
	slice := a.slice([0])
	a.assign(slice)
	expected := nd.from_int([1, 2, 1, 2], [2, 2])
	assert (nd.allclose(expected, a))
}

fn test_assign_same_shape() {
	a := nd.from_int([1, 2, 3, 4], [2, 2])
	slice := a.slice([0])
	a.slice([1]).assign(slice)
	expected := nd.from_int([1, 2, 1, 2], [2, 2])
	assert (nd.allclose(expected, a))
}

fn test_fill() {
	a := nd.from_int([1, 2, 3, 4], [2, 2])
	a.fill(10)
	expected := nd.from_int([10, 10, 10, 10], [2, 2])
	assert (nd.allclose(expected, a))
}

fn test_copy() {
	a := nd.from_int([1, 2, 3], [3])
	d := a.copy('C')
	assert (nd.allclose(d, a))
}

fn test_copy_no_update() {
	a := nd.from_int([1, 2, 3], [3])
	d := a.copy('C')
	d.fill(2)
	assert (!nd.allclose(d, a))
}

fn test_view() {
	a := nd.from_int([1, 2, 3], [3])
	d := a.view()
	assert (nd.allclose(a, d))
	assert (!d.flags.owndata)
}

fn test_diagonal() {
	a := nd.from_int([1, 2, 3, 4], [2, 2])
	d := a.diagonal()
	expected := nd.from_int([1, 4], [2])
	assert (nd.allclose(d, expected))
}

fn test_reshape() {
	a := nd.from_int_1d([1, 2, 3, 4])
	res := a.reshape([2, 2])
	expected := nd.from_int([1, 2, 3, 4], [2, 2])
	assert (nd.allclose(res, expected))
}

fn test_reshape_infer() {
	a := nd.from_int_1d([1, 2, 3, 4])
	res := a.reshape([-1, 2])
	expected := nd.from_int([1, 2, 3, 4], [2, 2])
	assert (nd.allclose(res, expected))
}

fn test_transpose() {
	a := nd.from_int([1, 2, 3, 4], [2, 2])
	v1 := a.transpose([1, 0])
	v2 := a.t()
	v3 := a.swapaxes(1, 0)
	assert (nd.allclose(v1, v2))
	assert (nd.allclose(v2, v3))
}
