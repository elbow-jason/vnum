import strings

struct Tensor {
	shape []int
	strides []int
	ndims int
	size int
	itemsize int
	buffer &f64
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

fn from_shape(shape []int) Tensor {
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

fn (t Tensor) set(idx []int, val f64) {
	mut offset := 0
	mut i := 0
	for i < t.ndims {
		offset += idx[i] * t.strides[i]
		i++
	}
	mut ptr := t.buffer + offset
	*ptr = val
}

struct NdIter {
	pub mut:
		ptr &f64
		shape []int
		strides []int
		track []int
		dim int
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

fn (iter mut NdIter) next() &f64 {
	ret := iter.ptr
	mut i := iter.dim
	for i >= 0 {
		iter.track[i] += 1
		shape_i := iter.shape[i]
		stride_i := iter.strides[i]

		if (iter.track[i] == iter.shape[i]) {
			iter.track[i] = 0
			iter.ptr -= (shape_i - 1) * stride_i
			i--
			continue
		}
		iter.ptr += stride_i
		break
	}
	return ret
}

struct Printer {
	t Tensor
	idx []int
	ptr &f64
	iter NdIter
	obrackets string
	cbrackets string
	indent string
	last_comma int
	yielded int
	mut:
		strides []int
		shape []int
		io strings.Builder
}

fn init_printer(tns Tensor) Printer {
	ob := "[".repeat(tns.ndims)
	cb := "]".repeat(tns.ndims)
	id := " ".repeat(tns.ndims)
	mut prnt := Printer{
		t: tns
		iter: tns.flat_iter()
		idx: [0].repeat(tns.ndims)
		ptr: tns.buffer
		obrackets: "Tensor" + "(" + ob
		cbrackets: cb
		indent: id
		last_comma: 0
		strides: tns.strides
		shape: tns.shape
		io: strings.new_builder(1000)
	}

	if tns.ndims > 2 {
		mut i := 0
		for i < (int(tns.ndims / 2) - 1) {
			offset := tns.ndims - i - 1
			tmp := prnt.strides[i]
			prnt.strides[i] = prnt.strides[offset]
			prnt.strides[offset] = tmp

			tmp2 := prnt.shape[i]
			prnt.strides[i] = prnt.strides[offset]
			prnt.strides[offset] = tmp2
			i++
		}
	} else if (tns.ndims == 2) {
		prnt.strides = prnt.strides.reverse()
		prnt.shape = prnt.shape.reverse()
	}
	prnt.io.write(prnt.obrackets)
	return prnt
}

fn (p mut Printer) print() string {
	val := *(p.iter.next())
	p.io.write("$val")
	for {
		if (!p.inc()) {
			break
		}
	}
	return p.io.str()
}

fn (p mut Printer) inc() bool {
	mut first_item := 0
	mut ii := 0
	p.idx[ii] += 1
	ptr := p.iter.next()
	for {
		if (p.idx[ii] != p.shape[ii]) {
			break
		}
		p.idx[ii] = 0
		ii++
		if (ii == p.idx.len) {
			p.io.write("]".repeat(ii))
			return false
		}
		first_item++
		p.idx[ii] += 1
	}

	if (ii != 0) {
		p.io.write("]".repeat(ii))
		p.io.write(",")
		p.io.write("\n".repeat(ii))
		p.io.write(" ".repeat(8))
		offset := p.t.ndims - ii - 1
		p.io.write(p.indent[0..offset])
	}

	if (first_item > 0) {
		p.io.write("[".repeat(first_item))
	} else {
		p.io.write(", ")
	}
	val := *ptr
	p.io.write("$val")
	return true
}

pub fn (t Tensor) str() string {
	mut printer := init_printer(t)
	return printer.print()
}