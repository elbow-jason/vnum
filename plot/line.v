module plot

import vnum.ndarray

struct LineData {
pub mut:
	name	string
	style	Style
	xs		ndarray.NdArray
	ys		ndarray.NdArray
}

struct LineChart {
pub mut:
	title 	string
	data	[]LineData
	x_axis 	AxisOptions
	y_axis	AxisOptions
	options	ChartOptions
}

pub fn line(title string) LineChart {
	mut lc := LineChart{}
	lc.title = title
	lc.x_axis = new_axis()
	lc.y_axis = new_axis()
	lc.options = ChartOptions{border_padding: 30, data_padding: 40}
	return lc
}

fn (s LineChart) ybounds() Range {
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

fn (s LineChart) xbounds() Range {
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

fn (s LineChart) height(g SvgGraphic) int {
	return g.h - 2 * s.options.border_padding
}

fn (s LineChart) width(g SvgGraphic) int {
	return g.w - 2 * s.options.border_padding
}

fn (s LineChart) data_height(g SvgGraphic) int {
	return g.h - 2 * s.options.data_padding
}

pub fn (s LineChart) data_width(g SvgGraphic) int {
	return g.w - 2 * s.options.data_padding
}

pub fn (lc mut LineChart) add_data(name string, xs ndarray.NdArray, ys ndarray.NdArray) {
	ld := LineData{
		name: name
		xs: xs.copy('C')
		ys: ys.copy('C')
	}
	lc.data << ld
}

pub fn (l mut LineChart) draw(g mut SvgGraphic) {
	if l.y_axis.unbounded() {
		l.y_axis.range = l.ybounds()
	}
	if l.x_axis.unbounded() {
		l.x_axis.range = l.xbounds()
	}

	g.bounding_box(l.options.border_padding, l.options.border_padding, l.width(g), l.height(g))


	for i, entry in l.data {
		if entry.style.symbol.len == 0 {
			l.data[i].style.symbol = '.'
		}
		l.data[i].style.symbol_color = Colors[i%Colors.len]

		mut iter := entry.xs.with(entry.ys)
		mut j := 0
		mut cx := l.x_axis.range.bound(*iter.ptr_a, l.options.data_padding, g.w - l.options.data_padding)
		mut cy := l.y_axis.range.bound(*iter.ptr_b, l.options.data_padding, g.h - l.options.data_padding)
		iter.next()
		j++

		for !iter.done {
			x := l.x_axis.range.bound(*iter.ptr_a, l.options.data_padding, g.w - l.options.data_padding)
			y := l.y_axis.range.bound(*iter.ptr_b, l.options.data_padding, g.h - l.options.data_padding)
			g.line(int(cx), int(cy), int(x), int(y), l.data[i].style)
			iter.next()
			j++
			cx = x
			cy = y
		}
	}

	mut ntics, mut pad, mut ctic, mut inc := l.x_axis.info(l.data_width(g))

	mut sx := f64(l.options.data_padding)
	mut sy := f64(l.options.border_padding + l.height(g))

	if !l.x_axis.hide {
		for i := 0; i < ntics; i++ {
			g.tic(int(sx), int(sy), int(sx), int(sy) - l.x_axis.tic_settings.length, l.x_axis.tic_settings)
			g.text(int(sx), int(sy)+15, fmt(ctic), 0, 0)
			sx += pad
			ctic += inc
		}
	}


	ntics, pad, ctic, inc = l.y_axis.info(l.data_height(g))

	sx = l.options.border_padding
	sy = l.options.data_padding + l.data_height(g)

	if !l.y_axis.hide {
		for i := 0; i < ntics; i++ {
			g.tic(int(sx), int(sy), int(sx) + l.x_axis.tic_settings.length, int(sy), l.y_axis.tic_settings)
			g.text(int(sx)-15, int(sy)+5, fmt(ctic), 0, 0)
			sy -= pad
			ctic += inc
		}
	}

	g.text(g.w/2, l.options.border_padding - 10, l.title, 0, 0)
}