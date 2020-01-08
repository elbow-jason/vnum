module plot

pub const (
	Edge = [['+', '+', '+', '+'], ['.', '.', "\'", "\'"], ['/', '\\', '\\', '/']]
)
// A Text Buffer
struct TextBuf {
pub mut:
	buf []string // the internal buffer.  Point (x,y) is mapped to x + y*(W+1)
	w   int
	h   int
}

// Set up a new TextBuf with width w and height h.
fn new_text_buf(w, h int) TextBuf {
	mut tb := TextBuf{}
	tb.w = w
	tb.h = h
	tb.buf = [].repeat((w + 1) * h)
	for i := 0; i < tb.buf.len; i++ {
		tb.buf[i] = ' '
	}
	for i := 0; i < h; i++ {
		tb.buf[i * (w + 1) + w] = '\n'
	}
	return tb
}

// Put character c at (x,y)
fn (tb mut TextBuf) put(x, y int, c string) {
	if x < 0 || y < 0 || x >= tb.w || y >= tb.h || c < ' ' {
		return
	}
	i := (tb.w + 1) * y + x
	tb.buf[i] = c
}

// Draw rectangle of width w and height h from corner at (x,y). // Use one of the corner style defined in Edge. // Interior is filled with charater fill iff != 0.
fn (tb mut TextBuf) rect(tx, ty, tw, th int, mstyle int, fill string) {
	mut x := tx
	mut y := ty
	mut w := tw
	mut h := th
	style := mstyle % Edge.len
	if h < 0 {
		h = -h
		y -= h
	}
	if w < 0 {
		w = -w
		x -= w
	}
	tb.put(x, y, Edge[style][0])
	tb.put(x + w, y, Edge[style][1])
	tb.put(x, y + h, Edge[style][2])
	tb.put(x + w, y + h, Edge[style][3])
	for i := 1; i < w; i++ {
		tb.put(x + i, y, '-')
		tb.put(x + i, y + h, '-')
	}
	for i := 1; i < h; i++ {
		tb.put(x + w, y + i, '|')
		tb.put(x, y + i, '|')
		if fill != ' ' {
			for j := x + 1; j < x + w; j++ {
				tb.put(j, y + i, fill)
			}
		}
	}
}

fn (tb mut TextBuf) block(tx, ty, tw, th int, fill string) {
	mut x := tx
	mut y := ty
	mut h := th
	mut w := tw
	if h < 0 {
		h = -h
		y -= h
	}
	if w < 0 {
		w = -w
		x -= w
	}
	for i := 0; i < w; i++ {
		for j := 0; j <= h; j++ {
			tb.put(x + i, y + j, fill)
		}
	}
}

// Return real character len of s (rune count).
fn str_len(s string) int {
	return s.len
}

// Print text txt at (x,y). Horizontal display for align in [-1,1], // vasrtical alignment for align in [2,4] // align: -1: left; 0: centered; 1: right; 2: top, 3: center, 4: bottom
fn (tb mut TextBuf) text(tx, ty int, txt string, align int) {
	mut x := tx
	mut y := ty
	if align <= 1 {
		match (align) {
			0 {
				x -= str_len(txt) / 2
			}
			1 {
				x -= str_len(txt)
			}
			else {}
	}
		for i := 0; i < txt.len; i++ {
			tb.put(x + i, y, txt[i..i + 1])
		}
	}
	else {
		match (align) {
			3 {
				y -= str_len(txt) / 2
			}
			2 {
				x -= str_len(txt)
			}
			else {}
	}
		for i := 0; i < txt.len; i++ {
			tb.put(x, y + i, txt[i..i + 1])
		}
	}
}

// Paste buf at (x,y)
fn (tb mut TextBuf) paste(x, y int, buf &TextBuf) {
	s := buf.w + 1
	for i := 0; i < buf.w; i++ {
		for j := 0; j < buf.h; j++ {
			tb.put(x + i, y + j, buf.buf[i + s * j])
		}
	}
}

fn (tb mut TextBuf) line(tx0, ty0, tx1, ty1 int, symbol string) {
	mut x0 := tx0
	mut x1 := tx1
	mut y1 := ty1
	mut y0 := ty0
	// handle trivial cases first
	if x0 == x1 {
		if y0 > y1 {
			tmp := y0
			y0 = y1
			y1 = tmp
		}
		for ; y0 <= y1; y0++ {
			tb.put(x0, y0, symbol)
		}
		return
	}
	if y0 == y1 {
		if x0 > x1 {
			tmp := x0
			x0 = x1
			x1 = tmp
		}
		for ; x0 <= x1; x0++ {
			tb.put(x0, y0, symbol)
		}
		return
	}
	dx := abs(x1 - x0)
	dy := -abs(y1 - y0)
	sx := sign(x1 - x0)
	sy := sign(y1 - y0)
	mut err := dx + dy
	mut e2 := 0
	for {
		tb.put(x0, y0, symbol)
		if x0 == x1 && y0 == y1 {
			return
		}
		e2 = 2 * err
		if e2 >= dy {
			err += dy
			x0 += sx
		}
		if e2 <= dx {
			err += dx
			y0 += sy
		}
	}
}

// Convert to plain (utf8) string.
pub fn (tb TextBuf) str() string {
	return tb.buf.join('')
}

fn min(a, b int) int {
	if a < b {
		return a
	}
	return b
}

fn max(a, b int) int {
	if a > b {
		return a
	}
	return b
}

fn abs(a int) int {
	if a < 0 {
		return -a
	}
	return a
}

fn sign(a int) int {
	if a < 0 {
		return -1
	}
	if a == 0 {
		return 0
	}
	return 1
}
