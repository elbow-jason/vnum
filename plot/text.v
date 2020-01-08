module plot

import math
// textGraphics
struct TextGraphics {
pub mut:
	tb   TextBuf // the underlying text buffer
	w    int // width and height
	h    int
	xoff int // the initial radius for pie charts
}
// New creates a textGraphic of dimensions w x h.
fn new_text(w, h int) TextGraphics {
	tb := new_text_buf(w, h)
	mut tg := &TextGraphics{
		tb: tb
	}
	tg.w = w
	tg.h = h
	tg.xoff = -1
	return tg
}

fn (g TextGraphics) options() map[string]Style {
	return map[string]Style
}

fn (g mut TextGraphics) begin() {
	g.tb = new_text_buf(g.w, g.h)
}

fn (g TextGraphics) end() {}

fn (tg TextGraphics) background() (int,int,int,int) {
	return 255,255,255,255
}

fn (g TextGraphics) dimensions() (int,int) {
	return g.w,g.h
}

fn (g TextGraphics) font_metrics(font Font) (f32,int,bool) {
	return 1.0,1,true
}

fn (g TextGraphics) text_len(t string, font Font) int {
	return t.len
}

fn (g mut TextGraphics) line(x0, y0, x1, y1 int, style Style) {
	mut symbol := style.symbol
	if symbol < ' ' || symbol > '~' {
		symbol = 'x'
	}
	g.tb.line(x0, y0, x1, y1, symbol)
}

fn (g TextGraphics) path(x, y []int, style Style) {
	generic_path(g, x, y, style)
}

fn (g TextGraphics) wedge(x, y, ro, ri int, phi, psi f64, style Style) {
	generic_wedge(g, x, y, ro, ri, phi, psi, CircleStretchFactor, style)
}

fn (g mut TextGraphics) text(x, y int, t string, malign string, rot int, font Font) {
	// align: -1: left; 0: centered; 1: right; 2: top, 3: center, 4: bottom
	mut align := malign
	if align.len == 2 {
		align = align[1..]
	}
	mut a := 0
	if rot == 0 {
		if align == 'l' {
			a = -1
		}
		if align == 'c' {
			a = 0
		}
		if align == 'r' {
			a = 1
		}
	}
	else {
		if align == 'l' {
			a = 2
		}
		if align == 'c' {
			a = 3
		}
		if align == 'r' {
			a = 4
		}
	}
	g.tb.text(x, y, t, a)
}

fn (g mut TextGraphics) rect(x, y, w, h int, style Style) {
	sanitize_rect(x, y, w, h, 1)
	// Border
	if style.line_width > 0 {
		for i := 0; i < w; i++ {
			g.tb.put(x + i, y, style.symbol)
			g.tb.put(x + i, y + h - 1, style.symbol)
		}
		for i := 1; i < h - 1; i++ {
			g.tb.put(x, y + i, style.symbol)
			g.tb.put(x + w - 1, y + i, style.symbol)
		}
	}
	// // Filling // if style.FillColor != nil { // // TODO: fancier logic // var s int // _, _, _, a := style.FillColor.RGBA() // if a == 0xffff { // s = '#' // black // } else if a == 0 { // s = ' ' // white // } else { // s = style.symbol // } // for i := 1; i < h-1; i++ { // for j := 1; j < w-1; j++ { // g.tb.put(x+j, y+i, rune(s)) // } // } // }
}

fn (g TextGraphics) string() string {
	return g.tb.str()
}

fn (g mut TextGraphics) symbol(x, y int, style Style) {
	g.tb.put(x, y, style.symbol)
}

fn (g mut TextGraphics) xaxis(xrange Range, y, y1 int, options map[string]Style) {
	mirror := xrange.tic_setting.mirror
	xa := xrange.data_2_screen(xrange.min, xrange.width, xrange.offset, xrange.min, xrange.max, xrange.norm)
	xe := xrange.data_2_screen(xrange.max, xrange.width, xrange.offset, xrange.min, xrange.max, xrange.norm)
	for sx := xa; sx <= xe; sx++ {
		g.tb.put(sx, y, '-')
		if mirror >= 1 {
			g.tb.put(sx, y1, '-')
		}
	}
	if xrange.show_zero && xrange.min < 0 && xrange.max > 0 {
		z := xrange.data_2_screen(0, xrange.width, xrange.offset, xrange.min, xrange.max, xrange.norm)
		for yy := y - 1; yy > y1 + 1; yy-- {
			g.tb.put(z, yy, ':')
		}
	}
	if xrange.label != '' {
		mut yy := y + 1
		if !xrange.tic_setting.hide {
			yy++
		}
		g.tb.text((xa + xe) / 2, yy, xrange.label, 0)
	}
	for tic in xrange.tics {
		mut x := 0
		if !math.is_nan(tic.pos) {
			x = xrange.data_2_screen(tic.pos, xrange.width, xrange.offset, xrange.min, xrange.max, xrange.norm)
		}
		else {
			x = -1
		}
		lx := xrange.data_2_screen(tic.label_pos, xrange.width, xrange.offset, xrange.min, xrange.max, xrange.norm)
		if x != -1 {
			g.tb.put(x, y, '+')
			if mirror >= 2 {
				g.tb.put(x, y1, '+')
			}
		}
		g.tb.text(lx, y + 1, tic.label, 0)
		if xrange.show_limits {
			g.tb.text(xa, y + 2, xrange.min.str(), -1)
			g.tb.text(xe, y + 2, xrange.max.str(), 1)
		}
	}
}

fn (g mut TextGraphics) yaxis(yrange Range, x, x1 int, options map[string]Style) {
	label := yrange.label
	mirror := yrange.tic_setting.mirror
	ya := yrange.data_2_screen(yrange.min, yrange.width, yrange.offset, yrange.min, yrange.max, yrange.norm)
	ye := yrange.data_2_screen(yrange.max, yrange.width, yrange.offset, yrange.min, yrange.max, yrange.norm)
	for sy := min(ya, ye); sy <= max(ya, ye); sy++ {
		g.tb.put(x, sy, '|')
		if mirror >= 1 {
			g.tb.put(x1, sy, '|')
		}
	}
	if yrange.show_zero && yrange.min < 0 && yrange.max > 0 {
		z := yrange.data_2_screen(0, yrange.width, yrange.offset, yrange.min, yrange.max, yrange.norm)
		for xx := x + 1; xx < x1; xx += 2 {
			g.tb.put(xx, z, '-')
		}
	}
	if label != '' {
		g.tb.text(1, (ya + ye) / 2, label, 3)
	}
	for tic in yrange.tics {
		y := yrange.data_2_screen(tic.pos, yrange.width, yrange.offset, yrange.min, yrange.max, yrange.norm)
		ly := yrange.data_2_screen(tic.label_pos, yrange.width, yrange.offset, yrange.min, yrange.max, yrange.norm)
		g.tb.put(x, y, '+')
		if mirror >= 2 {
			g.tb.put(x1, y, '+')
		}
		g.tb.text(x - 2, ly, tic.label, 1)
	}
}

fn (g mut TextGraphics) scatter(points []EPoint, plotstyle int, style Style) {
	// First pass: Error bars
	for p in points {
		xl,yl,xh,yh := p.bounding_box()
		if !math.is_nan(p.delta_x) {
			g.tb.line(int(xl), int(p.y), int(xh), int(p.y), '-')
		}
		if !math.is_nan(p.delta_y) {
			g.tb.line(int(p.x), int(yl), int(p.x), int(yh), '|')
		}
	}
	// Second pass: Line
	if (plotstyle & PlotStyleLines) != 0 && points.len > 0 {
		mut lastx := int(points[0].x)
		mut lasty := int(points[0].y)
		for i := 1; i < points.len; i++ {
			x := int(points[i].x)
			y := int(points[i].y)
			g.tb.line(lastx, lasty, x, y, style.symbol)
			lastx = x
			lasty = y
		}
	}
	// Third pass: symbols
	if (plotstyle & PlotStylePoints) != 0 && points.len != 0 {
		for p in points {
			g.tb.put(int(p.x), int(p.y), style.symbol)
		}
	}
	// GenericScatter(g, points, plotstyle, style)
}

fn (g mut TextGraphics) boxes(boxes []Box, mwidth int, style mut Style) {
	mut width := mwidth
	if width % 2 == 0 {
		width++
	}
	hbw := (width - 1) / 2
	if style.symbol == '' {
		style.symbol = '*'
	}
	for box in boxes {
		x := int(box.x)
		q1 := int(box.q1)
		q3 := int(box.q3)
		g.tb.rect(x - hbw, q1, 2 * hbw, q3 - q1, 0, ' ')
		if !math.is_nan(box.med) {
			med := int(box.med)
			g.tb.put(x - hbw, med, '+')
			for i := 0; i < hbw; i++ {
				g.tb.put(x - i, med, '-')
				g.tb.put(x + i, med, '-')
			}
			g.tb.put(x + hbw, med, '+')
		}
		if !math.is_nan(box.avg) && style.symbol != '' {
			g.tb.put(x, int(box.avg), style.symbol)
		}
		if !math.is_nan(box.high) {
			for y := int(box.high); y < q3; y++ {
				g.tb.put(x, y, '|')
			}
		}
		if !math.is_nan(box.low) {
			for y := int(box.low); y > q1; y-- {
				g.tb.put(x, y, '|')
			}
		}
		for ol in box.outliers {
			y := int(ol)
			g.tb.put(x, y, style.symbol)
		}
	}
}

fn (g TextGraphics) key(x, y int, key Key, options map[string]Style) {
	// m := key.place() // if lm.len == 0 { // return // } // tw, th, cw, rh := key.Layout(g, m, ElementStyle(options, KeyElement).Font) // // fmt.Printf("text-Key:  %d x %d\n", tw,th) // style := ElementStyle(options, KeyElement) // if style.line_width > 0 || style.FillColor != nil { // g.tb.rect(x, y, tw, th-1, 1, ' ') // } // x += int(KeyHorSep) // vsep := KeyVertSep // if vsep < 1 { // vsep = 1 // } // y += int(vsep) // for ci, col := range m { // yy := y
	// for ri, e := range col { // if e == nil || e.text == "" { // continue // } // plotStyle := e.PlotStyle // // fmt.Printf("KeyEntry %s: PlotStyle = %d\n", e.text, e.PlotStyle) // if plotStyle == -1 { // // heading only... // g.tb.text(x, yy, e.text, -1) // } else { // // normal entry // if (plotStyle & PlotStyleLines) != 0 { // g.line(x, yy, x+int(KeySymbolWidth), yy, e.Style) // } // if (plotStyle & PlotStylePoints) != 0 { // g.symbol(x+int(KeySymbolWidth/2), yy, e.Style) // } // if (plotStyle & PlotStyleBox) != 0 { // g.tb.put(x+int(KeySymbolWidth/2), yy, rune(e.Style.symbol)) // } // g.tb.text(x+int((KeySymbolWidth+KeySymbolSep)), yy, e.text, -1) // } // yy += rh[ri] + int(KeyRowSep) // }
	// x += int((KeySymbolWidth + KeySymbolSep + KeyColSep + f32(cw[ci]))) // }
	}

	fn (g &TextGraphics) bars(bars []BarInfo, style Style) {
		generic_bars(g, bars, style)
	}

	const (
		CircleStretchFactor = 1.85
	)

	fn (g mut TextGraphics) rings(wedges mut []WedgeInfo, x, y, ro, ri int) {
		if g.xoff == -1 {
			g.xoff = int(f64(ro) * (CircleStretchFactor - 1))
			// debug.Printf("Shifting center about %d (ro=%d, f=%.2f)", g.xoff, ro, CircleStretchFactor)
		}
		for i in 0 .. wedges.len {
			wedges[i].style.line_width = 1
		}
		generic_rings(g, wedges, x + g.xoff, y, ro, ri, 1.8)
	}
