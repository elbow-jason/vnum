module plot

import math
// Chart ist the very simple interface for all charts: They can be plotted to a graphics output.
interface Charter {
	plot (p Plotter) // Plot the chart to g.
	reset() // Reset any setting made during last plot.
}
// Suitable values for Expand in RangeMode.
const (
	ExpandNextTic = 0 // Set min/max to next tic really below/above min/max of data.
	ExpandToTic = 1 // Set to next tic below/above or equal to min/max of data.
	ExpandTight = 2 // Use data min/max as limit.
	ExpandABit = 3 // Like ExpandToTic and add/subtract ExpandABitFraction of tic distance.
	// ExpandABitFraction is the fraction of a major tic spacing added during
	// axis range expansion with the ExpandABit mode.
	ExpandABitFraction = 0.5
)
// RangeMode describes how one end of an axis is set up. There are basically three different main modes:
// * fixed: fixed==true.
// Use value/t_value as fixed value this ignoring the actual data range.
// * Unconstrained autoscaling: fixed==false && Constrained==false.
// Set range to whatever data requires.
// * Constrained autoscaling: fixed==false && Constrained==true.
// Scale axis according to data present, but limit scaling to intervall [Lower,Upper]
// For both autoscaling modes Expand defines how much expansion is done below/above
// the lowest/highest data point.
struct RangeMode {
pub mut:
	fixed       bool // If false: autoscaling. If true: use (T)value/t_value as fixed setting
	constrained bool // If false: full autoscaling. If true: use (T)Lower (T)Upper as limits
	expand      int // One of ExpandNextTic, ExpandTight, ExpandABit
	value       f64 // value of end point of axis in fixed=true mode, ignorder otherwise
	lower       f64 // Lower and upper limit for constrained autoscaling
	upper       f64
}

const (
	GridOff = 0 // No grid lines
	GridLines = 1 // Grid lines
	GridBlocks = 2 // Zebra style background
)

const (
	MirrorAxisAndTics = 0 // draw a full mirrored axis including tics
	MirrorNothing = -1 // do not draw a mirrored axis
	MirrorAxisOnly = 1 // just draw a mirrord axis, but omit tics
)
// TicSetting describes how (if at all) tics are shown on an axis.
struct TicSetting {
pub mut:
	hide        bool // dont show tics if true
	hide_labels bool // don't show tic labels if true
	tics        int // 0: across axis,  1: inside,  2: outside,  other: off
	minor       int // 0: off,  1: auto,  >1: number of intervalls (not number of tics!)
	delta       f64 // wanted step between major tics.  0 means auto
	grid        int // GridOff, GridLines, GridBlocks
	mirror      int // 0: mirror axis and tics, -1: don't mirror anything, 1: mirror axis only (no tics)
	// Format is used to print the tic labels. If unset fmt_float is used.
	format      fn(f64)string
	user_delta  bool // true if Delta or TDelta was input
}
// Tic describs a single tic on an axis.
struct Tic {
pub mut:
	pos       f64 // position of the tic on the axis (in data coordinates).
	label_pos f64 // position of the label on the axis (in data coordinates).
	label     string // the Label of the tic
	align     int // alignment of the label:  -1: left/top,  0 center,  1 right/bottom (unused)
}
// Range encapsulates all information about an axis.
struct Range {
pub mut:
	label         string // Label of axis
	log           bool // Logarithmic axis?
	min_mode      RangeMode // How to handel min and max of this axis/range
	max_mode      RangeMode
	tic_setting   TicSetting // How to handle tics.
	data_min      f64 // Actual min/max values from data. If both zero: not calculated
	data_max      f64
	show_limits   bool // Display axis Min and Max values on plot
	show_zero     bool // Add line to show 0 of this axis
	category      []string // If not empty (and neither Log nor Time): Use Category[n] as tic label at pos n+1.
	min           f64 // Actual minium and maximum of this axis/range.
	max           f64
	tics          []Tic // List of tics to display
	// The following fntions are set up during plotting
	norm          fn(f64, f64, f64)f64 // fntion to map [Min:Max] to [0:1]
	inv_norm      fn(f64, f64, f64)f64 // Inverse of Norm()
	data_2_screen fn(f64, int, int, f64, f64, fn(f64, f64, f64)f64)int // fntion to map data value to screen position
	screen_2_data fn(f64, int, int, f64, f64, fn(f64, f64, f64)f64)f64 // Inverse of Data2Screen
	offset        int
	width         int
}

// fixed is a helper (just reduces typing) fntions which turns of autoscaling
// and sets the axis range to [min,max] and the tic distance to delta.
fn (r mut Range) fixed(min, max, delta f64) {
	r.min_mode.fixed = true
	r.max_mode.fixed = true
	r.min_mode.value = min
	r.max_mode.value = max
	r.tic_setting.delta = delta
}

// Reset the fields in r which have been set up during a plot.
fn (r mut Range) reset() {
	r.min = 0
	r.max = 0
	r.tics = []
	r.norm = reg_norm
	r.inv_norm = reg_inv_norm
	r.data_2_screen = d2s_norevert
	r.screen_2_data = s2d_norevert
	if !r.tic_setting.user_delta {
		r.tic_setting.delta = 0
	}
}

// Prepare the range r for use, especially set up all values needed for autoscale() to work properly.
fn (r mut Range) init() {
	// All the min stuff
	if r.min_mode.fixed {
		r.data_min = r.min_mode.value
	}
	else if r.min_mode.constrained {
		// copy TLower/TUpper to Lower/Upper if set and time axis
		if r.min_mode.lower == 0 && r.min_mode.upper == 0 {
			// Constrained but un-initialized: Full autoscaling
			r.min_mode.lower = -math.max_f64
			r.min_mode.upper = math.max_f64
		}
		r.data_min = r.min_mode.upper
	}
	else {
		r.data_min = math.max_f64
	}
	// All the max stuff
	if r.max_mode.fixed {
		r.data_max = r.max_mode.value
	}
	else if r.max_mode.constrained {
		if r.max_mode.lower == 0 && r.max_mode.upper == 0 {
			// Constrained but un-initialized: Full autoscaling
			r.max_mode.lower = -math.max_f64
			r.max_mode.upper = math.max_f64
		}
		r.data_max = r.max_mode.upper
	}
	else {
		r.data_max = -math.max_f64
	}
	// fmt.Printf("At end of init: data_min / data_max  =   %g / %g\n", r.data_min, r.data_max)
}
// Update data_min and data_max according to the RangeModes.
fn (r mut Range) autoscale(x f64) {
	if x < r.data_min && !r.min_mode.fixed {
		if !r.min_mode.constrained {
			// full autoscaling
			r.data_min = x
		}
		else {
			r.data_min = math.min(math.max(x, r.min_mode.lower), r.data_min)
		}
	}
	if x > r.data_max && !r.max_mode.fixed {
		if !r.max_mode.constrained {
			// full autoscaling
			r.data_max = x
		}
		else {
			r.data_max = math.max(math.min(x, r.max_mode.upper), r.data_max)
		}
	}
}

pub const (
	Units = [' y', ' z', ' a', ' f', ' p', ' n', ' u', 'm', ' k', ' M', ' G', ' T', ' P', ' E', ' Z', ' Y']
)

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

fn almost_equal(a, b, d f64) bool {
	return math.abs(a - b) < d
}

// apply_range_mode returns val constrained by mode. val is considered the upper end of an range/axis
// if upper is true. To allow proper rounding to tic (depending on desired RangeMode)
// the ticDelta has to be provided. Logaritmic axis are selected by log = true and ticDelta
// is ignored: Tics are of the form 1*10^n.
fn apply_range_mode(mode RangeMode, mval, tic_delta f64, upper, log bool) f64 {
	mut val := mval
	if mode.fixed {
		return mode.value
	}
	if mode.constrained {
		if val < mode.lower {
			val = mode.lower
		}
		else if val > mode.upper {
			val = mode.upper
		}
	}
	match (mode.expand) {
		ExpandToTic, ExpandNextTic {
			mut v := f64(0)
			if upper {
				if log {
					v = math.pow(10, int(math.ceil(math.log10(val))))
				}
				else {
					v = math.ceil(val / tic_delta) * tic_delta
				}
			}
			else {
				if log {
					v = math.pow(10, int(math.floor(math.log10(val))))
				}
				else {
					v = math.floor(val / tic_delta) * tic_delta
				}
			}
			if mode.expand == ExpandNextTic {
				if upper {
					if log {
						if val / v < 2 {
							// TODO(vodo) use ExpandABitFraction
							v *= tic_delta
						}
					}
					else {
						if almost_equal(v, val, tic_delta / 15) {
							v += tic_delta
						}
					}
				}
				else {
					if log {
						if v / val > 7 {
							// TODO(vodo) use ExpandABitFraction
							v /= tic_delta
						}
					}
					else {
						if almost_equal(v, val, tic_delta / 15) {
							v -= tic_delta
						}
					}
				}
			}
			val = v
		}
		ExpandABit {
			if upper {
				if log {
					val *= math.pow(10, ExpandABitFraction)
				}
				else {
					val += tic_delta * ExpandABitFraction
				}
			}
			else {
				if log {
					val /= math.pow(10, ExpandABitFraction)
				}
				else {
					val -= tic_delta * ExpandABitFraction
				}
			}
		}
		else {}
	}
	return val
}

// Determine appropriate tic delta for normal (non dat/time) axis from desired delta and minimal delta.
fn (r Range) f_delta(mdelta, mindelta f64) f64 {
	mut delta := mdelta
	if r.log {
		return 10
	}
	// Set up nice tic delta of the form 1,2,5 * 10^n
	// TODO: deltas of 25 and 250 would be suitable too...
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
		// recalculate tic delta
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
	return delta
}

// Set up normal (=non date/time axis)
fn (r mut Range) f_setup(desired_numticks, max_numticks int, mdelta, mindelta f64) {
	mut delta := mdelta
	if r.tic_setting.delta != 0 {
		delta = r.tic_setting.delta
		r.tic_setting.user_delta = true
	}
	else {
		delta = r.f_delta(delta, mindelta)
		r.tic_setting.user_delta = false
	}
	r.min = apply_range_mode(r.min_mode, r.data_min, delta, false, r.log)
	r.max = apply_range_mode(r.max_mode, r.data_max, delta, true, r.log)
	r.tic_setting.delta = delta
	formater := format_float
	if r.log {
		mut x := math.pow(10, int(math.ceil(math.log10(r.min))))
		last := math.pow(10, int(math.floor(math.log10(r.max))))
		r.tics = [].repeat(max_numticks)
		for ; x <= last; x = x * delta {
			t := Tic{
				pos: x
				label_pos: x
				label: formater(x)
			}
			r.tics << t
		}
	}
	else {
		if r.category.len > 0 {
			r.tics = [].repeat(r.category.len)
			for i, c in r.category {
				x := f64(i)
				if x < r.min {
					continue
				}
				if x > r.max {
					break
				}
				r.tics[i].pos = math.nan() // no tic
				r.tics[i].label_pos = x
				r.tics[i].label = c
			}
		}
		else {
			// normal numeric axis
			first := delta * math.ceil(r.min / delta)
			num := int(-first / delta + math.floor(r.max / delta) + 1.5)
			// Set up tics
			r.tics = [].repeat(num)
			mut i := 0
			mut x := first
			for i < num {
				r.tics[i].pos = x
				r.tics[i].label_pos = x
				r.tics[i].label = formater(x)
				i++
				x += delta
			}
		}
	}
}

fn log_norm(x f64, mn f64, mx f64) f64 {
	return math.log10(x / mn) / math.log10(mx / mn)
}

fn log_inv_norm(x f64, mn f64, mx f64) f64 {
	return (mx - mn) * x + mn
}

fn reg_norm(x f64, mn f64, mx f64) f64 {
	return (x - mn) / (mx - mn)
}

fn reg_inv_norm(x, mn, mx f64) f64 {
	return (mx - mn) * x + mn
}

fn d2s_norevert(x f64, width, offset int, mn, mx f64, op fn(f64, f64, f64)f64) int {
	return int(f64(width) * op(x, mn, mx)) + offset
}

fn s2d_norevert(x f64, width, offset int, mn, mx f64, op fn(f64, f64, f64)f64) f64 {
	return op((x - offset) / f64(width), mn, mx)
}

fn d2s_revert(x f64, width, offset int, mn, mx f64, op fn(f64, f64, f64)f64) int {
	return width - int(f64(width) * op(x, mn, mx)) + offset
}

fn s2d_revert(x f64, width, offset int, mn, mx f64, op fn(f64, f64, f64)f64) f64 {
	return op((-x + offset + width) / f64(width), mn, mx)
}

// setup several fields of the Range r according to RangeModes and TicSettings.
// data_min and data_max of r must be present and should indicate lowest and highest
// value present in the data set. The following fields of r are filled:
// (T)Min and (T)Max    lower and upper limit of axis, (T)-version for date/time axis
// Tics                 slice of tics to draw
// TicSetting.(T)Delta  actual tic delta
// Norm and InvNorm     mapping of [lower,upper]_data --> [0:1] and inverse
// Data2Screen          mapping of data to screen coordinates
// Screen2Data          inverse of Data2Screen
// The parameters desired_numticks and max_numticks are what the say.
// sWidth and sOffset are screen-width and -offset and are used to set up the
// Data-Screen conversion fntions. If revert is true, than screen coordinates
// are assumed to be the other way around than mathematical coordinates.
//
// TODO(vodo) seperate screen stuff into own method.
fn (r mut Range) setup(mdesired_numticks, mmax_numticks, s_width, s_offset int, revert bool) {
	r.width = s_width
	r.offset = s_offset
	mut desired_numticks := mdesired_numticks
	mut max_numticks := mmax_numticks
	// Sanitize input
	if desired_numticks <= 1 {
		desired_numticks = 2
	}
	if max_numticks < desired_numticks {
		max_numticks = desired_numticks
	}
	if r.data_max == r.data_min {
		r.data_max = r.data_min + 1
	}
	delta := (r.data_max - r.data_min) / f64(desired_numticks - 1)
	mindelta := (r.data_max - r.data_min) / f64(max_numticks - 1)
	r.f_setup(desired_numticks, max_numticks, delta, mindelta)
	if r.log {
		r.norm = log_norm
		r.inv_norm = log_inv_norm
	}
	else {
		r.norm = reg_norm
		r.inv_norm = reg_inv_norm
	}
	if !revert {
		r.data_2_screen = d2s_norevert
		r.screen_2_data = s2d_norevert
	}
	else {
		r.data_2_screen = d2s_norevert
		r.screen_2_data = s2d_revert
	}
}

// LayoutData encapsulates the layout of the graph area in the whole drawing area.
struct LayoutData {
pub mut:
	width     int // width and height of graph area
	height    int
	left      int // left and top margin
	top       int
	keyx      int // x and y coordiante of key
	keyy      int
	num_xtics int // suggested numer of tics for both axis
	num_ytics int
}

// Layout graph data area on screen and place key.
fn layout(g Plotter, title, xlabel, ylabel string, hidextics, hideytics bool, key Key) LayoutData {
	mut ld := LayoutData{}
	fw,fh,_ := g.font_metrics(Font{})
	w,h := g.dimensions()
	// if key.pos == '' {
	// key.pos = 'itr'
	// }
	mut width := w - int(f32(6) * fw)
	mut leftm := int(f32(2) * fw)
	mut height := h - 2 * fh
	mut topm := fh
	mut xlabsep := fh
	mut ylabsep := int(f32(3) * fw)
	if title != '' {
		topm += (5 * fh) / 2
		height -= (5 * fh) / 2
	}
	if xlabel != '' {
		height -= (3 * fh) / 2
	}
	if !hidextics {
		height -= (3 * fh) / 2
		xlabsep += (3 * fh) / 2
	}
	if ylabel != '' {
		leftm += 2 * fh
		width -= 2 * fh
	}
	if !hideytics {
		leftm += int(f32(6) * fw)
		width -= int(f32(6) * fw)
		ylabsep += int(6.0 * fw)
	}
	// if !key.hide && key.place().len > 0 {
	// m := key.place()
	// kw,kh,_,_ := key.layout(g, m, Font{}) // TODO: use real font
	// sepx := int(fw) + fh
	// sepy := int(fw) + fh
	// match (key.pos[..2]) {
	// 'ol' {
	// width = width - kw - sepx
	// leftm = leftm + kw
	// ld.keyx = sepx / 2
	// }
	// 'or' {
	// width = width - kw - sepx
	// ld.keyx = w - kw - sepx / 2
	// }
	// 'ot' {
	// topm = topm + kh
	// ld.keyy = sepy / 2
	// if title != '' {
	// ld.keyy += 2 * fh
	// }
	// }
	// 'ob' {
	// height = height - kh - sepy
	// ld.keyy = h - kh - sepy / 2
	// }
	// 'it' {
	// ld.keyy = topm + sepy
	// }
	// 'ic' {
	// ld.keyy = topm + (height - kh) / 2
	// }
	// 'ib' {
	// ld.keyy = topm + height - kh - sepy
	// }
	// else {}
	// }
	// match (key.pos[..2]) {
	// 'ol', 'or' {
	// match (key.pos[2]) {
	// `t` {
	// ld.keyy = topm
	// }
	// `c` {
	// ld.keyy = topm + (height - kh) / 2
	// }
	// `b` {
	// ld.keyy = topm + height - kh
	// }
	// else {}
	// }
	// }
	// 'ot', 'ob' {
	// match (key.pos[2]) {
	// `l` {
	// ld.keyx = leftm
	// }
	// `c` {
	// ld.keyx = leftm + (width - kw) / 2
	// }
	// `r` {
	// ld.keyx = w - kw - sepx
	// }
	// else {}
	// }
	// }
	// else {}
	// }
	// if key.pos[0] == `i` {
	// match (key.pos[2]) {
	// `l` {
	// ld.keyx = leftm + sepx
	// }
	// `c` {
	// ld.keyx = leftm + (width - kw) / 2
	// }
	// `r` {
	// ld.keyx = leftm + width - kw - sepx
	// }
	// else {}
	// }
	// }
	// }
	// fmt.Printf("width=%d, height=%d, leftm=%d, topm=%d  (fw=%d)\n", width, height, leftm, topm, int(fw))
	// Number of tics
	if width / int(fw) <= 20 {
		ld.num_xtics = 2
	}
	else {
		ld.num_xtics = width / int(10.0 * fw)
		if ld.num_xtics > 25 {
			ld.num_ytics = 25
		}
	}
	ld.num_ytics = height / (4 * fh)
	if ld.num_ytics > 20 {
		ld.num_ytics = 20
	}
	ld.width = width
	ld.height = height
	ld.left = leftm
	ld.top = topm
	return ld
}
