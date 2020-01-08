module plot

import math

interface Plotter {
	background  ()(byte,byte,byte)
	font_metrics(font Font)(f32,int,bool)
	text_len    (t string, font Font)int
	line        (x0 int, y0 int, x1 int, y1 int, style Style)int
	text        (x int, y int, t string, align string, rot int, f Font)int
	symbol      (x int, y int, style Style)int
	rect        (x int, y int, w int, h int, style Style)int
	wedge       (x int, y int, ro int, ri int, phi, psi f64, style Style)int
	path        (x []int, y []int, style Style)int
	options     ()map[string]Style
	dimensions  ()(int,int)
	begin       ()int
	end         ()int
	xaxis       (xr Range, ys, yms int, options map[string]Style)int
	yaxis       (yr Range, ys, yms int, options map[string]Style)int
	scatter     (points []EPoint, plotstyle int, style Style)int
	boxes       (box []Box, width int, style Style)int
	bars        (bar []BarInfo, style Style)int
	rings       (wedges []WedgeInfo, x int, y int, ro int, ri int)int
	key         (x int, y int, k Key, options map[string]Style)int
}

struct BarInfo {
	x  int
	y  int
	w  int
	h  int
	t  string
	tp string
	f  Font
}

struct WedgeInfo {
pub mut:
	phi   f64
	psi   f64
	text  string
	tp    string
	style Style
	font  Font
	shift int
}

fn generic_text_len(p Plotter, t string, font Font) int {
	mut width := 0
	fw,_,mono := p.font_metrics(font)
	if mono {
		for _ in t {
			width++
		}
		width = int(f32(width) * fw + 0.5)
	}
	else {
		mut length := 0.0
		for i := 0; i < t.len; i++ {
			s := t[i..i + 1]
			if s in CharacterWidth {
				length += CharacterWidth[s]
			}
			else {
				length += 20
			}
		}
		length /= AverageCharacterWidth
		length *= fw
		width = int(length + 0.5)
	}
	return width
}

fn sanitize_rect(tx, ty, tw, th, r int) (int,int,int,int) {
	mut w := tw
	mut x := tx
	mut y := ty
	mut h := th
	if w < 0 {
		x += w
		w = -w
	}
	if h < 0 {
		y += h
		h = -h
	}
	d := (int(math.max(1, r) - 1)) / 2
	return x + d,y + d,w - 2 * d,h - 2 * d
}

fn generic_rect(p Plotter, tx, ty, tw, th int, style Style) {
	x,y,w,h := sanitize_rect(tx, ty, tw, th, style.line_width)
	p.line(x, y, x + w, y, style)
	p.line(x + w, y, x + w, y + h, style)
	p.line(x + w, y + h, x, y + h, style)
	p.line(x, y + h, x, y, style)
}

fn generic_path(p Plotter, x, y []int, style Style) {
	n := int(math.min(x.len, y.len))
	for i := 1; i < n; i++ {
		p.line(x[i - 1], y[i - 1], x[i], y[i], style)
	}
}

fn draw_xtics(bg Plotter, rng Range, y, ym, tic_len int, options map[string]Style) {
	xe := rng.data_2_screen(rng.max, rng.width, rng.offset, rng.min, rng.max, rng.norm)
	// Grid below tics
	if rng.tic_setting.grid > GridOff {
		for ticcnt, tic in rng.tics {
			x := rng.data_2_screen(tic.pos, rng.width, rng.offset, rng.min, rng.max, rng.norm)
			if ticcnt >= 0 && ticcnt <= rng.tics.len - 1 && rng.tic_setting.grid == GridLines {
				bg.line(x, y - 1, x, ym + 1, element_style(options, GridLineElement))
			}
			else if rng.tic_setting.grid == GridBlocks {
				if ticcnt % 2 == 1 {
					x0 := rng.data_2_screen(rng.tics[ticcnt - 1].pos, rng.width, rng.offset, rng.min, rng.max, rng.norm)
					bg.rect(x0, ym, x - x0, y - ym, element_style(options, GridBlockElement))
				}
				else if ticcnt == rng.tics.len - 1 && x < xe - 1 {
					bg.rect(x, ym, xe - x, y - ym, element_style(options, GridBlockElement))
				}
			}
		}
	}
	// Tics on top
	ticstyle := element_style(options, MajorTicElement)
	ticfont := ticstyle.font
	for tic in rng.tics {
		x := rng.data_2_screen(tic.pos, rng.width, rng.offset, rng.min, rng.max, rng.norm)
		lx := rng.data_2_screen(tic.label_pos, rng.width, rng.offset, rng.min, rng.max, rng.norm)
		// Tics
		match (rng.tic_setting.tics) {
			0 {
				bg.line(x, y - tic_len, x, y + tic_len, ticstyle)
			}
			1 {
				bg.line(x, y - tic_len, x, y, ticstyle)
			}
			2 {
				bg.line(x, y, x, y + tic_len, ticstyle)
			}
			else {}
		}
		// Mirrored Tics
		if rng.tic_setting.mirror >= 2 {
			match (rng.tic_setting.tics) {
				0 {
					bg.line(x, ym - tic_len, x, ym + tic_len, ticstyle)
				}
				1 {
					bg.line(x, ym, x, ym + tic_len, ticstyle)
				}
				2 {
					bg.line(x, ym - tic_len, x, ym, ticstyle)
				}
				else {}
			}
		}
		if !rng.tic_setting.hide_labels {
			// Tic-Label
			bg.text(lx, y + 2 * tic_len, tic.label, 'tc', 0, ticfont)
		}
	}
}

// GenericXAxis draws the x-axis with range rng solely by graphic primitives of bg.
// The x-axis is drawn at y on the screen and the mirrored x-axis is drawn at ym.
fn generic_xaxis(bg Plotter, rng Range, y, ym int, options map[string]Style) {
	// _,fontheight,_ := bg.font_metrics(element_style(options, MajorTicElement).font)
	// mut tic_len := 0
	// if !rng.tic_setting.hide {
	// 	tic_len = int(math.min(12, math.max(4, fontheight / 2)))
	// }
	// xa := rng.data_2_screen(rng.min, rng.width, rng.offset, rng.min, rng.max, rng.norm)
	// xe := rng.data_2_screen(rng.max, rng.width, rng.offset, rng.min, rng.max, rng.norm)
	// // Axis label and range limits
	// mut aly := y + 2 * tic_len
	// if !rng.tic_setting.hide {
	// 	aly += (3 * fontheight) / 2
	// }
	// if rng.show_limits {
	// 	font := element_style(options, RangeLimitElement).font
	// 	bg.text(xa, aly, rng.min.str(), 'tl', 0, font)
	// 	bg.text(xe, aly, rng.max.str(), 'tr', 0, font)
	// }
	// if rng.label != '' {
	// 	// draw label _after_ (=over) range limits
	// 	font := element_style(options, MajorAxisElement).font
	// 	bg.text((xa + xe) / 2, aly, '  ' + rng.label + '  ', 'tc', 0, font)
	// }
	// // Tics and Grid
	// if !rng.tic_setting.hide {
	// 	draw_xtics(bg, rng, y, ym, tic_len, options)
	// }
	// // Axis itself, mirrord axis and zero
	// bg.line(xa, y, xe, y, element_style(options, MajorAxisElement))
	// if rng.tic_setting.mirror >= 1 {
	// 	bg.line(xa, ym, xe, ym, element_style(options, MinorAxisElement))
	// }
	// if rng.show_zero && rng.min < 0 && rng.max > 0 {
	// 	z := rng.data_2_screen(0, rng.width, rng.offset, rng.min, rng.max, rng.norm)
	// 	bg.line(z, y, z, ym, element_style(options, ZeroAxisElement))
	// }
}

fn draw_ytics(bg Plotter, rng Range, x, xm, tic_len int, options map[string]Style) {
	ye := rng.data_2_screen(rng.max, rng.width, rng.offset, rng.min, rng.max, rng.norm)
	// Grid below tics
	if rng.tic_setting.grid > GridOff {
		for ticcnt, tic in rng.tics {
			y := rng.data_2_screen(tic.pos, rng.width, rng.offset, rng.min, rng.max, rng.norm)
			if rng.tic_setting.grid == GridLines {
				if ticcnt > 0 && ticcnt < rng.tics.len - 1 {
					// fmt.Printf("Gridline at x=%d\n", x)
					bg.line(x + 1, y, xm - 1, y, element_style(options, GridLineElement))
				}
			}
			else if rng.tic_setting.grid == GridBlocks {
				if ticcnt % 2 == 1 {
					y0 := rng.data_2_screen(rng.tics[ticcnt - 1].pos, rng.width, rng.offset, rng.min, rng.max, rng.norm)
					bg.rect(x, y0, xm - x, y - y0, element_style(options, GridBlockElement))
				}
				else if ticcnt == rng.tics.len - 1 && y > ye + 1 {
					bg.rect(x, ye, xm - x, y - ye, element_style(options, GridBlockElement))
				}
			}
		}
	}
	// Tics on top
	ticstyle := element_style(options, MajorTicElement)
	ticfont := ticstyle.font
	for tic in rng.tics {
		y := rng.data_2_screen(tic.pos, rng.width, rng.offset, rng.min, rng.max, rng.norm)
		ly := rng.data_2_screen(tic.label_pos, rng.width, rng.offset, rng.min, rng.max, rng.norm)
		// Tics
		match (rng.tic_setting.tics) {
			0 {
				bg.line(x - tic_len, y, x + tic_len, y, ticstyle)
			}
			1 {
				bg.line(x, y, x + tic_len, y, ticstyle)
			}
			2 {
				bg.line(x - tic_len, y, x, y, ticstyle)
			}
			else {}
		}
		// Mirrored tics
		if rng.tic_setting.mirror >= 2 {
			match (rng.tic_setting.tics) {
				0 {
					bg.line(xm - tic_len, y, xm + tic_len, y, ticstyle)
				}
				1 {
					bg.line(xm - tic_len, y, xm, y, ticstyle)
				}
				2 {
					bg.line(xm, y, xm + tic_len, y, ticstyle)
				}
				else {}
			}
		}
		if !rng.tic_setting.hide_labels {
			// Label
			bg.text(x - 2 * tic_len, ly, tic.label, 'cr', 0, ticfont)
		}
	}
}

// GenericYAxis draws the y-axis with the range rng solely by graphic primitives of bg.
// The y.axis and the mirrord y-axis are drawn at x and ym respectively.
fn generic_yaxis(bg Plotter, rng Range, x int, xm int, options map[string]Style) {
	// font := element_style(options, MajorAxisElement).font
	// _,fontheight,_ := bg.font_metrics(font)
	// mut tic_len := 0
	// if !rng.tic_setting.hide {
	// 	tic_len = int(math.min(10, math.max(4, fontheight / 2)))
	// }
	// ya := rng.data_2_screen(rng.min, rng.width, rng.offset, rng.min, rng.max, rng.norm)
	// ye := rng.data_2_screen(rng.max, rng.width, rng.offset, rng.min, rng.max, rng.norm)
	// // Label and axis ranges
	// alx := 2 * fontheight
	// if rng.label != '' {
	// 	y := (ya + ye) / 2
	// 	bg.text(alx, y, rng.label, 'bc', 90, font)
	// }
	// if !rng.tic_setting.hide {
	// 	draw_ytics(bg, rng, x, xm, tic_len, options)
	// }
	// // Axis itself, mirrord axis and zero
	// bg.line(x, ya, x, ye, element_style(options, MajorAxisElement))
	// if rng.tic_setting.mirror >= 1 {
	// 	bg.line(xm, ya, xm, ye, element_style(options, MinorAxisElement))
	// }
	// if rng.show_zero && rng.min < 0 && rng.max > 0 {
	// 	z := rng.data_2_screen(0, rng.width, rng.offset, rng.min, rng.max, rng.norm)
	// 	bg.line(x, z, xm, z, element_style(options, ZeroAxisElement))
	// }
}
// GenericScatter draws the given points according to style.
// style.fill_color is used as color of error bars and style.fontSize is used
// as the length of the endmarks of the error bars. Both have suitable defaults
// if the FontXyz are not set. Point coordinates and errors must be provided
// in screen coordinates.
fn generic_scatter(bg Plotter, points []EPoint, plotstyle int, style Style) {
	// First pass: Error bars
	mut ebs := style
	ebs.line_color = ebs.fill_color
	ebs.line_width = 1
	ebs.line_style = SolidLine
	if ebs.line_width == 0 {
		ebs.line_width = 1
	}
	for p in points {
		xl,yl,xh,yh := p.bounding_box()
		// fmt.Printf("Draw %d: %f %f-%f; %f %f-%f\n", i, p.delta_x, xl,xh, p.delta_y, yl,yh)
		if !math.is_nan(p.delta_x) {
			bg.line(int(xl), int(p.y), int(xh), int(p.y), ebs)
		}
		if !math.is_nan(p.delta_y) {
			// fmt.Printf("  Draw %d,%d to %d,%d\n",int(p.x), int(yl), int(p.x), int(yh))
			bg.line(int(p.x), int(yl), int(p.x), int(yh), ebs)
		}
	}
	// Second pass: Line
	if (plotstyle & PlotStyleLines) != 0 && points.len > 0 {
		mut lastx := int(points[0].x)
		mut lasty := int(points[0].y)
		for i := 1; i < points.len; i++ {
			x := int(points[i].x)
			y := int(points[i].y)
			bg.line(lastx, lasty, x, y, style)
			lastx = x
			lasty = y
		}
	}
	// Third pass: symbols
	if (plotstyle & PlotStylePoints) != 0 && points.len != 0 {
		for p in points {
			// fmt.Printf("Point %d at %d,%d\n", i, int(p.x), int(p.y))
			bg.symbol(int(p.x), int(p.y), style)
		}
	}
}
// GenericBoxes draws box plots. (Default implementation for box plots).
// The values for each box in boxes are in screen coordinates!
fn generic_boxes(bg Plotter, boxes []Box, mwidth int, style Style) {
	mut width := mwidth
	if width % 2 == 0 {
		width++
	}
	hbw := (width - 1) / 2
	for d in boxes {
		x := int(d.x)
		q1 := int(d.q1)
		q3 := int(d.q3)
		bg.rect(x - hbw, q1, width, q3 - q1, style)
		if !math.is_nan(d.med) {
			med := int(d.med)
			bg.line(x - hbw, med, x + hbw, med, style)
		}
		if !math.is_nan(d.avg) {
			bg.symbol(x, int(d.avg), style)
		}
		if !math.is_nan(d.high) {
			bg.line(x, q3, x, int(d.high), style)
		}
		if !math.is_nan(d.low) {
			bg.line(x, q1, x, int(d.low), style)
		}
		for y in d.outliers {
			bg.symbol(x, int(y), style)
		}
	}
}
// GenericBars draws the bars in the given style using bg.
// TODO: Is Bars and Generic Bars useful at all? Replaceable by rect?
fn generic_bars(bg Plotter, bars []BarInfo, style Style) {
	for b in bars {
		bg.rect(b.x, b.y, b.w, b.h, style)
		if b.t != '' {
			mut tx := 0
			mut ty := 0
			mut a := ''
			_,mut fh,_ := bg.font_metrics(b.f)
			if fh > 1 {
				fh /= 2
			}
			match (b.tp) {
				'ot' {
					tx = b.x + b.w / 2
					ty = b.y - fh
					a = 'bc'
				}
				'it' {
					tx = b.x + b.w / 2
					ty = b.y + fh
					a = 'tc'
				}
				'ib' {
					tx = b.x + b.w / 2
					ty = b.y + b.h - fh
					a = 'bc'
				}
				'ob' {
					tx = b.x + b.w / 2
					ty = b.y + b.h + fh
					a = 'tc'
				}
				'ol' {
					tx = b.x - fh
					ty = b.y + b.h / 2
					a = 'cr'
				}
				'il' {
					tx = b.x + fh
					ty = b.y + b.h / 2
					a = 'cl'
				}
				'or' {
					tx = b.x + b.w + fh
					ty = b.y + b.h / 2
					a = 'cl'
				}
				'ir' {
					tx = b.x + b.w - fh
					ty = b.y + b.h / 2
					a = 'cr'
				}
				else {
					tx = b.x + b.w / 2
					ty = b.y + b.h / 2
					a = 'cc'
				}
			}
			bg.text(tx, ty, b.t, a, 0, b.f)
		}
	}
}
// GenericWedge draws a pie/wedge just by lines
fn generic_wedge(mg Plotter, x, y, ro, ri int, pphi, ppsi, ecc f64, style Style) {
	mut phi := pphi
	mut psi := ppsi
	for phi < 0 {
		phi += 2.0 * math.pi
	}
	for psi < 0 {
		psi += 2.0 * math.pi
	}
	for phi >= 2.0 * math.pi {
		phi -= 2.0 * math.pi
	}
	for psi >= 2.0 * math.pi {
		psi -= 2.0 * math.pi
	}
	if ri > ro {
		panic('ri > ro is not possible')
	}
	roe := f64(ro) * ecc
	rof := f64(ro)
	rie := f64(ri) * ecc
	rif := f64(ri)
	mut xa := int(math.cos(phi) * roe) + x
	mut ya := y - int(math.sin(phi) * rof)
	xc := int(math.cos(psi) * roe) + x
	yc := y - int(math.sin(psi) * rof)
	mut xai := int(math.cos(phi) * rie) + x
	mut yai := y - int(math.sin(phi) * rif)
	xci := int(math.cos(psi) * rie) + x
	yci := y - int(math.sin(psi) * rif)
	if math.abs(phi - psi) >= 4.0 * math.pi {
		phi = 0
		psi = 2.0 * math.pi
	}
	else {
		if ri > 0 {
			mg.line(xai, yai, xa, ya, style)
			mg.line(xci, yci, xc, yc, style)
		}
		else {
			mg.line(x, y, xa, ya, style)
			mg.line(x, y, xc, yc, style)
		}
	}
	mut xb := 0
	mut yb := 0
	mut exit1 := phi < psi
	for rho := phi; !exit1 || rho < psi; rho += 0.05 {
		// aproximate circle by more than 120 corners polygon
		if rho >= 2.0 * math.pi {
			exit1 = true
			rho -= 2.0 * math.pi
		}
		xb = int(math.cos(rho) * roe) + x
		yb = y - int(math.sin(rho) * rof)
		mg.line(xa, ya, xb, yb, style)
		xa = xb
		ya = yb
	}
	mg.line(xb, yb, xc, yc, style)
	if ri > 0 {
		exit1 = phi < psi
		for rho := phi; !exit1 || rho < psi; rho += 0.1 {
			// aproximate circle by more than 60 corner polygon
			if rho >= 2.0 * math.pi {
				exit1 = true
				rho -= 2.0 * math.pi
			}
			xb = int(math.cos(rho) * rie) + x
			yb = y - int(math.sin(rho) * rif)
			mg.line(xai, yai, xb, yb, style)
			xai = xb
			yai = yb
		}
		mg.line(xb, yb, xci, yci, style)
	}
}
// Fill wedge with center (xi,yi), radius ri from alpha to beta with style.
// Precondition:  0 <= beta < alpha < pi/2
fn fill_quarter_wedge(mg Plotter, xi, yi, ri int, malpha, mbeta, e f64, style Style, quadrant int) {
	mut alpha := malpha
	mut beta := mbeta
	if alpha < beta {
		tmp := alpha
		alpha = beta
		beta = tmp
	}
	// DebugLogger.Printf("fillQuaterWedge from %.1f to %.1f radius %d in quadrant %d.",	180*alpha/math.pi, 180*beta/math.pi, ri, quadrant)
	r := f64(ri)
	ta := math.tan(alpha)
	tb := math.tan(beta)
	for y := int(r * math.sin(alpha)); y >= 0; y-- {
		yf := f64(y)
		x0 := yf / ta
		mut x1 := yf / tb
		x2 := math.sqrt(r * r - yf * yf)
		// DebugLogger.Printf("y=%d  x0=%.2f    x1=%.2f    x2=%.2f  border=%t", y, x0, x1, x2, (x2<x1))
		if math.is_nan(x1) || x2 < x1 {
			x1 = x2
		}
		mut xx0 := 0
		mut xx1 := 0
		mut yy := 0
		match (quadrant) {
			0 {
				xx0 = int(x0 * e + 0.5) + xi
				xx1 = int(x1 * e - 0.5) + xi
				yy = yi - y
			}
			3 {
				xx0 = int(x0 * e + 0.5) + xi
				xx1 = int(x1 * e - 0.5) + xi
				yy = yi + y
			}
			2 {
				xx0 = xi - int(x0 * e + 0.5)
				xx1 = xi - int(x1 * e - 0.5)
				yy = yi + y
			}
			1 {
				xx0 = xi - int(x0 * e + 0.5)
				xx1 = xi - int(x1 * e - 0.5)
				yy = yi - y
			}
			else {
				panic('No quadrant')
			}
		}
		mg.line(xx0, yy, xx1, yy, style)
	}
}

fn quadrant(w f64) int {
	return int(math.floor(2.0 * w / math.pi))
}

fn mapq(w f64, q int) f64 {
	match (q) {
		0 {
			return w
		}
		1 {
			return math.pi - w
		}
		2 {
			return w - math.pi
		}
		3 {
			return 2.0 * math.pi - w
		}
		else {
			panic('No such quadrant')
		}
	}
}
// Fill wedge with center (xi,yi), radius ri from alpha to beta with style.
// Any combination of phi, psi allowed as long 0 <= phi < psi < 2pi.
fn fill_wedge(mg Plotter, xi, yi, ro, ri int, mphi, psi, epsilon f64, style Style) {
	// mut phi := mphi
	// // ls := Style{line_color: style.fill_color, line_with: 1, Symbol: style.symbol}
	// mut qphi := quadrant(phi)
	// qpsi := quadrant(psi)
	// // DebugLogger.Printf("fillWedge from %.1f (%d) to %.1f (%d).", 180*phi/math.pi, qphi, 180*psi/math.pi, qpsi)
	// // prepare styles for filling
	// style.line_color = style.fill_color
	// style.line_width = 1
	// style.line_style = SolidLine
	// blank := Style{
	// 	symbol: ' '
	// 	line_color: gx.Color {
	// 		0,0,0}
	// 	fill_color: gx.Color {
	// 		0,0,0}
	// }
	// for qphi != qpsi {
	// 	// DebugLogger.Printf("qphi = %d", qphi)
	// 	w := f64(qphi + 1) * math.pi / 2
	// 	if math.abs(w - phi) > 0.01 {
	// 		fill_quarter_wedge(mg, xi, yi, ro, mapq(phi, qphi), mapq(w, qphi), epsilon, style, qphi)
	// 		if ri > 0 {
	// 			fill_quarter_wedge(mg, xi, yi, ri, mapq(phi, qphi), mapq(w, qphi), epsilon, blank, qphi)
	// 		}
	// 	}
	// 	phi = w
	// 	qphi++
	// 	if qphi == 4 {
	// 		// DebugLogger.Printf("Wrapped phi around")
	// 		phi = 0
	// 		qphi = 0
	// 	}
	// }
	// if phi != psi {
	// 	// DebugLogger.Printf("Last wedge")
	// 	fill_quarter_wedge(mg, xi, yi, ro, mapq(phi, qphi), mapq(psi, qphi), epsilon, style, qphi)
	// 	if ri > 0 {
	// 		fill_quarter_wedge(mg, xi, yi, ri, mapq(phi, qphi), mapq(psi, qphi), epsilon, blank, qphi)
	// 	}
	// }
}
// GeenricRings draws wedges for pie/ring charts charts. The pie's/ring's center is at (x,y)
// with ri and ro the inner and outer diameter. Eccentricity allows to correct for non-square
// pixels (e.g. in text mode).
fn generic_rings(bg Plotter, wedges []WedgeInfo, x, y, ro, ri int, eccentricity f64) {
	// DebugLogger.Printf("GenericRings with %d wedges center %d,%d, radii %d/%d,  ecc=%.3f)", len(wedges), x, y, ro, ri, eccentricity)
	for w in wedges {
		// Correct center
		d := f64(w.style.line_width) / 2
		// cphi, sphi := math.cos(w.phi), math.sin(w.phi)
		// cpsi, spsi := math.cos(w.psi), math.sin(w.psi)
		delta := (w.psi - w.phi) / 2
		sin_delta := math.sin(delta)
		gamma := (w.phi + w.psi) / 2
		k := d / sin_delta
		shift := f64(w.shift)
		kx := (k + shift) * math.cos(gamma)
		ky := (k + shift) * math.sin(gamma)
		xi := x + int(kx + 0.5)
		yi := y + int(ky + 0.5)
		roc := ro - int(d + k)
		ric := ri - int(d + k)
		bg.wedge(xi, yi, roc, ric, w.phi, w.psi, w.style)
		if w.text != '' {
			_,mut fh,_ := bg.font_metrics(w.font)
			fh += 0
			alpha := (w.phi + w.psi) / 2
			mut rt := 0
			if ri > 0 {
				rt = (ri + ro) / 2
			}
			else {
				rt = ro - 3 * fh
				if rt <= ro / 2 {
					rt = ro - 2 * fh
				}
			}
			// DebugLogger.Printf("Text %s at %d° r=%d", w.Text, int(180*alpha/math.pi), rt)
			tx := int(f64(rt) * math.cos(alpha) * eccentricity + 0.5) + x
			ty := y + int(f64(rt) * math.sin(alpha) + 0.5)
			bg.text(tx, ty, w.text, 'cc', 0, w.font)
		}
	}
}
// generic_circle approximates a circle of radius r around (x,y) with lines.
fn generic_circle(bg Plotter, x, y, r int, style Style) {
	// TODO: fill
	mut x0 := x + r
	mut y0 := y
	rf := f64(r)
	for a := 0.2; a < 2.0 * math.pi; a += 0.2 {
		x1 := int(rf * math.cos(a)) + x
		y1 := int(rf * math.sin(a)) + y
		bg.line(x0, y0, x1, y1, style)
		x0 = x1
		y0 = y1
	}
}

fn polygon(bg Plotter, x, y []int, style Style) {
	n := x.len - 1
	for i := 0; i < n; i++ {
		bg.line(x[i], y[i], x[i + 1], y[i + 1], style)
	}
	bg.line(x[n], y[n], x[0], y[0], style)
}
// GenericSymbol draws the symbol defined by style at (x,y).
fn generic_symbol(bg Plotter, x, y int, style Style) {
	// mut f := style.symbol_size
	// if f == 0 {
	// 	f = 1
	// }
	// if style.line_width <= 0 {
	// 	style.line_width = 1
	// }
	// style.line_color = style.symbol_color
	// n := 5.0 // default size
	// a := int(n * f + 0.5) // standard
	// b := int(n / 2 * f + 0.5) // smaller
	// c := int(1.155 * n * f + 0.5) // triangel long sist
	// d := int(0.577 * n * f + 0.5) // triangle short dist
	// e := int(0.866 * n * f + 0.5) // diagonal
	// match (style.symbol) {
	// 	'*' {
	// 		bg.line(x - e, y - e, x + e, y + e, style)
	// 		bg.line(x - e, y + e, x + e, y - e, style)
	// 	}
	// 	'+' {
	// 		bg.line(x - a, y, x + a, y, style)
	// 		bg.line(x, y - a, x, y + a, style)
	// 	}
	// 	'X' {
	// 		bg.line(x - e, y - e, x + e, y + e, style)
	// 		bg.line(x - e, y + e, x + e, y - e, style)
	// 	}
	// 	'o' {
	// 		generic_circle(bg, x, y, a, style)
	// 	}
	// 	'0' {
	// 		generic_circle(bg, x, y, a, style)
	// 		generic_circle(bg, x, y, b, style)
	// 	}
	// 	'.' {
	// 		generic_circle(bg, x, y, b, style)
	// 	}
	// 	'@' {
	// 		generic_circle(bg, x, y, a, style)
	// 		for r := 1; r < a; r++ {
	// 			generic_circle(bg, x, y, r, style)
	// 		}
	// 		bg.line(x, y, x, y, style)
	// 	}
	// 	'=' {
	// 		bg.rect(x - e, y - e, 2 * e, 2 * e, style)
	// 	}
	// 	'#' {
	// 		style.fill_color = style.line_color
	// 		bg.rect(x - e, y - e, 2 * e, 2 * e, style)
	// 	}
	// 	'A' {
	// 		polygon(bg, [x - a, x + a, x], [y + d, y + d, y - c], style)
	// 		for j := 1; j < a; j++ {
	// 			aa := (j * a) / a
	// 			dd := (j * d) / a
	// 			cc := (j * c) / a
	// 			polygon(bg, [x - aa, x + aa, x], [y + dd, y + dd, y - cc], style)
	// 		}
	// 	}
	// 	'%' {
	// 		polygon(bg, [x - a, x + a, x], [y + d, y + d, y - c], style)
	// 	}
	// 	'W' {
	// 		polygon(bg, [x - a, x + a, x], [y - c, y - c, y + d], style)
	// 		for j := 1; j < a; j++ {
	// 			aa := (j * a) / a
	// 			dd := (j * d) / a
	// 			cc := (j * c) / a
	// 			polygon(bg, [x - aa, x + aa, x], [y - cc, y - cc, y + dd], style)
	// 		}
	// 	}
	// 	'V' {
	// 		polygon(bg, [x - a, x + a, x], [y - c, y - c, y + d], style)
	// 	}
	// 	'Z' {
	// 		polygon(bg, [x - e, x, x + e, x], [y, y + e, y, y - e], style)
	// 		for j := 1; j < e; j++ {
	// 			ee := (j * e) / e
	// 			polygon(bg, [x - ee, x, x + ee, x], [y, y + ee, y, y - ee], style)
	// 		}
	// 	}
	// 	'&' {
	// 		polygon(bg, [x - e, x, x + e, x], [y, y + e, y, y - e], style)
	// 	}
	// 	else {
	// 		bg.text(x, y, '?', 'cc', 0, Font{})
	// 	}
	// }
}

fn draw_title(g Plotter, text string, style Style) {
	w,_ := g.dimensions()
	_,fh,_ := g.font_metrics(style.font)
	x := w / 2
	y := fh / 3
	g.text(x, y, text, 'tc', 0, style.font)
}
