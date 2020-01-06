module la

import vnum.num
import vnum.ndarray
import math

pub fn block_diag(arrs []ndarray.NdArray) ndarray.NdArray {
	blocks := arrs.map(num.atleast_2d(it))
	bad := blocks.filter(it.ndims > 2)
	if bad.len > 0 {
		panic('Only two dimensional tensors are supported')
	}
	mut shapes := []int
	for block in blocks {
		shapes << block.shape
	}
	shapet := ndarray.from_int(shapes, [blocks.len, 2])
	mn := shapet.axis(0).sum()
	mut r := 0
	mut c := 0
	ret := num.zeros([int(mn.get([0])), int(mn.get([1]))])
	for block in blocks {
		rr := block.shape[0]
		cc := block.shape[1]
		ret.slice_hilo([r, c], [r + rr, c + cc]).assign(block)
		r += rr
		c += cc
	}
	return ret
}

// pub fn circulant(c ndarray.NdArray) ndarray.NdArray { // mc := c.ravel() // fp := num.flip(mc) // sp := num.flip(mc.get([1], [mc.size])) // c_ext := num.concatenate([fp, sp], 0) // l := c.shape[0] // n := c_ext.strides[0] // return num.as_strided(c_ext, [l, l], [-n, n]).copy('C') // }
// pub fn companion(a ndarray.NdArray) ndarray.NdArray { // if a.ndims != 1 { // panic("Incorrect shape for a, must be 1D") // } // if a.size < 2 { // panic("A must have at least two elements") // } // if a.get_at([0]) == 0.0 { // panic("The first coefficient must not be 0") // }
// fh := num.multiply_scalar(a.get([1], [a.size]), -1) // first_row := num.divide_scalar(fh, a.get_at([0]))
// n := a.size // c := num.zeros([n-1, n-1]) // c.set([0], [0], first_row)
// for i in 1 .. n - 1 { // j := i - 1 // c.set_at([i, j], 1.0) // } // return c // }
// pub fn fiedler(a ndarray.NdArray) ndarray.NdArray { // if a.ndims != 1 { // panic("Input must be a 1D array") // }
// if a.size == 1 { // return num.from_int([1], [1, 1]) // }
// return num.abs(num.subtract_outer(a, a)) // }
// pub fn hadamard(n int) ndarray.NdArray { // mut lg2 := f64(0.0) // if n >= 1 { // lg2 = math.log_n(n, 2) // } // mut h := num.from_int([1], [1, 1])
// for i := 0; i < int(lg2); i++ { // a := num.hstack([h, h]) // b := num.hstack([h, num.multiply_scalar(h, -1)]) // h = num.vstack([a, b]) // } // return h // }
// fn tolist(a ndarray.NdArray) []ndarray.NdArray { // mut ret := []ndarray.NdArray // for i in 0 .. a.shape[0] { // ret << a.get([i], [i]) // } // return ret // }
// pub fn kron(a ndarray.NdArray, b ndarray.NdArray) ndarray.NdArray { // mut ar := a // if !ar.flags["contiguous"] { // ar = ar.reshape(ar.shape) // } // mut br := b // if !br.flags["contiguous"] { // br = br.reshape(br.shape) // }
// mut o := num.multiply_outer(ar, br) // mut newshape := ar.shape // newshape << br.shape // o = o.reshape(newshape)
// c1 := num.concatenate(tolist(o), 1) // return num.concatenate(tolist(c1), 1)
// }
// fn supress_matrices() { // base.allocate_tensor([1]) // }
