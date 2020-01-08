module plot

import gx
import math

const (
	Symbol = ['o', // empty circle
	'=', // empty square
	'%', // empty triangle up
	'&', // empty diamond
	'+', // plus
	'X', // cross
	'*', // star
	'0', // bulls eys
	'@', // filled circle
	'#', // filled square
	'A', // filled triangle up
	'W', // filled triangle down
	'V', // empty triangle down
	'Z', // filled diamond
	'.', // tiny dot
	]
	CharacterWidth = {
		'a': 16.8,
		'b': 17.0,
		'c': 15.2,
		'd': 16.8,
		'e': 16.8,
		'f': 8.5,
		'g': 17.0,
		'h': 16.8,
		'i': 5.9,
		'j': 5.9,
		'k': 16.8,
		'l': 6.9,
		'm': 25.5,
		'n': 16.8,
		'o': 16.8,
		'p': 17.0,
		'q': 17.0,
		'r': 10.2,
		's': 15.2,
		't': 8.4,
		'u': 16.8,
		'v': 15.4,
		'w': 22.2,
		'x': 15.2,
		'y': 15.2,
		'z': 15.2,
		'A': 20.2,
		'B': 20.2,
		'C': 22.2,
		'D': 22.2,
		'E': 20.2,
		'F': 18.6,
		'G': 23.5,
		'H': 22.0,
		'I': 8.2,
		'J': 15.2,
		'K': 20.2,
		'L': 16.8,
		'M': 25.5,
		'N': 22.0,
		'O': 23.5,
		'P': 20.2,
		'Q': 23.5,
		'R': 21.1,
		'S': 20.2,
		'T': 18.5,
		'U': 22.0,
		'V': 20.2,
		'W': 29.0,
		'X': 20.2,
		'Y': 20.2,
		'Z': 18.8,
		// ' ': 8.5,
		'1': 16.8,
		'2': 16.8,
		'3': 16.8,
		'4': 16.8,
		'5': 16.8,
		'6': 16.8,
		'7': 16.8,
		'8': 16.8,
		'9': 16.8,
		'0': 16.8,
		'.': 8.2,
		',': 8.2,
		':': 8.2,
		';': 8.2,
		'+': 17.9,
		'*': 11.8,
		'%': 27.0,
		'&': 20.2,
		'/': 8.4,
		'(': 10.2,
		')': 10.2,
		'=': 18.0,
		'?': 16.8,
		'!': 8.5,
		'[': 8.2,
		']': 8.2,
		'{': 10.2,
		'}': 10.2,
		'$': 16.8,
		'<': 18.0,
		'>': 18.0
	}
	AverageCharacterWidth = 15
)
// LineStyles
pub const (
	SolidLine = 0
	DashedLine = 1
	DottedLine = 2
	DashDotDotLine = 3
	LongDashLine = 4
	LongDotLine = 5
)
// PlotStyles
pub const (
	PlotStylePoints = 0
	PlotStyleLines = 1
	PlotStyleLinesPoints = 2
	PlotStyleBox = 3
)
// FontSizes
pub const (
	TinyFontSize = 0
	SmallFontSize = 1
	NormalFontSize = 2
	LargeFontSize = 3
	HugeFontSize = 4
)

fn symbol_index(s string) int {
	for idx := 0; idx < Symbol.len; idx++ {
		if Symbol[idx] == s {
			return idx
		}
	}
	return -1
}

fn next_symbol(s string) string {
	idx := symbol_index(s)
	return Symbol[(idx + 1) % Symbol.len]
}

struct Style {
pub mut:
	symbol       string
	symbol_color gx.Color
	symbol_size  f64
	line_style   int
	line_color   gx.Color
	line_width   int
	font         Font
	fill_color   gx.Color
}

struct Font {
	name  string
	size  int
	color gx.Color
}

const (
	StandardColors = [gx.Color {
		r: 255
		g: 0
		b: 0
	}, // red
	gx.Color {
		r: 0
		g: 255
		b: 0
	}, // green
	gx.Color {
		r: 0
		g: 0
		b: 255
	}, // blue
	gx.Color {
		r: 255
		g: 165
		b: 0
	}, // orange
	gx.Color {
		r: 238
		g: 130
		b: 238
	}, // violet
	gx.Color {
		r: 64
		g: 224
		b: 208
	}, // turquoise
	gx.Color {
		r: 255
		g: 255
		b: 0
	}, // yellow
	]
	StandardLineStyles = [SolidLine,
	DashedLine,
	DottedLine,
	LongDashLine,
	LongDotLine]
	StandardSymbols = ['o', '=', '%', '&', '+', 'X', '*', '@', '#', 'A', 'Z']
	StandardFillFactor = 0.5
)

fn auto_style(i int, fill bool) Style {
	mut style := Style{}
	nc := StandardColors.len
	nl := StandardLineStyles.len
	ns := StandardSymbols.len
	si := i % ns
	ci := i % nc
	li := i % nl
	style.symbol = StandardSymbols[si]
	style.symbol_color = StandardColors[ci]
	style.line_color = StandardColors[ci]
	style.symbol_size = 1
	if fill {
		style.line_style = SolidLine
		style.line_width = 3
		if i < nc {
			style.fill_color = lighter(style.line_color, StandardFillFactor)
		}
		else if i <= 2 * nc {
			style.fill_color = darker(style.line_color, StandardFillFactor)
		}
		else {
			style.fill_color = style.line_color
		}
	}
	else {
		style.line_style = StandardLineStyles[li]
		style.line_width = 1
	}
	return style
}

// PlotElements
pub const (
	MajorAxisElement = 0
	MinorAxisElement = 1
	MajorTicElement = 2
	MinorTicElement = 3
	ZeroAxisElement = 4
	GridLineElement = 5
	GridBlockElement = 6
	KeyElement = 7
	TitleElement = 8
	RangeLimitElement = 9
	DefaultOptions = {
		'0': Style{
			line_color: gx.Color {
				0,0,0}
			line_width: 2
			line_style: SolidLine
		}, // axis
		'1': Style{
			line_color: gx.Color {
				0,0,0}
			line_width: 2
			line_style: SolidLine
		}, // mirrored axis
		'2': Style{
			line_color: gx.Color {
				0,0,0}
			line_width: 1
			line_style: SolidLine
		},
		'3': Style{
			line_color: gx.Color {
				0,0,0}
			line_width: 1
			line_style: SolidLine
		},
		'4': Style{
			line_color: gx.Color {
				64,64,64}
			line_width: 1
			line_style: SolidLine
		},
		'5': Style{
			line_color: gx.Color {
				0x80,0x80,0x80}
			line_width: 1
			line_style: SolidLine
		},
		'6': Style{
			line_color: gx.Color {
				0xe6,0xfc,0xfc}
			line_width: 0
			fill_color: gx.Color {
				0xe6,0xfc,0xfc}
		},
		'7': Style{
			line_color: gx.Color {
				0x20,0x20,0x20}
			line_width: 1
			line_style: SolidLine
			fill_color: gx.Color {
				0xf0,0xf0,0xf0}
			font: Font{
				size: SmallFontSize
			}
		},
		'8': Style{
			line_color: gx.Color {
				0,0,0}
			line_width: 1
			line_style: SolidLine
			fill_color: gx.Color {
				0xec,0xc7,0x50}
			font: Font{
				size: LargeFontSize
			}
		},
		'9': Style{
			font: Font{
				size: SmallFontSize
			}
		}
	}
)

fn element_style(options map[string]Style, element int) Style {
	se := element.str()
	if se in options {
		return options[se]
	}
	else {
		return DefaultOptions[se]
	}
}

fn f3max(a, b, c f64) f64 {
	if a > b && a >= c {
		return a
	}
	else if b > c && b >= a {
		return b
	}
	else if c > a && c >= b {
		return c
	}
	return a
}

fn f3min(a, b, c f64) f64 {
	if a < b && a <= c {
		return a
	}
	else if b < c && b <= a {
		return b
	}
	else if c < a && c <= b {
		return c
	}
	return a
}

fn rgb2hsv(r, g, b int) (int,int,int) {
	R := f64(r) / 255
	G := f64(g) / 255
	B := f64(b) / 255
	mut h := 0
	mut s := 0
	mut v := 0
	if R == G && G == B {
		h = 0
		s = 0
		v = r * 255
	}
	else {
		max := f3max(R, G, B)
		min := f3min(R, G, B)
		if max == R {
			h = int(f64(60) * (G - B) / (max - min))
		}
		else if max == G {
			h = int(f64(60) * (f64(2) + (B - R) / (max - min)))
		}
		else {
			h = int(f64(60) * (f64(4) + (R - G) / (max - min)))
		}
		if max == 0 {
			s = 0
		}
		else {
			s = int(f64(100) * (max - min) / max)
		}
		v = int(f64(100) * max)
	}
	if h < 0 {
		h += 360
	}
	return h,s,v
}

fn hsv2rgb(h, s, v int) (int,int,int) {
	H := int(math.floor(f64(h) / 60))
	S := f64(s) / 100
	V := f64(v) / 100
	f := f64(h) / 60 - f64(H)
	p := V * (f64(1) - S)
	q := V * (f64(1) - S * f)
	t := V * (f64(1) - S * (f64(1) - f))
	match (H) {
		0, 6 {
			return int(f64(255) * V),int(f64(255) * t),int(f64(255) * p)
		}
		1 {
			return int(f64(255) * q),int(f64(255) * V),int(f64(255) * p)
		}
		2 {
			return int(f64(255) * p),int(f64(255) * V),int(f64(255) * t)
		}
		3 {
			return int(f64(255) * p),int(f64(255) * q),int(f64(255) * V)
		}
		4 {
			return int(f64(255) * t),int(f64(255) * p),int(f64(255) * V)
		}
		5 {
			return int(f64(255) * V),int(f64(255) * p),int(f64(255) * q)
		}
		else {
			return 0,0,0
		}
	}
}

fn lighter(col gx.Color, f f64) gx.Color {
	r := col.r
	g := col.g
	b := col.b
	h,mut s,mut v := rgb2hsv(r / 256, g / 256, b / 256)
	mf := f64(1) - f
	s = int(f64(s) * mf)
	v += int((f64(100) - f64(v)) * mf)
	if v > 100 {
		v = 100
	}
	rr,gg,bb := hsv2rgb(h, s, v)
	return gx.Color {
		rr,gg,bb}
}

fn darker(col gx.Color, f f64) gx.Color {
	r := col.r
	g := col.g
	b := col.b
	h,mut s,mut v := rgb2hsv(r, g, b)
	mf := f64(1) - f
	v = int(f64(v) * mf)
	s += int((f64(100) - f64(s)) * mf)
	if s > 100 {
		s = 100
	}
	rr,gg,bb := hsv2rgb(h, s, v)
	return gx.Color {
		rr,gg,bb}
}
