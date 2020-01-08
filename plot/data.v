module plot

import math
// Value is the interface for any type of data representable by a real. // Its standard implementation here is Real (f64).
interface Valuer {
	xval()f64
}

struct Real {
	value f64
}

pub fn (r Real) xval() f64 {
	return r.value
}

// Xyvalue is the interface for any type of data which is point-like and has // a x- and y-coordinate. Its standard implementation here is Point.
interface Xyvaluer {
	xval()f64
	yval()f64
}

// Point is a point in two dimensions (x,y) implementing Xyvalue.
struct Point {
	x f64
	y f64
}

fn (p Point) xval() f64 {
	return p.x
}

fn (p Point) yval() f64 {
	return p.y
}

fn (p Point) xerr() (f64,f64) {
	return math.nan(),math.nan()
}

fn (p Point) yerr() (f64,f64) {
	return math.nan(),math.nan()
}

// XyerrValue is the interface for any type of data which is point-like (x,y) and // has some measurement error.
interface XyerrValuer {
	xval()f64
	yval()f64
	xerr()(f64,f64) // X-range [min,max], error intervall. Use NaN to indicate "no error".
	yerr()(f64,f64) // Y-range error interval (like xerr).
}
// EPoint represents a point in two dimensions (X,Y) with possible error ranges // in both dimensions. To faciliate common symetric errors, OffX/Y defaults to 0 and // only delta_x/Y needs to be set up.
struct EPoint {
	x       f64
	y       f64
	delta_x f64 // Full range of x and y error, NaN for no errorbar.
	delta_y f64
	off_x   f64 // Offset of error range (must be < Delta)
	off_y   f64
}

fn (p EPoint) xval() f64 {
	return p.x
}

fn (p EPoint) yval() f64 {
	return p.y
}

fn (p EPoint) xerr() (f64,f64) {
	xl,_,xh,_ := p.bounding_box()
	return xl,xh
}

fn (p EPoint) yerr() (f64,f64) {
	_,yl,_,yh := p.bounding_box()
	return yl,yh
}

fn (p EPoint) bounding_box() (f64,f64,f64,f64) {
	// bounding box
	mut xl := p.x
	mut xh := p.x
	mut yl := p.y
	mut yh := p.y
	if !math.is_nan(p.delta_x) {
		xl -= p.delta_x / 2 - p.off_x
		xh += p.delta_x / 2 + p.off_x
	}
	if !math.is_nan(p.delta_y) {
		yl -= p.delta_y / 2 - p.off_y
		yh += p.delta_y / 2 + p.off_y
	}
	return xl,xh,yl,yh
}

// Categoryvalue is the interface for any type of data which is a category-real-pair.
interface CategoryValuer {
	category()string
	value   ()f64
	flagged ()bool
}

// CatValue is the standard implementation for Categoryvalue.
struct CatValue {
	cat  string
	val  f64
	flag bool
}

fn (c CatValue) category() string {
	return c.cat
}

fn (c CatValue) value() f64 {
	return c.val
}

fn (c CatValue) flagged() bool {
	return c.flag
}

// Box represents a box in an boxplot.
struct Box {
	x        f64 // x-position of the box
	avg      f64 // "average" value (uncommon in std. box plots, but sometimes useful)
	q1       f64 // lower quartil, median and upper quartil
	med      f64
	q3       f64
	low      f64 // low and hig end of whiskers (normaly last point in the 1.5*IQR range of Q1/3)
	high     f64
	outliers []f64 // list of y-values of outliers
}

fn (p Box) xval() f64 {
	return p.x
}

fn (p Box) yval() f64 {
	return p.med
}

fn (p Box) xerr() f64 {
	return p.med - p.q1
}

fn (p Box) yerr() f64 {
	return p.q3 - p.med
}
