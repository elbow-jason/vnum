import vnum.num

fn test_assert_1d_passes() {
	a := num.empty([4])
	b := num.empty([3])
	num.assert_all_1d([a, b])
}

fn test_assert_shape() {
	a := num.empty([2, 2])
	b := num.empty([2, 2])
	num.assert_shape([2, 2], [a, b])
}
