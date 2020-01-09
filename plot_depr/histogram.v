module plot

import vnum.ndarray

struct HistChartData {
	name    string
	style   DataStyle
	samples []f64
}

pub struct HistogramChart {
pub mut:
	xrange     Range
	yrange     Range
	title      string
	xlabel     string
	ylabel     string
	key        Key
	horizontal bool
	stacked    bool
	data       []HistChartData
	first_bin  f64
	bin_width  f64
}

pub fn (c mut HistogramChart) add_data(name string, data []f64) {
	c.data << HistChartData{
		name: name
		style: DataStyle{}
		samples: data
	}
	if c.xrange.data_min == 0 && c.xrange.data_max == 0 {
		c.xrange.data_min = data[0]
		c.xrange.data_max = data[0]
	}
	for d in data {
		if d < c.xrange.data_min {
			c.xrange.data_min = d
		}
		else if d > c.xrange.data_max {
			c.xrange.data_max = d
		}
	}
	c.xrange.min = c.xrange.data_min
	c.xrange.max = c.xrange.data_max
}

pub fn (c mut HistogramChart) add_array(name string, data ndarray.NdArray) {
	if data.ndims != 1 {
		panic('Only one dimensional data is supported')
	}
	mut values := []f64
	for iter := data.iter(); !iter.done; iter.next() {
		values << *iter.ptr
	}
	c.add_data(name, values)
}

pub fn (hc mut HistogramChart) plot_txt(w, h int) string {
	width := w - 10
	height := h - 4
	leftm := 5
	topm := 2
	ntics := 5
	hc.xrange.setup(ntics, ntics + 1, width, leftm, false)
	hc.bin_width = hc.xrange.tic_setting.delta
	bin_cnt := int((hc.xrange.max - hc.xrange.min) / hc.bin_width + 0.5)
	hc.first_bin = hc.xrange.min + hc.bin_width / 2
	mut counts := []array_int
	hc.yrange.data_min = 0
	mut max := 0
	for i := 0; i < hc.data.len; i++ {
		mut count := [0].repeat(bin_cnt)
		for x in hc.data[i].samples {
			bin := int((x - hc.xrange.min) / hc.bin_width)
			count[bin]++
			if count[bin] > max {
				max = count[bin]
			}
		}
		counts << count
	}
	hc.yrange.data_max = f64(max)
	hc.yrange.setup(height / 5, height / 5 + 3, height, topm, true)
	mut tb := new_text_buf(w, h)
	tb.rect(leftm, topm, width, height, 0, ' ')
	if hc.title != '' {
		tb.text(width / 2 + leftm, 0, hc.title, 0)
	}
	num_sets := hc.data.len
	for i, tic in hc.xrange.tics {
		mut xs := hc.xrange.data2screen(tic.pos, hc.xrange)
		lx := hc.xrange.data2screen(tic.label_pos, hc.xrange)
		tb.put(xs, topm + height, '+')
		tb.text(lx, topm + height + 1, tic.label, 0)
		y0 := hc.yrange.data2screen(0, hc.yrange)
		if i == 0 {
			continue
		}
		last := hc.xrange.tics[i - 1]
		lasts := hc.xrange.data2screen(last.pos, hc.xrange)
		block_w := int(f64(xs - lasts - num_sets) / f64(num_sets))
		center := (tic.pos + last.pos) / 2
		bin := int((center - hc.xrange.min) / hc.bin_width)
		xs = lasts
		for d in 0 .. hc.data.len {
			fill := SYMBOL[(d + 3) % SYMBOL.len]
			cnt := counts[d][bin]
			mut y := hc.yrange.data2screen(f64(cnt), hc.yrange)
			tb.block(xs + 1, y, block_w, y0 - y, fill)
			mut xlab := xs + block_w / 2
			if block_w % 2 == 1 {
				xlab++
			}
			y--
			tb.text(xlab, y, cnt.str(), 0)
			xs += block_w + 1
		}
	}
	for tic in hc.yrange.tics {
		y := hc.yrange.data2screen(tic.pos, hc.yrange)
		ly := hc.yrange.data2screen(tic.label_pos, hc.xrange)
		tb.put(leftm, y, '+')
		tb.text(leftm - 1, ly, tic.label, 1)
	}
	return tb.str()
}

pub fn (hc mut HistogramChart) plot_svg(w, h int, fname string) {
	width := w - 10
	height := h - 4
	leftm := 5
	topm := 2
	ntics := 5
	hc.xrange.setup(ntics, ntics + 1, width, leftm, false)
	hc.bin_width = hc.xrange.tic_setting.delta
	bin_cnt := int((hc.xrange.max - hc.xrange.min) / hc.bin_width + 0.5)
	hc.first_bin = hc.xrange.min + hc.bin_width / 2
	mut counts := []array_int
	hc.yrange.data_min = 0
	mut max := 0
	for i := 0; i < hc.data.len; i++ {
		mut count := [0].repeat(bin_cnt)
		for x in hc.data[i].samples {
			bin := int((x - hc.xrange.min) / hc.bin_width)
			count[bin]++
			if count[bin] > max {
				max = count[bin]
			}
		}
		counts << count
	}
	hc.yrange.data_max = f64(max)
	hc.yrange.setup(height / 5, height / 5 + 3, height, topm, true)
	mut tb := new_svg(w, h)
	tb.rect(leftm, topm, width, height, 0, ' ')
	if hc.title != '' {
		tb.text(width / 2 + leftm, 0, hc.title, 0)
	}
	num_sets := hc.data.len
	for i, tic in hc.xrange.tics {
		mut xs := hc.xrange.data2screen(tic.pos, hc.xrange)
		lx := hc.xrange.data2screen(tic.label_pos, hc.xrange)
		tb.put(xs, topm + height, '+')
		tb.text(lx, topm + height + 1, tic.label, 0)
		y0 := hc.yrange.data2screen(0, hc.yrange)
		if i == 0 {
			continue
		}
		last := hc.xrange.tics[i - 1]
		lasts := hc.xrange.data2screen(last.pos, hc.xrange)
		block_w := int(f64(xs - lasts - num_sets) / f64(num_sets))
		center := (tic.pos + last.pos) / 2
		bin := int((center - hc.xrange.min) / hc.bin_width)
		xs = lasts
		for d in 0 .. hc.data.len {
			fill := SYMBOL[(d + 3) % SYMBOL.len]
			cnt := counts[d][bin]
			mut y := hc.yrange.data2screen(f64(cnt), hc.yrange)
			tb.block(xs + 1, y, block_w, y0 - y, fill)
			mut xlab := xs + block_w / 2
			if block_w % 2 == 1 {
				xlab++
			}
			y--
			tb.text(xlab, y, cnt.str(), 0)
			xs += block_w + 1
		}
	}
	for tic in hc.yrange.tics {
		y := hc.yrange.data2screen(tic.pos, hc.yrange)
		ly := hc.yrange.data2screen(tic.label_pos, hc.xrange)
		tb.put(leftm, y, '+')
		tb.text(leftm - 1, ly, tic.label, 1)
	}
	tb.finalize(fname)
}
