module linalg

import vnum.num
import vnum.base

pub fn circulant(c base.Tensor) base.Tensor {
	mc := c.ravel()
	fp := num.flip(mc)
	sp := num.flip(mc.get([1], [mc.size]))
	c_ext := num.concatenate([fp, sp], 0)
	l := c.shape[0]
	n := c_ext.strides[0]
	return num.as_strided(c_ext, [l, l], [-n, n]).copy('C')
}

pub fn companion(a base.Tensor) base.Tensor {
	if a.ndims != 1 {
		panic("Incorrect shape for a, must be 1D")
	}
	if a.size < 2 {
		panic("A must have at least two elements")
	}
	if a.get_at([0]) == 0.0 {
		panic("The first coefficient must not be 0")
	}

	fh := num.multiply_scalar(a.get([1], [a.size]), -1)
	first_row := num.divide_scalar(fh, a.get_at([0]))

	n := a.size
	c := num.zeros([n-1, n-1])
	c.set([0], [0], first_row)
	
	for i in 1 .. n - 1 {
		j := i - 1
		c.set_at([i, j], 1.0)
	}
	return c
}

fn supress_matrices() {
	base.allocate_tensor([1])
}