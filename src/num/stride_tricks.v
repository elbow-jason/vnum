module num

fn broadcastable(arr Tensor, other Tensor) []int {
	sz := arr.shape.len
	osz := other.shape.len

	if sz == osz {
		if broadcast_equal(arr.shape, other.shape) {
			return broadcastable_shape(arr.shape, other.shape)
		}
	} else {
		if sz > osz {
			mut othershape := [1].repeat(sz - osz)
			othershape << other.shape
			if broadcast_equal(arr.shape, othershape) {
				return broadcastable_shape(arr.shape, othershape)
			}
		} else {
			mut selfshape := [1].repeat(osz - sz)
			selfshape << arr.shape
			if broadcast_equal(selfshape, other.shape) {
				return broadcastable_shape(selfshape, other.shape)
			}
		}
	}
	panic("Shapes $arr.shape and $other.shape are not broadcastable")
}

fn broadcast_equal(a []int, b []int) bool {
	mut bc := true
	for i, v in a {
		if !(v == b[i] || v == 1 || b[i] == 1) {
			bc = false
		}
	}
	return bc
}

fn broadcast_strides(dest_shape []int, src_shape []int, dest_strides []int, src_strides []int) []int {
	dims := dest_shape.len
	start := dims - src_shape.len
	mut ret := [0].repeat(dims)

	mut i := dims - 1
	for i >= start {
		s := src_shape[i - start]
		if s == 1 {
			ret[i] = 0
		} else if s == dest_shape[i] {
			ret[i] = src_strides[i - start]
		} else {
			panic("Cannot broadcast from $src_shape to $dest_shape")
		}
		i--
	}
	return ret
}

fn broadcastable_shape(a []int, b []int) []int {
	mut ret := []int
	for i, aval in a {
		if aval > b[i] {
			ret << aval
		} else {
			ret << b[i]
		}
	}
	return ret
}

pub fn broadcast_to(t Tensor, newshape []int) Tensor {
	defstrides := cstrides(newshape)
	newstrides := broadcast_strides(newshape, t.shape, defstrides, t.strides)
	newflags := no_flags()
	return Tensor{
		buffer: t.buffer,
		shape: newshape,
		strides: newstrides,
		flags: newflags,
		size: shape_size(newshape)
		ndims: newshape.len
		itemsize: t.itemsize
	}
}