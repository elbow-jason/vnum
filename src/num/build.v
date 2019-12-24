module num
import tensor

pub fn concatenate(ts []tensor.Tensor, axis int) tensor.Tensor {
	mut newshape := ts[0].shape.clone()
	newshape[axis] = 0
	newshape = assert_shape_off_axis(ts, axis, newshape)
	ret := tensor.empty_contig(newshape)
	mut lo := [0].repeat(newshape.len)
	mut hi := newshape.clone()
	hi[axis] = 0
	for t in ts {
		if t.shape[axis] != 0 {
			hi[axis] += t.shape[axis]
			ret.set_view(lo, hi, t)
			lo[axis] = hi[axis]
		}
	}
	return ret
}

fn assert_shape_off_axis(ts []tensor.Tensor, axis int, shape []int) []int {
	mut retshape := shape.clone()
	for t in ts {
		if (t.shape.len != shape.len) {
			panic("All inputs must share the same number of axes")
		}

		mut i := 0
		for i < shape.len {
			if (i != axis && t.shape[axis] != shape[i]) {
				panic("All inputs must share a shape off axis")
			}
			i++
		}
		retshape[axis] += t.shape[axis]
	}
	return retshape
}