module internal

pub fn shape_size(shape []int) int {
	mut sz := 1
	for s in shape {
		sz *= s
	}
	return sz
}

pub fn array_equal(a []int, b []int) bool {
	if a.len != b.len {
		return false
	}
	for i := 0; i < a.len; i++ {
		if a[i] != b[i] {
			return false
		}
	}
	return true
}
