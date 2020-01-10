module plot

struct Range {
mut:
	min	f64 = f64(0.0)
	max f64 = f64(0.0)
}

pub fn (r Range) bound(f f64, x, y int) f64 {
	a := (f - r.min) / (r.max-r.min)
	return a * (y - x) + x
}

struct Style {
pub mut:
	symbol string
	symbol_color Color
	symbol_size f64
	fill_color Color
}

struct ChartOptions {
	border_padding	int = 30
	data_padding	int = 40
}

interface Renderer {
	background() (byte, byte, byte, f64)
	line(x0, y0, x1, y1 int, style Style)
	text(x, y int, t string, align string, rot int)
	symbol(x, y int, style Style)
	rect(x, y, w, h int, style Style)
	dimensions() (int, int)
}

pub const(
	Symbol = [
		'o', // empty circle
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
)