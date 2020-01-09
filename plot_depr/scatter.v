module plot

import math
import vnum.ndarray

struct ScatterChartData {
	name  string
	style DataStyle
	data  []Point
}

pub struct ScatterChart {
pub mut:
	xrange Range
	yrange Range
	title  string
	xlabel string
	ylabel string
	key    Key
	data   []ScatterChartData
}

pub fn (sc mut ScatterChart) add_data(name string, data []Point) {
	sc.data << ScatterChartData{
		name,DataStyle{},data}
	if sc.xrange.data_min == 0 && sc.xrange.data_max == 0 && sc.yrange.data_min == 0 && sc.yrange.data_max == 0 {
		sc.xrange.data_min = data[0].x
		sc.xrange.data_max = data[0].x
		sc.yrange.data_min = data[0].y
		sc.yrange.data_max = data[0].y
	}
	for d in data {
		if d.x < sc.xrange.data_min {
			sc.xrange.data_min = d.x
		}
		else if d.x > sc.xrange.data_max {
			sc.xrange.data_max = d.x
		}
		if d.y < sc.yrange.data_min {
			sc.yrange.data_min = d.y
		}
		else if d.y > sc.yrange.data_max {
			sc.yrange.data_max = d.y
		}
	}
	sc.xrange.min = sc.xrange.data_min
	sc.xrange.max = sc.xrange.data_max
	sc.yrange.min = sc.yrange.data_min
	sc.yrange.max = sc.yrange.data_max
}

pub fn (sc mut ScatterChart) add_data_pair(name string, x, y ndarray.NdArray) {
	n := int(math.min(x.size, y.size))
	mut data := [Point{}].repeat(n)
	mut i := 0
	for iter := x.with(y); !iter.done; iter.next() {
		data[i].x = *iter.ptr_a
		data[i].y = *iter.ptr_b
		i++
	}
	sc.add_data(name, data)
}

pub fn (sc mut ScatterChart) plot_txt(tw, th int) string {
	if sc.key.pos.len == 0 {
		sc.key.pos = 'itr'
	}
	mut w := tw
	mut h := th
	if h < 5 {
		h = 5
	}
	if w < 10 {
		w = 10
	}
	mut width := w - 4
	mut leftm := 2
	mut height := h - 1
	mut topm := 0
	mut xlabsep := 1
	mut ylabsep := 3
	if sc.title != '' {
		topm++
		height--
	}
	if sc.xlabel != '' {
		height--
	}
	if !sc.xrange.tic_setting.hide {
		height--
		xlabsep++
	}
	if sc.ylabel != '' {
		leftm += 2
		width -= 2
	}
	if !sc.yrange.tic_setting.hide {
		leftm += 6
		width -= 6
		ylabsep += 6
	}
	mut kb := TextBuf{}
	if !sc.key.hide {
		mut maxlen := 0
		mut entries := []KeyEntry
		for s, data in sc.data {
			mut text := data.name
			if text != '' {
				text = text[..int(math.min(text.len, w / 2 - 7))]
				symbol := SYMBOL[s % SYMBOL.len]
				entries << KeyEntry{
					symbol,text}
				if text.len > maxlen {
					maxlen = text.len
				}
			}
		}
		if entries.len > 0 {
			kh := entries.len + 2
			kw := maxlen + 7
			kb = new_text_buf(kw, kh)
			if sc.key.border != -1 {
				kb.rect(0, 0, kw - 1, kh - 1, sc.key.border + 1, ' ')
			}
			for i, e in entries {
				kb.put(2, i + 1, e.symbol)
				kb.text(5, i + 1, e.text, -1)
			}
			match (sc.key.pos[..2]) {
				'ol' {
					width = width - maxlen - 9
					leftm = leftm + kw
					sc.key.x = 0
				}
				'or' {
					width = width - maxlen - 9
					sc.key.x = w - kw
				}
				'ot' {
					height = height - kh - 2
					topm = topm + kh
					sc.key.y = 1
				}
				'ob' {
					height = height - kh - 2
					sc.key.y = topm + height + 4
				}
				'it' {
					sc.key.y = topm + 1
				}
				'ic' {
					sc.key.y = topm + (height - kh) / 2
				}
				'ib' {
					sc.key.y = topm + height - kh
				}
				else {}
	}
			match (sc.key.pos[..2]) {
				'ol', 'or' {
					match (sc.key.pos[2..3]) {
						't' {
							sc.key.y = topm
						}
						'c' {
							sc.key.y = topm + (height - kh) / 2
						}
						'b' {
							sc.key.y = topm + height - kh + 1
						}
						else {}
	}
				}
				'ot', 'ob' {
					match (sc.key.pos[2..3]) {
						'l' {
							sc.key.x = leftm
						}
						'c' {
							sc.key.x = leftm + (width - kw) / 2
						}
						'r' {
							sc.key.x = w - kw - 2
						}
						else {}
	}
				}
				else {}
	}
			if sc.key.pos[0..1] == 'i' {
				match (sc.key.pos[2..3]) {
					'l' {
						sc.key.x = leftm + 1
					}
					'c' {
						sc.key.x = leftm + (width - kw) / 2
					}
					'r' {
						sc.key.x = leftm + width - kw - 1
					}
					else {}
	}
			}
		}
	}
	mut tb := new_text_buf(w, h)
	tb.rect(leftm, topm, width, height, 0, ' ')
	if sc.title != '' {
		tb.text(width / 2 + leftm, 0, sc.title, 0)
	}
	if sc.xlabel != '' {
		tb.text(width / 2 + leftm, topm + height + xlabsep, sc.xlabel, 0)
	}
	if sc.ylabel != '' {
		tb.text(leftm - ylabsep, topm + height / 2, sc.ylabel, 3)
	}
	mut ntics := 0
	if width < 20 {
		ntics = 2
	}
	else if width < 30 {
		ntics = 3
	}
	else if width < 60 {
		ntics = 4
	}
	else if width < 80 {
		ntics = 5
	}
	else if width < 100 {
		ntics = 7
	}
	else {
		ntics = 10
	}
	sc.xrange.setup(ntics, ntics + 1, width, leftm, false)
	sc.yrange.setup(height / 3, height / 3 + 1, height, topm, true)
	mut tics := sc.xrange.tic_setting
	if !tics.hide {
		for tic in sc.xrange.tics {
			x := sc.xrange.data2screen(tic.pos, sc.xrange)
			lx := sc.xrange.data2screen(tic.label_pos, sc.xrange)
			tb.put(x, topm + height, '+')
			tb.text(lx, topm + height + 1, tic.label, 0)
		}
	}
	tics = sc.yrange.tic_setting
	if !tics.hide {
		for tic in sc.yrange.tics {
			y := sc.yrange.data2screen(tic.pos, sc.yrange)
			ly := sc.yrange.data2screen(tic.label_pos, sc.yrange)
			tb.put(leftm, y, '+')
			tb.text(leftm - 1, ly, tic.label, 1)
		}
	}
	// Plot Data
	for s, data in sc.data {
		for d in data.data {
			x := sc.xrange.data2screen(d.x, sc.xrange)
			y := sc.yrange.data2screen(d.y, sc.yrange)
			tb.put(x, y, SYMBOL[s % SYMBOL.len])
		}
	}
	tb.paste(sc.key.x, sc.key.y, kb)
	return tb.str()
}

pub fn (sc mut ScatterChart) plot_svg(tw, th int, fname string) {
	if sc.key.pos.len == 0 {
		sc.key.pos = 'itr'
	}
	mut w := tw
	mut h := th
	if h < 5 {
		h = 5
	}
	if w < 10 {
		w = 10
	}
	mut width := w - 4
	mut leftm := 2
	mut height := h - 1
	mut topm := 0
	mut xlabsep := 1
	mut ylabsep := 3
	if sc.title != '' {
		topm++
		height--
	}
	if sc.xlabel != '' {
		height--
	}
	if !sc.xrange.tic_setting.hide {
		height--
		xlabsep++
	}
	if sc.ylabel != '' {
		leftm += 2
		width -= 2
	}
	if !sc.yrange.tic_setting.hide {
		leftm += 6
		width -= 6
		ylabsep += 6
	}
	mut kb := SvgGraphic{}
	if !sc.key.hide {
		mut maxlen := 0
		mut entries := []KeyEntry
		for s, data in sc.data {
			mut text := data.name
			if text != '' {
				text = text[..int(math.min(text.len, w / 2 - 7))]
				symbol := SYMBOL[s % SYMBOL.len]
				entries << KeyEntry{
					symbol,text}
				if text.len > maxlen {
					maxlen = text.len
				}
			}
		}
		if entries.len > 0 {
			kh := entries.len + 2
			kw := maxlen + 7
			kb = new_svg(kw, kh)
			if sc.key.border != -1 {
				kb.rect(0, 0, kw - 1, kh - 1, sc.key.border + 1, ' ')
			}
			for i, e in entries {
				kb.put(2, i + 1, e.symbol)
				kb.text(5, i + 1, e.text, -1)
			}
			match (sc.key.pos[..2]) {
				'ol' {
					width = width - maxlen - 9
					leftm = leftm + kw
					sc.key.x = 0
				}
				'or' {
					width = width - maxlen - 9
					sc.key.x = w - kw
				}
				'ot' {
					height = height - kh - 2
					topm = topm + kh
					sc.key.y = 1
				}
				'ob' {
					height = height - kh - 2
					sc.key.y = topm + height + 4
				}
				'it' {
					sc.key.y = topm + 1
				}
				'ic' {
					sc.key.y = topm + (height - kh) / 2
				}
				'ib' {
					sc.key.y = topm + height - kh
				}
				else {}
	}
			match (sc.key.pos[..2]) {
				'ol', 'or' {
					match (sc.key.pos[2..3]) {
						't' {
							sc.key.y = topm
						}
						'c' {
							sc.key.y = topm + (height - kh) / 2
						}
						'b' {
							sc.key.y = topm + height - kh + 1
						}
						else {}
	}
				}
				'ot', 'ob' {
					match (sc.key.pos[2..3]) {
						'l' {
							sc.key.x = leftm
						}
						'c' {
							sc.key.x = leftm + (width - kw) / 2
						}
						'r' {
							sc.key.x = w - kw - 2
						}
						else {}
	}
				}
				else {}
	}
			if sc.key.pos[0..1] == 'i' {
				match (sc.key.pos[2..3]) {
					'l' {
						sc.key.x = leftm + 1
					}
					'c' {
						sc.key.x = leftm + (width - kw) / 2
					}
					'r' {
						sc.key.x = leftm + width - kw - 1
					}
					else {}
	}
			}
		}
	}
	mut tb := new_svg(w, h)
	tb.rect(leftm, topm, width, height, 0, ' ')
	if sc.title != '' {
		tb.text(width / 2 + leftm, 0, sc.title, 0)
	}
	if sc.xlabel != '' {
		tb.text(width / 2 + leftm, topm + height + xlabsep, sc.xlabel, 0)
	}
	if sc.ylabel != '' {
		tb.text(leftm - ylabsep, topm + height / 2, sc.ylabel, 3)
	}
	mut ntics := 0
	if width < 20 {
		ntics = 2
	}
	else if width < 30 {
		ntics = 3
	}
	else if width < 60 {
		ntics = 4
	}
	else if width < 80 {
		ntics = 5
	}
	else if width < 100 {
		ntics = 7
	}
	else {
		ntics = 10
	}
	sc.xrange.setup(ntics, ntics + 1, width, leftm, false)
	sc.yrange.setup(height / 3, height / 3 + 1, height, topm, true)
	mut tics := sc.xrange.tic_setting
	if !tics.hide {
		for tic in sc.xrange.tics {
			x := sc.xrange.data2screen(tic.pos, sc.xrange)
			lx := sc.xrange.data2screen(tic.label_pos, sc.xrange)
			tb.put(x, topm + height, '+')
			tb.text(lx, topm + height + 1, tic.label, 0)
		}
	}
	tics = sc.yrange.tic_setting
	if !tics.hide {
		for tic in sc.yrange.tics {
			y := sc.yrange.data2screen(tic.pos, sc.yrange)
			ly := sc.yrange.data2screen(tic.label_pos, sc.yrange)
			tb.put(leftm, y, '+')
			tb.text(leftm - 1, ly, tic.label, 1)
		}
	}
	// Plot Data
	for s, data in sc.data {
		for d in data.data {
			x := sc.xrange.data2screen(d.x, sc.xrange)
			y := sc.yrange.data2screen(d.y, sc.yrange)
			tb.put(x, y, SYMBOL[s % SYMBOL.len])
		}
	}
	// tb.svg += kb.svg
	tb.finalize(fname)
}


