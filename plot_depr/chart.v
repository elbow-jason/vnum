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

struct Tic {
pub mut:
	pos       f64
	label_pos f64
	label     string
	align     int
}

struct TicSetting {
pub mut:
	hide  bool
	minor int
	delta f64
	fmt   string
}

struct Range {
pub mut:
	log         bool
	date        bool
	min_mode    RangeMode
	max_mode    RangeMode
	tic_setting TicSetting
	data_min    f64
	data_max    f64
	min         f64
	max         f64
	tics        []Tic
	norm        fn(f64)f64
	inv_norm    fn(f64)f64
	data2screen fn(f64, Range)int
	screen2data fn(int, Range)f64
	width       int
	offset      int
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

fn d2s_no_revert(x f64, r Range) int {
	return int(math.floor(f64(r.width) * (x - r.min) / (r.max - r.min))) + r.offset
}

fn s2d_no_revert(x int, r Range) f64 {
	return (r.max - r.min) * f64(x - r.offset) / f64(r.width) + r.min
}

fn d2s_revert(x f64, r Range) int {
	return r.width - int(math.floor(f64(r.width) * (x - r.min) / (r.max - r.min))) + r.offset
}

fn s2d_revert(x int, r Range) f64 {
	return (r.max - r.min) * f64(x - r.offset) / f64(r.width) + r.min
}

fn (r mut Range) setup(mnum_ticks, mmax_num_ticks, s_width, s_offset int, revert bool) {
	r.width = s_width
	r.offset = s_offset
	mut num_ticks := mnum_ticks
	mut max_num_ticks := mmax_num_ticks
	if num_ticks <= 1 {
		num_ticks = 2
	}
	if max_num_ticks < num_ticks {
		max_num_ticks = num_ticks
	}
	if r.data_max == r.data_min {
		r.data_max = r.data_min + 1
	}
	mut delta := (r.data_max - r.data_min) / f64(num_ticks - 1)
	mindelta := (r.data_max - r.data_min) / f64(max_num_ticks - 1)
	mut de := math.pow(10, int(math.floor(math.log10(delta))))
	mut f := delta / de
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
		de *= 10
	}
	delta = f * de
	if delta < mindelta {
		match (f) {
			1, 5 {
				delta *= 2
			}
			2 {
				delta *= 2.5
			}
			else {}
	}
	}
	r.min = bound(r.min_mode, r.data_min, delta, false)
	r.max = bound(r.max_mode, r.data_max, delta, true)
	r.tic_setting.delta = delta
	first := delta * math.ceil(r.min / delta)
	num := int(-first / delta + math.floor(r.max / delta) + 1.5)
	r.tics = []
	// for i, x := 0, first; i < num; i, x = i+1, x+delta { // r.tics[i].Pos, r.tics[i].LabelPos = x, x // r.tics[i].Label = FmtFloat(x) // }
	mut i := 0
	mut x := 0
	for i < num {
		mut t := Tic{}
		t.pos = x
		t.label_pos = x
		t.label = format_float(x)
		r.tics << t
		i++
		x += int(delta)
	}
	if !revert {
		r.data2screen = d2s_no_revert
		r.screen2data = s2d_no_revert
		// r.Data2Screen = func(x f64) int { // return int(math.Floor(f64(sWidth)*(x-r.min)/(r.max-r.min))) + sOffset // } // r.Screen2Data = func(x int) f64 { // return (r.max-r.min)*f64(x-sOffset)/f64(sWidth) + r.min // }
	}
	else {
		r.data2screen = d2s_revert
		r.screen2data = s2d_revert
		// r.Data2Screen = func(x f64) int { // return sWidth - int(math.Floor(f64(sWidth)*(x-r.min)/(r.max-r.min))) + sOffset // } // r.Screen2Data = func(x int) f64 { // return (r.max-r.min)*f64(-x+sOffset+sWidth)/f64(sWidth) + r.min // }
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
