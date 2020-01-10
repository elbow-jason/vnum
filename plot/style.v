module plot

struct FontOptions {
mut:
	size	string = "small"
	family	string = "Tahoma"
	color Color
}

struct TextOptions {
mut:
	font	FontOptions
	align	string = "middle"
}

struct Color {
	r byte = byte(0)
	g byte = byte(0)
	b byte = byte(0)
	a f64 = f64(0.0)
}

pub fn (c Color) rgba() (byte, byte, byte, f64) {
	return c.r, c.g, c.b, c.a
}

pub fn (c Color) rgbas() string {
	r, g, b, a := c.rgba()
	return 'rgba($r, $g, $b, $a)'
}

pub const(
	Colors = [
		Color{31, 119, 180, 1},
		Color{255, 127, 14, 1},
		Color{148, 103, 189, 1},
		Color{214, 39, 40, 1},
		Color{149, 103, 189, 1}
	]
	BLACK = Color{0, 0, 0, 1}
	WHITE	= Color{255, 255, 255, 1}
	OPAQUE = Color{0, 0, 0, 0}
)

fn new_font_options() FontOptions {
	mut fo := FontOptions{}
	fo.color = BLACK
	return fo
}

fn new_text_options() TextOptions {
	mut to := TextOptions{}
	to.font = new_font_options()
	return to
}