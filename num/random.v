module num

import rand
import time
import vnum.ndarray

fn rand_between(min f64, max f64) f64 {
	scale := f64(C.rand()) / f64(C.RAND_MAX)
	return min + scale * (max - min)
}

pub fn random(min f64, max f64, shape []int) ndarray.NdArray {
	ret := empty(shape)
	for i := ret.iter(); !i.done; i.next() {
		*i.ptr = rand_between(min, max)
	}
	return ret
}

pub fn random_seed(i int) {
	rand.seed(i)
}

fn init() {
	rand.seed(time.now().unix)
}

fn supress_random() {
	ndarray.allocate_ndarray([1], 'C')
}
