module tensor
import strings

struct Tensor {
	itemsize int
	buffer &f64
	pub:
		shape []int
		strides []int
		ndims int
		size int
		flags map[string]bool
}

fn default_flags(order string) map[string]bool {
	mut m := {
		"contiguous": false
		"fortran": false
		"owndata": true
		"write": true
	}
	if (order == 'F') {
		m["fortran"] = true
	} else if (order == 'C') {
		m["contiguous"] = true
	}
	return m
}

pub fn (f map[string]bool) str() string {
	mut io := strings.new_builder(1000)
	io.write("C_CONTIGUOUS: ")
	io.write(f["contiguous"].str())
	io.write("\nF_CONTIGUOUS: ")
	io.write(f["fortran"].str())
	io.write("\nOWNDATA: ")
	io.write(f["owndata"].str())
	io.write("\nWRITE: ")
	io.write(f["write"].str())
	return io.str()
}

fn all_flags() map[string]bool {
	m := {
		"contiguous": true
		"fortran": true
		"owndata": true
		"write": true
	}
	return m
}

fn cstrides(shape []int) []int {
	mut sz := 1
	mut ii := 0
	ndims := shape.len
	mut strides := [0].repeat(ndims)

	for ii < ndims {
		strides[ndims - ii - 1] = sz
		sz *= shape[ndims - ii - 1]
		ii++
	}

	return strides
}

fn fstrides(shape []int) []int {
	mut sz := 1
	mut ii := 0
	ndims := shape.len
	mut strides := [0].repeat(ndims)

	for ii < ndims {
		strides[ii] = sz
		sz *= shape[ii]
		ii++
	}

	return strides
}

fn shape_size(shape []int) int {
	mut sz := 1
	for s in shape {
		sz *= s
	}
	return sz
}

pub fn from_shape(shape []int) Tensor {
	strides := cstrides(shape)
	ndims := shape.len
	size := shape_size(shape)
	buffer := *f64(calloc(size * 8))
	return Tensor {
		shape: shape
		strides: strides
		ndims: ndims
		size: size
		buffer: buffer
		itemsize: 8
		flags: default_flags('C')
	}
}

fn (t Tensor) get(idx []int) f64 {
	mut offset := 0
	mut i := 0
	for i < t.ndims {
		offset += idx[i] * t.strides[i]
		i++
	}
	return *(t.buffer + offset)
}

pub fn (t Tensor) set(idx []int, val f64) {
	mut offset := 0
	mut i := 0
	for i < t.ndims {
		offset += idx[i] * t.strides[i]
		i++
	}
	mut ptr := t.buffer + offset
	*ptr = val
}

pub fn (t Tensor) is_fortran_contiguous() bool {
	if (t.ndims == 0) { return true }
	if (t.ndims == 1) { return t.shape[0] == 1 || t.strides[0] == 1}

	mut sd := 1
	mut i := 0

	for i < t.ndims {
		dim := t.shape[i]
		if (dim == 0) { return true }
		if (t.strides[i] != sd) { return false }
		sd *= dim
		i++
	}

	return true
}

pub fn (t Tensor) is_contiguous() bool {
	if (t.ndims == 0) { return true }
	if (t.ndims == 1) { return t.shape[0] == 1 || t.strides[0] == 1 }

	mut sd := 1
	mut i := t.ndims - 1

	for i > 0 {
		dim := t.shape[i]
		if (dim == 0) { return true }
		if (t.strides[i] != sd) { return false }
		sd *= dim
		i--
	}
	return true
}

pub fn (t mut Tensor) update_flags(d map[string]bool) {
	if (d["fortran"] && t.flags["fortran"]) {
		if t.is_fortran_contiguous() {
			t.flags["fortran"] = true
			if t.ndims > 1 {
				t.flags["contiguous"] = false
			}
		} else {
			t.flags["fortran"] = false
		}
	}
	if (d["contiguous"] && t.flags["contiguous"]) {
		if t.is_contiguous() {
			t.flags["contiguous"] = true
			if t.ndims > 1 {
				t.flags["fortran"] = false
			}
		} else {
			t.flags["contiguous"] = false
		}
	}
}

fn (t Tensor) flat_iter() NdIter {
	ptr := t.buffer
	shape := t.shape
	dim := t.ndims - 1
	track := [0].repeat(dim+1)
	strides := t.strides
	return NdIter{
		ptr: ptr
		shape: shape
		dim: dim
		track: track
		strides: strides
	}
}

pub fn (t Tensor) str() string {
	mut printer := init_printer(t)
	return printer.print()
}

pub fn (t Tensor) view(idx1 []int, idx2 []int) Tensor {
	mut newshape := t.shape.clone()
	mut newstrides := t.strides.clone()
	mut newflags := default_flags('C')
	mut ii := 0
	mut idx := []int
	for ii < t.ndims {
		fi := idx1[ii]
		li := idx2[ii]
		if (fi == li) {
			newshape[ii] = 0
			newstrides[ii] = 0
			idx << fi
		} else {
			offset := li - fi
			newshape[ii] = offset
			idx << fi
		}
		ii++
	}
	newshape_ := newshape.filter(it != 0)
	newstrides_ := newstrides.filter(it != 0)
	mut ptr := t.buffer
	mut i := 0
	for i < t.ndims {
		ptr += t.strides[i] * idx[i]
		i++
	}
	mut ret := Tensor{
		shape: newshape_
		strides: newstrides_
		ndims: newshape_.len
		size: tensor.shape_size(newshape_)
		buffer: ptr
		flags: newflags
	}
	ret.update_flags(all_flags())
	return ret
}

fn dup_flags(f map[string]bool) map[string]bool {
	mut ret := map[string]bool
	for i in ["contiguous", "fortran", "owndata", "write"] {
		ret[i] = f[i]
	}
	return ret
}

pub fn (t Tensor) dup_view() Tensor {
	mut newflags := dup_flags(t.flags)
	newflags["owndata"] = false

	ret := Tensor{
		shape: t.shape.clone()
		strides: t.strides.clone()
		buffer: t.buffer
		flags: newflags
		size: t.size
		ndims: t.ndims
	}
	return ret
}

fn min(a int, b int) int {
	if a > b { return b }
	return a
}

pub fn (t Tensor) diag_view() Tensor {
	nel := min(t.shape[0], t.shape[1])
	mut newflags := dup_flags(t.flags)
	newflags["owndata"] = false

	ret := Tensor{
		shape: [nel]
		strides: [t.strides[0] + t.strides[1]]
		buffer: t.buffer
		flags: newflags
		size: t.size
		ndims: 1
	}
	return ret
}

pub fn (t Tensor) reshape(newshape []int) Tensor {
	newsize := 1
	cur_size := t.size
	autoresize := -1

	for i, val in newshape {
		if (val < 0) {
			if (autoresize >= 0) {
				return error("Only one shape dimension can be inferred")
			}
			autosize = i
		} else {
			newsize *= val
		}
	}

	if (autosize >= 0) {
		newshape = newshape.clone()
		newshape[autosize] = int(newsize/cur_size)
		newsize *= newshape[autosize]
	}

	if (newsize != cur_size) {
		return error("Cannot fit into new array")
	}

	mut stride := 0
	mut newstrides = [newshape.len]int
	if t.flags["contiguous"] {
		stride = 1
		for i, d in newshape.reverse() {
			newstrides[i] = stride
			stride *= d
		}
	} else {
		stride = 1
		for i, d in newshape {
			newstrides[i] = stride
			stride *= d
		}
	}

	return t
}

