module plot

import os

struct SvgGraphic {
pub mut:
	w 	int
	h 	int
	svg string
}

pub fn new_svg(w, h int) SvgGraphic {
	mut svg := SvgGraphic{}
	svg.w = w
	svg.h = h

	return svg
}

pub fn (s mut SvgGraphic) circle(x, y, r int) {
	s.svg += '<circle cx="$x" cy="$y" r="$r" fill="red" />\n'
}

pub fn (s mut SvgGraphic) line(x1, y1, x2, y2 int) {
	s.svg += '<line x1="$x1" y1="$y1" x2="$x2" y2="$y2" stroke="black" />'
}

pub fn (s mut SvgGraphic) put(x, y int, symbol string) {
	f := 1
	n := 5.0              // default size
	a := int(n*f + 0.5)       // standard
	b := int(n/2*f + 0.5)     // smaller
	c := int(1.155*n*f + 0.5) // triangel long sist
	d := int(0.577*n*f + 0.5) // triangle short dist
	e := int(0.866*n*f + 0.5) // diagonal

	match(symbol) {
		'*' {
			s.line(x-e, y-e, x+e, y+e)
			s.line(x-e, y+e, x+e, y-e)
		}
		'+' {
			s.line(x-a, y, x+a, y)
			s.line(x, y-a, x, y+a)
		} else {}
	}
}

pub fn (s mut SvgGraphic) text(x, y int, txt string, align int) {
	s.svg += '<text x="$x" y="$y" class="small">$txt</text>\n'
}

pub fn (s mut SvgGraphic) finalize(fname string) {
	s.svg = '<svg version="1.1" id="Layer_1" xmlns="http://www.w3.org/2000/svg" x="0px" y="0px" width="${s.w}px" height="${s.h}px">\n' + s.svg
	s.svg = '<?xml version="1.0" encoding="utf-8"?>\n' + s.svg
	s.svg += '</svg>'
	mut f := os.create(fname) or {
		return
	}
	f.write(s.svg)
	f.close()
}

pub fn (s mut SvgGraphic) rect(x, y, w, h int, style int, fill string) {
	s.svg += '<rect x="$x" y="$y" width="$w" height="$h" style="fill:rgba(0,0,0,0);stroke-width:3;stroke:rgb(0,0,0)" />\n'
}

pub fn (s mut SvgGraphic) block(x, y, w, h int, fill string) {
	s.svg += '<rect x="$x" y="$y" width="$w" height="$h" style="fill:rgba(0,0,0,0);stroke-width:3;stroke:rgb(0,0,0)" />\n'
}