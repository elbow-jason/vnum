module ml

import rand
import time

pub fn rand_between(min f64, max f64) f64 {
	scale := f64(C.rand()) / f64(C.RAND_MAX)
	return min + scale * (max - min)
}

pub fn rand_id() string {
	p1 := C.rand()
	p2 := C.rand()
	return '$p1-$p2'
}

fn init() {
	rand.seed(time.now().unix)
}
