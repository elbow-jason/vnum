import vnum.num
import vnum.internal
import vnum.ndarray as nd

fn test_empty() {
	a := num.empty([3, 3])
	assert (internal.array_equal(a.shape, [3, 3]))
	assert (internal.array_equal(a.strides, [3, 1]))
	assert (a.size == 9)
	assert (a.ndims == 2)
}

fn test_empty_like() {
	t := num.empty([3, 3])
	a := num.empty_like(t)
	assert (internal.array_equal(a.shape, [3, 3]))
	assert (internal.array_equal(a.strides, [3, 1]))
	assert (a.size == 9)
	assert (a.ndims == 2)
}

fn test_eye() {
	res := num.eye(3, 3, 0)
	expected := nd.from_int([1, 0, 0, 0, 1, 0, 0, 0, 1], [3, 3])
	assert (nd.allclose(res, expected))
}

fn test_eye_different_shape() {
	res := num.eye(2, 4, 0)
	expected := nd.from_int([1, 0, 0, 0, 0, 1, 0, 0], [2, 4])
	assert (nd.allclose(res, expected))
}

fn test_eye_offset() {
	res := num.eye(3, 3, 1)
	expected := nd.from_int([0, 1, 0, 0, 0, 1, 0, 0, 0], [3, 3])
	assert (nd.allclose(res, expected))
}

fn test_identity() {
	res := num.identity(3)
	expected := nd.from_int([1, 0, 0, 0, 1, 0, 0, 0, 1], [3, 3])
	assert (nd.allclose(res, expected))
}

fn test_full() {
	res := num.full([2, 2], 2)
	expected := nd.from_int([2, 2, 2, 2], [2, 2])
	assert (nd.allclose(res, expected))
}

fn test_full_like() {
	res := num.full([2, 2], 2)
	result := num.full_like(res, 2)
	assert (nd.allclose(res, result))
}

fn test_zeros() {
	res := num.zeros([2, 2])
	expected := nd.from_int([0, 0, 0, 0], [2, 2])
	assert (nd.allclose(res, expected))
}

fn test_zeros_like() {
	res := num.full([2, 2], 0)
	result := num.zeros_like(res)
	assert (nd.allclose(res, result))
}

fn test_ones() {
	res := num.ones([2, 2])
	expected := nd.from_int([1, 1, 1, 1], [2, 2])
	assert (nd.allclose(res, expected))
}

fn test_ones_like() {
	res := num.full([2, 2], 1)
	result := num.ones_like(res)
	assert (nd.allclose(res, result))
}
