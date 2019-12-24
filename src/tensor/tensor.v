module tensor
import strings

struct Tensor {
	itemsize int
	buffer &f64
	pub mut:
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

fn no_flags() map[string]bool {
	m := {
		"contiguous": false
		"fortran": false
		"owndata": false
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
	return empty_contig(shape)
}

fn empty_contig(shape []int) Tensor {
	strides := cstrides(shape)
	ndims := shape.len
	size := shape_size(shape)
	buffer := *f64(calloc(size * sizeof(f64)))
	return Tensor {
		shape: shape
		strides: strides
		ndims: ndims
		size: size
		buffer: buffer
		itemsize: sizeof(f64)
		flags: default_flags('C')
	}
}

fn empty_fortran(shape []int) Tensor {
	strides := fstrides(shape)
	size := shape_size(shape)
	buffer := *f64(calloc(size * sizeof(f64)))
	return Tensor {
		shape: shape
		strides: strides
		ndims: shape.len
		size: size
		buffer: buffer
		itemsize: sizeof(f64)
		flags: default_flags('F')
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

fn delete_at(a []int, index int) []int {
	mut ret := []int
	for i, d in a {
		if (i != index) {
			ret << d
		}
	}
	return ret
}

pub fn (t Tensor) axis_iter(axis int) AxesIter {
	shape := delete_at(t.shape.clone(), axis)
	strides := delete_at(t.strides.clone(), axis)
	ptr := t.buffer
	inc := t.strides[axis]
	tmp := Tensor{
		shape: shape
		strides: strides
		buffer: ptr
		size: shape_size(shape)
		ndims: shape.len
		flags: no_flags()
	}

	return AxesIter{
		ptr: ptr
		shape: shape
		strides: strides
		tmp: tmp
		inc: inc
		axis: axis
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

pub fn (t Tensor) memory_into(order string) Tensor {
	mut ret := Tensor{buffer: *f64(calloc(0))}
	if order == 'F' {
		ret = empty_fortran(t.shape)
	} else if order == 'C' {
		ret = empty_contig(t.shape)
	}
	mut ia := ret.flat_iter()
	mut ib := t.flat_iter()
	mut i := 0
	for i < t.size {
		mut ptr := ia.next()
		*ptr = *ib.next()
		i++
	}
	ret.update_flags(all_flags())
	return ret
}

pub fn seq(n int) Tensor {
	ret := empty_contig([n])
	mut ii := 0
	mut iter := ret.flat_iter()
	for ii < n {
		mut ptr := iter.next()
		*ptr = f64(ii)
		ii++
	}
	return ret
}

fn add_(a f64, b f64) f64 {
	return a + b
}

fn subtract_(a f64, b f64) f64 {
	return a - b
}

fn divide_(a f64, b f64) f64 {
	return a / b
}

fn multiply_(a f64, b f64) f64 {
	return a * b
}

fn op(a Tensor, b Tensor, op fn(f64, f64)f64) Tensor {
	ret := a.memory_into('C')
	mut ret_iter := ret.flat_iter()
	mut rhs_iter := b.flat_iter()
	mut ii := 0

	for ii < a.size {
		mut ptr := ret_iter.next()
		*ptr = op(*ptr, *rhs_iter.next())
		ii++
	}
	return ret
}

fn op_scalar(a Tensor, b f64, op fn(f64, f64)f64) Tensor {
	ret := a.memory_into('C')
	mut ret_iter := ret.flat_iter()
	mut ii := 0

	for ii < a.size {
		mut ptr := ret_iter.next()
		*ptr = op(*ptr, b)
		ii++
	}
	return ret
}

pub fn add(a Tensor, b Tensor) Tensor {
	return op(a, b, add_)
}

pub fn add_scalar(a Tensor, b f64) Tensor {
	return op_scalar(a, b, add_)
}

pub fn subtract(a Tensor, b Tensor) Tensor {
	return op(a, b, subtract_)
}

pub fn subtract_scalar(a Tensor, b f64) Tensor {
	return op_scalar(a, b, subtract_)
}

pub fn divide(a Tensor, b Tensor) Tensor {
	return op(a, b, divide_)
}

pub fn divide_scalar(a Tensor, b f64) Tensor {
	return op_scalar(a, b, divide_)
}

pub fn multiply(a Tensor, b Tensor) Tensor {
	return op(a, b, multiply_)
}

pub fn multiply_scalar(a Tensor, b f64) Tensor {
	return op_scalar(a, b, divide_)
}

pub fn (t Tensor) shape_into(shape []int) Tensor {
	mut ret := t.dup_view()
	mut newshape := shape.clone()
	mut newsize := 1
	cur_size := t.size
	mut autosize := -1

	for i, val in newshape {
		if (val < 0) {
			if (autosize >= 0) {
				// panic here
			}
			autosize = i
		} else {
			newsize *= val
		}
	}

	if (autosize >= 0) {
		newshape = newshape.clone()
		newshape[autosize] = newsize/cur_size
		newsize *= newshape[autosize]
	}

	if (newsize != cur_size) {
		// panic here
	}

	mut stride := 1
	mut newstrides := [0].repeat(newshape.len)

	if (t.flags["fortran"] && !t.flags["contiguous"]) {
		newstrides = fstrides(newshape)
	} else {
		newstrides = cstrides(newshape)
	}

	if (t.flags["contiguous"] || t.flags["fortran"]) {
		ret.shape = newshape
		ret.strides = newstrides
		ret.ndims = newshape.len
	} else {
		ret = t.memory_into('C')
		ret.shape = newshape
		ret.strides = newstrides
		ret.ndims = newshape.len
	}
	ret.update_flags(all_flags())
	return ret
}

pub fn (t Tensor) axes_into(order []int) Tensor {
	mut ret := t.dup_view()
	n := order.len
	if (n != t.ndims) {
		// panic here
	}
	mut permutation := [0].repeat(32)
	mut reverse_permutation := [-1].repeat(32)

	mut i := 0
	for i < n {
		mut axis := order[i]
		if (axis < 0) { axis = t.ndims + axis }
		if (axis < 0 || axis >= t.ndims) {
			// panic here
		}
		if (reverse_permutation[axis] == -1) {
			// panic here
		}
		reverse_permutation[i] = i
		permutation[i] = axis

		i++
	}
	newstrides := t.strides.clone()
	newshape := t.shape.clone()
	
	mut ii := 0
	for ii < n {
		ret.shape[ii] = t.shape[permutation[ii]]
		ret.strides[ii] = t.strides[permutation[ii]]
		ii++
	}
	ret.update_flags(all_flags())
	return ret
}

pub fn (a Tensor) sum_axis(axis int) Tensor {
	mut ai := a.axis_iter(axis)
	mut ii := 1
	mut ret := ai.next()
	for ii < a.shape[axis] {
		ret = add(ret, ai.next())
		ii++
	}
	return ret
}

pub fn (a Tensor) mean_axis(axis int) Tensor {
	ret := a.sum_axis(axis)
	return divide_scalar(ret, a.shape[axis])
}

