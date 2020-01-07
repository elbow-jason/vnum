import vnum.ndarray as nd

fn get_input() ndarray.NdArray {
	return nd.from_int([1, 2, 3, 4, 5, 6, 7, 8, 9], [3, 3])
}

fn test_sum() {
	a := get_input()
	result := a.iter().sum()
	assert (result == 45)
}

fn test_prod() {
	a := get_input()
	result := a.iter().prod()
	assert (result == 362880)
}

fn test_mean() {
	a := get_input()
	result := a.iter().mean()
	assert (result == 5)
}

fn test_max() {
	a := get_input()
	result := a.iter().max()
	assert (result == 9)
}

fn test_min() {
	a := get_input()
	result := a.iter().min()
	assert (result == 1)
}

fn test_ptp() {
	a := get_input()
	result := a.iter().ptp()
	assert (result == 8)
}

fn test_axis_sum() {
	a := get_input()
	result := a.axis(0).sum()
	expected := nd.from_int_1d([12, 15, 18])
	assert (nd.allclose(result, expected))
}

fn test_axis_sum_keepdims() {
	a := get_input()
	result := a.axis_with_dims(0).sum()
	expected := nd.from_int([12, 15, 18], [1, 3])
	assert (nd.allclose(result, expected))
}

fn test_axis_mean() {
	a := get_input()
	result := a.axis(0).mean()
	expected := nd.from_int_1d([4, 5, 6])
	assert (nd.allclose(result, expected))
}

fn test_axis_mean_keepdims() {
	a := get_input()
	result := a.axis_with_dims(0).mean()
	expected := nd.from_int([4, 5, 6], [1, 3])
	assert (nd.allclose(result, expected))
}

fn test_axis_minimum() {
	a := get_input()
	result := a.axis(0).minimum()
	expected := nd.from_int_1d([1, 2, 3])
	assert (nd.allclose(result, expected))
}

fn test_axis_minimum_keepdims() {
	a := get_input()
	result := a.axis_with_dims(0).minimum()
	expected := nd.from_int([1, 2, 3], [1, 3])
	assert (nd.allclose(result, expected))
}

fn test_axis_maximum() {
	a := get_input()
	result := a.axis(0).maximum()
	expected := nd.from_int_1d([7, 8, 9])
	assert (nd.allclose(result, expected))
}

fn test_axis_maximum_keepdims() {
	a := get_input()
	result := a.axis_with_dims(0).maximum()
	expected := nd.from_int([7, 8, 9], [1, 3])
	assert (nd.allclose(result, expected))
}
