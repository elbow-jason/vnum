module basenew

fn offset(shape []int, strides []int, idx []int) int {
	mut offset := 0
	for i, stride in strides {
		mut idxer := idx[i]
		if idxer < 0 {
			idxer += shape[i]
		}
		offset += idxer * stride
	}
	return offset
}