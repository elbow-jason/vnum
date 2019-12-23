module tensor
import strings

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