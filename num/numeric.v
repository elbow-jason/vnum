module num

import vnum.ndarray
import math
// Return evenly spaced values within a given interval.
// Values are generated within the half-open interval [0, n)
// (in other words, the interval including 0 but excluding n).
pub fn seq(n int) ndarray.NdArray {
	ret := empty([n])
	mut ii := 0
	for iter := ret.iter(); !iter.done; iter.next() {
		*iter.ptr = ii
		ii++
	}
	return ret
}

// Return evenly spaced values within a given interval.
// Values are generated within the half-open interval [start, stop)
// (in other words, the interval including start but excluding stop).
pub fn seq_between(start int, end int) ndarray.NdArray {
	d := end - start
	ret := seq(d)
	return ret.scalar(start).add()
}

// Return evenly spaced numbers over a specified interval.
// Returns num evenly spaced samples, calculated over the interval
// [start, stop].
pub fn linspace(start f64, stop f64, num int) ndarray.NdArray {
	div := num - 1
	mut y := seq(num)
	delta := stop - start
	if num > 1 {
		step := delta / div
		if step == 0 {
			panic('Cannot have a step of 0')
		}
		y = y.scalar(step).multiply()
	}
	else {
		y = y.scalar(delta).multiply()
	}
	y = y.scalar(start).add()
	y.set([y.shape[0] - 1], stop)
	return y
}

// Return numbers spaced evenly on a log scale.
// In linear space, the sequence starts at base ** start
// (base to the power of start) and ends with base ** stop
pub fn logspace(start f64, stop f64, num int) ndarray.NdArray {
	return logspace_base(start, stop, num, 10.0)
}

// Return numbers spaced evenly on a log scale.
// In linear space, the sequence starts at base ** start
// (base to the power of start) and ends with base ** stop
pub fn logspace_base(start f64, stop f64, num int, base f64) ndarray.NdArray {
	return spow(base, linspace(start, stop, num))
}

// Return numbers spaced evenly on a log scale (a geometric progression).
// This is similar to logspace, but with endpoints specified directly.
// Each output sample is a constant multiple of the previous.
pub fn geomspace(start f64, stop f64, num int) ndarray.NdArray {
	if start == 0 || stop == 0 {
		panic('Geometric sequence cannot include 0')
	}
	mut out_sign := 1.0
	mut ustart := start
	mut ustop := stop
	if start < 0 && stop < 0 {
		ustart = -start
		ustop = -stop
		out_sign = -out_sign
	}
	log_start := math.log10(ustart)
	log_stop := math.log10(ustop)
	ls := logspace(log_start, log_stop, num)
	return ls.scalar(out_sign).multiply()
}

// Returns the sign of an input array.  0 for zero
// -1 for negative values, and 1 for positive values
pub fn sign(arr ndarray.NdArray) ndarray.NdArray {
	return arr.apply(sign_scalar)
}

// Returns the sign of an input scalar.  0 for zero
// -1 for negative values, and 1 for positive values
pub fn sign_scalar(value f64) f64 {
	if value == 0.0 {
		return 0.0
	}
	else if value > 0.0 {
		return 1.0
	}
	else {
		return -1.0
	}
}

fn supress_numeric() {
	ndarray.allocate_ndarray([1], 'F')
}
