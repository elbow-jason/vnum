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
		if (t.shape.len != retshape.len) {
			panic("All inputs must share the same number of axes")
		}

		mut i := 0
		for i < shape.len {
			if (i != axis) && (t.shape[i] != shape[i]) {
				panic("All inputs must share a shape off axis")
			}
			i++
		}
		retshape[axis] += t.shape[axis]
	}
	return retshape
}

pub fn leading_trailing(a tensor.Tensor, edgeitems int, lo []int, hi []int) tensor.Tensor {
	axis := lo.len
	if axis == a.ndims {
		return a.view(lo, hi)
	}
	if a.shape[axis] > 2 * edgeitems {
		mut flo := lo.clone()
		mut fhi := hi.clone()
		mut slo := lo.clone()
		mut shi := hi.clone()

		flo << 0
		fhi << edgeitems
		slo << a.shape[axis] + -1 * edgeitems
		shi << a.shape[axis]

		f := leading_trailing(a, edgeitems, flo, fhi)
		l := leading_trailing(a, edgeitems, slo, shi)

		return concatenate([f, l], axis)
	} else {
		mut nlo := lo.clone()
		mut nhi := hi.clone()
		nlo << 0
		nhi << a.shape[axis]
		return leading_trailing(a, edgeitems, nlo, nhi)
	}
}

fn extend_line(s string, line string, word string, line_width int, next_line_prefix string) []string {
	mut sn := s
	mut ln := line
	needs_wrap := ln.len + word.len > line_width

	if needs_wrap {
		sn += ln + "\n"
		ln = next_line_prefix
	}
	ln += word
	return [sn, ln]
}

fn recursor(a tensor.Tensor, index []int, hanging_indent string, curr_width int, summary_insert string, edge_items int, separator string) string {
	axis := index.len
	axes_left := a.ndims - axis

	if axes_left == 0 {
		return a.get(index).str()
	}

	next_hanging_indent := hanging_indent + " "
	next_width := curr_width - 1

	a_len := a.shape[axis]
	show_summary := (summary_insert.len > 0) && (2 * edge_items < a_len)
	
	mut leading_items := 0
	mut trailing_items := a_len

	if show_summary {
		leading_items = edge_items
		trailing_items = edge_items
	}

	mut s := ""

	if axes_left == 1 {
		elem_width := curr_width - 2
		mut line := hanging_indent

		mut lii := 0
		for lii < leading_items {
			mut nidx := index.clone()
			nidx << lii
			word := recursor(a, nidx, next_hanging_indent, next_width, summary_insert, edge_items, separator)
			ret := extend_line(s, line, word, elem_width, hanging_indent)
			s = ret[0]
			line = ret[1]
			line += separator
			lii++
		}

		if show_summary {
			ret := extend_line(s, line, summary_insert, elem_width, hanging_indent)
			s = ret[0]
			line = ret[1]
			line += separator
		}

		mut tii := trailing_items
		for tii >= 2 {
			mut tidx := index.clone()
			tidx << -1 * tii
			word := recursor(a, tidx, next_hanging_indent, next_width, summary_insert, edge_items, separator)
			ret := extend_line(s, line, word, elem_width, hanging_indent)
			s = ret[0]
			line = ret[1]
			line += separator
			tii--
		}

		mut lidx := index.clone()
		lidx << -1
		word := recursor(a, lidx, next_hanging_indent, next_width, summary_insert, edge_items, separator)
		ret := extend_line(s, line, word, elem_width, hanging_indent)
		s = ret[0]
		line = ret[1]
		s += line
	} else {
		s = ""
		rem := axes_left - 1
		mut line_sep := separator
		line_sep += "\n".repeat(rem)

		mut lii := 0
		for lii < leading_items {
			mut nidx := index.clone()
			nidx << lii
			nested := recursor(a, nidx, next_hanging_indent, next_width, summary_insert, edge_items, separator)
			lii++
			s += hanging_indent + nested + line_sep
		}

		if show_summary {
			s += hanging_indent + summary_insert + ", \n"
		}

		mut tii := trailing_items
		for tii >= 2 {
			mut tidx := index.clone()
			tidx << -1 * tii
			nested := recursor(a, tidx, next_hanging_indent, next_width, summary_insert, edge_items, separator)
			s += hanging_indent + nested + line_sep
			tii--
		}
		mut lidx := index.clone()
		lidx << -1
		nested := recursor(a, lidx, next_hanging_indent, next_width, summary_insert, edge_items, separator)
		s += hanging_indent + nested
	}
	return "[" + s + "]"
}

fn format_array(a tensor.Tensor, line_width int, next_line_prefix string, separator string, edge_items int, summary_insert string) string {
	return recursor(a, [], next_line_prefix, line_width, summary_insert, edge_items, separator)
}

pub fn array2string(a tensor.Tensor, separator string, prefix string) string {
	mut summary_insert := "..."
	mut data := a
	if a.size > 1000 {
		summary_insert = "..."
		data = leading_trailing(a, 3, [], [])
	}
	mut next_line_prefix := " "
	next_line_prefix += " ".repeat(prefix.len)
	return format_array(a, 75, next_line_prefix, separator, 3, summary_insert)
}