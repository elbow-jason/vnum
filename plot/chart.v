module plot

import math

pub const (
	Units = [' y', ' z', ' a', ' f', ' p', ' n', ' µ', 'm',
	' k', ' M', ' G', ' T', ' P', ' E', ' Z', ' Y']
	ExpandNextTic = 0
	ExpandToTic = 1
	ExpandTight = 2
	ExpandABit = 3
)

struct RangeMode {
	fixed       bool
	constrained bool
	expand      int
	value       f64
	lower       f64
	upper       f64
}

struct Tics {
pub mut:
	hide  bool
	first f64
	last  f64
	delta f64
	minor int
}

struct Range {
pub mut:
	log         bool
	date        bool
	min_mode    RangeMode
	max_mode    RangeMode
	data_min    f64
	data_max    f64
	min         f64
	max         f64
	tics        Tics
	data2screen fn(f64, int, Range, int)int
	screen2data fn(int, int, Range, int)f64
}

fn fmt(f f64) string {
	buf := malloc(8 * 5 + 1) // TODO
	C.sprintf(charptr(buf), '%.1f', f)
	return tos(buf, vstrlen(buf))
}

fn format_float(f f64) string {
	mut mf := f
	if mf == 0 {
		return '0'
	}
	else if 0.0 <= mf && mf < 10 {
		return fmt(mf)
	}
	else if 10.0 <= mf && mf <= 1000 {
		ft := '%.0f'
		return fmt(mf)
	}
	if mf < 1 {
		mut p := 8
		for {
			if !(mf < 1 && p >= 0) {
				break
			}
			mf *= 1000
			p--
		}
		return format_float(mf) + Units[p]
	}
	else {
		mut p := 7
		for {
			if !(mf > 1000 && p < 16) {
				break
			}
			mf /= 1000
			p++
		}
		return format_float(mf) + Units[p]
	}
}

fn almost_equal(a, b f64) bool {
	rd := math.abs((a - b) / (a + b))
	return rd < 1e-5
}

fn bound(mode RangeMode, val f64, tic_delta f64, upper bool) f64 {
	mut mval := val
	if mode.fixed {
		return mode.value
	}
	if mode.constrained {
		if mval < mode.lower {
			mval = mode.lower
		}
		else if val > mode.upper {
			mval = mode.upper
		}
	}
	match (mode.expand) {
		ExpandToTic, ExpandNextTic {
			mut v := 0.0
			if upper {
				v = math.ceil(mval / tic_delta) * tic_delta
			}
			else {
				v = math.floor(mval / tic_delta) * tic_delta
			}
			if mode.expand == ExpandNextTic && almost_equal(v, mval) {
				if upper {
					v += tic_delta
				}
				else {
					v -= tic_delta
				}
			}
			mval = v
		}
		ExpandABit {
			if upper {
				mval += tic_delta / 2
			}
			else {
				mval -= tic_delta / 2
			}
		}
		else {}
	}
	return mval
}

fn d2s_no_revert(x f64, width int, r Range, offset int) int {
	return int(math.floor(f64(width) * (x - r.min) / (r.max - r.min))) + offset
}

fn s2d_no_revert(x int, width int, r Range, offset int) f64 {
	return (r.max - r.min) * f64(x - offset) / f64(width) + r.min
}

fn d2s_revert(x f64, width int, r Range, offset int) int {
	return width - int(math.floor(f64(width) * (x - r.min) / (r.max - r.min))) + offset
}

fn s2d_revert(x int, width int, r Range, offset int) f64 {
	return (r.max - r.min) * f64(x - offset) / f64(width) + r.min
}

fn (r mut Range) setup(num_ticks, s_width, s_offset int, revert bool) {
	mut mnum_ticks := num_ticks
	if mnum_ticks <= 1 {
		mnum_ticks = 2
	}
	mut delta := (r.data_max - r.data_min) / f64(mnum_ticks - 1)
	mut de := math.floor(math.log10(delta))
	mut f := delta / math.pow(10, de)
	if f < 2 {
		f = 1
	}
	else if f < 4 {
		f = 2
	}
	else if f < 9 {
		f = 5
	}
	else {
		f = 1
		de++
	}
	delta = f * math.pow(10, de)
	r.min = bound(r.min_mode, r.data_min, delta, false)
	r.max = bound(r.max_mode, r.data_max, delta, true)
	r.tics.first = delta * math.ceil(r.min / delta)
	r.tics.last = delta * math.floor(r.max / delta)
	r.tics.delta = delta
	if !revert {
		r.data2screen = d2s_no_revert
		r.screen2data = s2d_no_revert
	}
	else {
		r.data2screen = d2s_revert
		r.screen2data = s2d_revert
	}
}

struct KeyEntry {
	symbol string
	text   string
}

struct DataStyle {
	symbol int
	line   int
	size   f64
	color  int
}

struct Point {
pub mut:
	x f64
	y f64
}

struct Layout {
	cols int
	rows int
}

struct Key {
pub mut:
	hide   bool
	layout Layout
	border int
	pos    string
	x      int
	y      int
}
