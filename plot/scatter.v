module plot

import vnum.ndarray

struct ScatterData {
pub mut:
	name	string
	style	Style
	xs 		ndarray.NdArray
	ys		ndarray.NdArray
}

struct ScatterChart {
pub mut:
	title 	string
	data	[]ScatterData
	x_axis 	AxisOptions
	y_axis	AxisOptions
	options	ChartOptions
}

pub fn scatter(title string) ScatterChart {
	mut chart := ScatterChart{
		title: title
	}
	chart.x_axis = new_axis()
	chart.y_axis = new_axis()
	chart.options = ChartOptions{border_padding: 30, data_padding: 40}
	return chart
}

pub fn (s mut ScatterChart) add_data(name string, xs ndarray.NdArray, ys ndarray.NdArray) {
	data := ScatterData{
		name: name
		xs: xs.copy('C')
		ys: ys.copy('C')
	}
	s.data << data
}

pub fn (s mut ScatterChart) set_xrange(min f64, max f64) {
	s.x_axis.range.min = min
	s.x_axis.range.max = max
}

pub fn (s mut ScatterChart) set_yrange(min f64, max f64) {
	s.y_axis.range.min = min
	s.y_axis.range.max = max
}

fn (s ScatterChart) xbounds() Range {
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

fn (s ScatterChart) ybounds() Range {
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

fn (s ScatterChart) height(g SvgGraphic) int {
	return g.h - 2 * s.options.border_padding
}

fn (s ScatterChart) width(g SvgGraphic) int {
	return g.w - 2 * s.options.border_padding
}

fn (s ScatterChart) data_height(g SvgGraphic) int {
	return g.h - 2 * s.options.data_padding
}

pub fn (s ScatterChart) data_width(g SvgGraphic) int {
	return g.w - 2 * s.options.data_padding
}

pub fn (s mut ScatterChart) draw(g mut SvgGraphic) {
	if s.x_axis.unbounded() {
		s.x_axis.range = s.xbounds()
	}
	if s.y_axis.unbounded() {
		s.y_axis.range = s.ybounds()
	}

	g.bounding_box(s.options.border_padding, s.options.border_padding, s.width(g), s.height(g))

	for i, entry in s.data {
		if entry.style.symbol.len == 0 {
			s.data[i].style.symbol = '.'
		}
		s.data[i].style.symbol_color = Colors[i%Colors.len]
		for iter := entry.xs.with(entry.ys); !iter.done; iter.next() {
			x := s.x_axis.range.bound(*iter.ptr_a, s.options.data_padding, g.w - s.options.data_padding)
			y := s.y_axis.range.bound(*iter.ptr_b, s.options.data_padding, g.h - s.options.data_padding)
			g.symbol(int(x), int(y), s.data[i].style)
		}
	}

	mut ntics, mut pad, mut ctic, mut inc := s.x_axis.info(s.data_width(g))

	mut sx := s.options.data_padding
	mut sy := s.options.border_padding + s.height(g)
	
	if !s.x_axis.hide {
		for i := 0; i < ntics; i++ {
			g.tic(sx, sy, sx, sy - s.x_axis.tic_settings.length, s.x_axis.tic_settings)
			g.text(sx, sy+15, int(ctic).str(), 0, 0)
			sx += int(pad)
			ctic += inc
		}
	}

	ntics, pad, ctic, inc = s.y_axis.info(s.data_height(g))

	sx = s.options.border_padding
	sy = s.options.data_padding + s.data_height(g)

	if !s.y_axis.hide {
		for i := 0; i < ntics; i++ {
			g.tic(sx, sy, sx + s.x_axis.tic_settings.length, sy, s.y_axis.tic_settings)
			g.text(sx-15, sy+5, int(ctic).str(), 0, 0)
			sy -= int(pad)
			ctic += inc
		}
	}

	g.text(g.w/2, s.options.border_padding - 10, s.title, 0, 0)
}