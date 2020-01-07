import vnum.num
import vnum.ndarray as nd

fn test_diag() {
	a := nd.from_int_1d([1, 2, 3])
	expected := nd.from_int([1, 0, 0, 0, 2, 0, 0, 0, 3], [3, 3])
	result := num.diag(a)
	assert (nd.allclose(result, expected))
}

fn test_diag_flat() {
	a := nd.from_int([1, 2, 3, 4], [2, 2])
	expected := nd.from_int([1, 0, 0, 0, 0, 2, 0, 0, 0, 0, 3, 0, 0, 0, 0, 4], [4, 4])
	result := num.diag_flat(a)
	assert (nd.allclose(result, expected))
}

fn test_tril() {
	a := nd.from_int([1, 2, 3, 4], [2, 2])
	expected := nd.from_int([1, 0, 3, 4], [2, 2])
	result := num.tril(a)
	assert (nd.allclose(result, expected))
}

fn test_triu() {
	a := nd.from_int([1, 2, 3, 4], [2, 2])
	expected := nd.from_int([1, 2, 0, 4], [2, 2])
	result := num.triu(a)
	assert (nd.allclose(result, expected))
}

fn test_tril_offset() {
	a := nd.from_int([1, 2, 3, 4, 5, 6, 7, 8, 9], [3, 3])
	expected := nd.from_int([0, 0, 0, 4, 0, 0, 7, 8, 0], [3, 3])
	result := num.tril_offset(a, -1)
	assert (nd.allclose(result, expected))
}

fn test_triu_offset() {
	a := nd.from_int([1, 2, 3, 4, 5, 6, 7, 8, 9], [3, 3])
	expected := nd.from_int([0, 2, 3, 0, 0, 6, 0, 0, 0], [3, 3])
	result := num.triu_offset(a, 1)
	assert (nd.allclose(result, expected))
}
