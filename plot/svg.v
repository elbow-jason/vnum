module plot

import os

struct SvgGraphic {
pub mut:
	w 	int
	h 	int
	svg string
	bg Color
	tx	int
	ty 	int
}

pub fn new_svg(w, h int) SvgGraphic {
	mut svg := SvgGraphic{}
	svg.w = w
	svg.h = h
	svg.bg = Color{0, 0, 0, 0.0}
	return svg
}

pub fn (s SvgGraphic) save_svg(fname string) {
	mut tmp := '<svg version="1.1" xmlns="http://www.w3.org/2000/svg" x="0px" y="0px" width="${s.w}px" height="${s.h}px">\n' + s.svg
	tmp += '</svg>'
	mut f := os.create(fname) or {
		return
	}
	f.write(tmp)
	f.close()
}

pub fn (s SvgGraphic) dimensions() (int, int) {
	return s.w, s.h
}

pub fn (s SvgGraphic) str() string {
	return s.svg
}

pub fn (s SvgGraphic) background() (byte, byte, byte, f64) {
	return s.bg.rgba()
}

pub fn (s mut SvgGraphic) circle(x, y, r int, stroke string, fill string) {
	s.svg += '<circle cx="$x" cy="$y" r="$r" stroke="'
	s.svg += stroke
	s.svg += '" fill="'
	s.svg += fill
	s.svg += '" />\n'
}

pub fn (s mut SvgGraphic) line(x1, y1, x2, y2 int, style Style) {
	r, g, b, _ := style.symbol_color.rgba()
	s.svg += '<line x1="$x1" y1="$y1" x2="$x2" y2="$y2" style="stroke:rgb($r,$g,$b);stroke-width:2" />\n'
}

pub fn (s mut SvgGraphic) text(x, y int, txt string, align int, rot int) {
	s.svg += '<text x="$x" y="$y" class="small" style="text-anchor:middle;" font-family="Tahoma, sans-serif">$txt</text>\n'
}

pub fn (s mut SvgGraphic) symbol(x, y int, style Style) {
	f := 1
	n := 5.0              // default size
	a := int(n*f + 0.5)       // standard
	mut b := int(n/2*f + 0.5)     // smaller
	c := int(1.155*n*f + 0.5) // triangel long sist
	d := int(0.577*n*f + 0.5) // triangle short dist
	e := int(0.866*n*f + 0.5) // diagonal

	match(style.symbol) {
		'*' {
			s.line(x-e, y-e, x+e, y+e, style)
			s.line(x-e, y+e, x+e, y-e, style)
		}
		'+' {
			s.line(x-a, y, x+a, y, style)
			s.line(x, y-a, x, y+a, style)
		}
		'X' {
			s.line(x-e, y-e, x+e, y+e, style)
			s.line(x-e, y+e, x+e, y-e, style)
		}
		'o' {
			s.circle(x, y, a, style.symbol_color.rgbas(), 'none')
		}
		'0' {
			s.circle(x, y, a, style.symbol_color.rgbas(), 'none')
			s.circle(x, y, b, style.symbol_color.rgbas(), 'none')
		}
		'.' {
			if b >=4 {
				b /= 2
			}
			s.circle(x, y, b, style.symbol_color.rgbas(), 'none')
		}
		'@' {
			s.circle(x, y, a, style.symbol_color.rgbas(), style.symbol_color.rgbas())
		}
		'=' {
			s.rect(x-e, y-e, 2*e, 2*e, style)
		}
		'#' {
			s.rect(x-e, y-e, 2*e, 2*e, style)
		}
		'A' {
			s.polygon([x-a, x+a, x], [y+d, y+d, y-c], style.symbol_color.rgbas(), style.symbol_color.rgbas())
		}
		'%' {
			s.polygon([x-a, x+a, x], [y+d, y+d, y-c], style.symbol_color.rgbas(), 'none')
		}
		'W' {
			s.polygon([x-a, x+a, x], [y-c, y-c, y+d], style.symbol_color.rgbas(), style.symbol_color.rgbas())
		}
		'V' {
			s.polygon([x-a, x+a, x], [y-c, y-c, y+d], style.symbol_color.rgbas(), 'none')
		}
		'Z' {
			s.polygon([x-e, x, x+e, x], [y, y+e, y, y-e], style.symbol_color.rgbas(), style.symbol_color.rgbas())
		}
		'&' {
			s.polygon([x-e, x, x+e, x], [y, y+e, y, y-e], style.symbol_color.rgbas(), 'none')
		}
		else {}
	}
}

pub fn (s mut SvgGraphic) polygon(xs, ys []int, stroke string, fill string) {
	s.svg += '<polygon points="'
	for i := 0; i < xs.len; i++ {
		s.svg += '${xs[i]},${ys[i]} '
	}
	s.svg += '" style="fill:'
	s.svg += fill
	s.svg += ";stroke:"
	s.svg += stroke
	s.svg += '" />\n'
} 

pub fn (s mut SvgGraphic) rect(x, y, w, h int, style Style) {
	fill := style.fill_color.rgbas()
	stroke := style.symbol_color.rgbas()
	s.svg += '<rect x="$x" y="$y" width="$w" height="$h" style="fill:$fill;stroke-width:3;stroke:$stroke" />\n'
}

pub fn (s mut SvgGraphic) bounding_box(x, y, w, h int) {
	s.svg += '<rect x="$x" y="$y" width="$w" height="$h" style="fill:none;stroke-width:3;stroke:black" />\n'	
}
