module plot

struct Color {
	r byte
	g byte
	b byte
	a f64
}

struct Range {
	min	f64
	max f64
}

pub fn (r Range) bound(f f64) f64 {
	return (f - r.min) / (r.max-r.min)
}

pub fn (c Color) rgba() (byte, byte, byte, f64) {
	return c.r, c.g, c.b, c.a
}

pub fn (c Color) rgbas() string {
	r, g, b, a := c.rgba()
	return 'rgba($r, $g, $b, $a)'
}

struct Style {
pub mut:
	symbol string
	symbol_color Color
	symbol_size f64
	fill_color Color
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
	Colors = [
		Color{31, 119, 180, 1},
		Color{255, 127, 14, 1},
		Color{148, 103, 189, 1}
	]
)