module plot

pub const (
	EDGE = [['+', '+', '+', '+'], ['.', '.', "\'", "\'"], ['/', '\\', '\\', '/']]
	SYMBOL = ['*', '+', 'o', '#', '=']
)

struct TextBuf {
pub mut:
	buf []string
	w   int
	h   int
}

pub fn new_text_buf(w, h int) TextBuf {
	mut tb := TextBuf{}
	tb.w = w
	tb.h = h
	tb.buf = [' '].repeat((w + 1) * h)
	for i := 0; i < h; i++ {
		tb.buf[i * (w + 1) + w] = '\n'
	}
	return tb
}

fn (tb mut TextBuf) put(x, y int, c string) {
	xx := x % tb.w
	yy := y % tb.h
	i := (tb.w + 1) * yy + xx
	if tb.buf[i] == '\n' {
		println('Warning, setting an element at a newline')
	}
	tb.buf[i] = c
}

pub fn (tb mut TextBuf) rect(x, y, w, h int, style int, fill string) {
	rstyle := style % 3
	tb.put(x, y, EDGE[rstyle][0])
	tb.put(x + w, y, EDGE[rstyle][1])
	tb.put(x, y + h, EDGE[rstyle][2])
	tb.put(x + w, y + h, EDGE[rstyle][3])
	for i := 1; i < w; i++ {
		tb.put(x + i, y, '-')
		tb.put(x + i, y + h, '-')
	}
	for i := 1; i < h; i++ {
		tb.put(x + w, y + i, '|')
		tb.put(x, y + i, '|')
	}
}

fn (tb mut TextBuf) text(x, y int, txt string, align int) {
	mut mx := x
	mut my := y
	if align <= 1 {
		match (align) {
			0 {
				mx -= txt.len / 2
			}
			1 {
				mx -= txt.len
			}
			else {}
	}
		for i in 0 .. txt.len {
			tb.put(mx + i, my, txt[i..i + 1])
		}
	}
	else {
		match (align) {
			3 {
				my -= txt.len / 2
			}
			2 {
				mx -= txt.len
			}
			else {}
	}
		for i in 0 .. txt.len {
			tb.put(mx, my + i, txt[i..i + 1])
		}
	}
}

fn (tb mut TextBuf) paste(x, y int, buf TextBuf) {
	s := buf.w + 1
	for i := 0; i < buf.w; i++ {
		for j := 0; j < buf.h; j++ {
			tb.put(x + i, y + j, buf.buf[i + s * j])
		}
	}
}

pub fn (tb TextBuf) str() string {
	return tb.buf.join('')
}
