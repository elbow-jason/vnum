module plot

import vnum.ndarray

struct Point {
	x	f64
	y	f64
}

struct ScatterData {
pub mut:
	name	string
	style	Style
	xs 		ndarray.NdArray
	ys		ndarray.NdArray
}

pub struct ScatterChart {
pub mut:
	title 	string
	data	[]ScatterData
}

pub fn (s mut ScatterChart) add_data(name string, xs ndarray.NdArray, ys ndarray.NdArray) {
	data := ScatterData{
		name: name
		xs: xs.copy('C')
		ys: ys.copy('C')
	}
	s.data << data
}

pub fn (s ScatterChart) xbounds() Range {
	mut mn := f64(0.0)
	mut mx := f64(0.0)
	for i, e in s.data {
		iter := e.xs.iter()
		min := iter.min()
		max := iter.max()
		if i == 0 {
			mn = min
			mx = max
		}
		if min < mn {
			mn = min
		}
		if max > mx {
			mx = max
		}
	}
	return Range{
		min: mn
		max: mx
	}
}

pub fn (s ScatterChart) ybounds() Range {
	mut mn := f64(0.0)
	mut mx := f64(0.0)
	for i, e in s.data {
		iter := e.ys.iter()
		min := iter.min()
		max := iter.max()
		if i == 0 {
			mn = min
			mx = max
		}
		if min < mn {
			mn = min
		}
		if max > mx {
			mx = max
		}
	}
	return Range{
		min: mn
		max: mx
	}
}

pub fn (s mut ScatterChart) draw(g mut SvgGraphic) {
	xrange := s.xbounds()
	yrange := s.ybounds()

	border_padding := 30
	data_padding := border_padding + 10

	height := g.h - 2 * border_padding
	width := g.w - 2 * border_padding

	hd := g.h - 2 * data_padding
	wd := g.w - 2 * data_padding

	g.bounding_box(border_padding, border_padding, width, height)

	for i, entry in s.data {
		if entry.style.symbol.len == 0 {
			s.data[i].style.symbol = Symbol[i%Symbol.len]
		}
		s.data[i].style.symbol_color = Colors[i%Colors.len]
		for iter := entry.xs.with(entry.ys); !iter.done; iter.next() {
			x := xrange.bound(*iter.ptr_a) * wd + data_padding
			y := yrange.bound(*iter.ptr_b) * hd + data_padding
			g.symbol(int(x), int(y), s.data[i].style)
		}
	}

	mut num_tics := 5
	mut tic_pad := wd / (num_tics - 1)
	mut first_tic := xrange.min
	mut tic_inc := (xrange.max - xrange.min) / (num_tics - 1)

	mut sx := data_padding
	mut sy := border_padding + height

	tic_style := Style{
		symbol_color: Color{0, 0, 0, 1}
	}
	
	for i := 0; i < num_tics; i++ {
		g.line(sx, sy, sx, sy -5, tic_style)
		sx += tic_pad
		first_tic += tic_inc
	}

	num_tics = 5
	tic_pad = hd / (num_tics-1)
	first_tic = yrange.min
	tic_inc = (yrange.max - yrange.min) / (num_tics-1)

	sx = border_padding
	sy = data_padding + hd

	for i := 0; i < num_tics; i++ {
		g.line(sx, sy, sx + 5, sy, tic_style)
		sy -= tic_pad
	}

	g.text(g.w/2, border_padding - 10, "Sample Scatter Chart", 0, 0)

}