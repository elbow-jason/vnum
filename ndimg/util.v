module ndimg

import vnum.num

fn raise_on_shape_mismatch(s1, s2 []int) {
	if !num.shape_compare(s1, s2) {
		panic('Images must have the same shape')
	}
}

pub fn compare_images_diff(image1, image2 num.NdArray) num.NdArray {
	raise_on_shape_mismatch(image1.shape, image2.shape)
	return num.abs(num.subtract(image2, image1))
}

fn blend_fn(a f64, b f64) f64 {
	return f64(0.5) * (b + a)
}

pub fn compare_images_blend(image1, image2 num.NdArray) num.NdArray {
	raise_on_shape_mismatch(image1.shape, image2.shape)
	return num.map2(image1, image2, blend_fn)
}

pub fn view_as_windows(arr_in num.NdArray, window_shape []int) num.NdArray {
	for i := 0; i < arr_in.ndims; i++ {
		if arr_in.shape[i] - window_shape[i] < 0 {
			panic('Window shape is too large')
		}
		else if window_shape[i] - 1 < 0 {
			panic('Window shape is too small')
		}
	}
	mut newstrides := arr_in.strides
	newstrides << arr_in.strides
	mut win_indices_shape := []int
	for i := 0; i < arr_in.ndims; i++ {
		win_indices_shape << arr_in.shape[i] - window_shape[i] + 1
	}
	mut new_shape := win_indices_shape
	new_shape << window_shape
	return num.as_strided(arr_in, new_shape, newstrides)
}
