module linalg

import vnum.base
import vnum.num

pub fn dot(a base.Tensor, b base.Tensor) f64 {
	return wrap_ddot(a, b)
}

pub fn outer(a base.Tensor, b base.Tensor) base.Tensor {
	return wrap_dger(a, b)
}

pub fn vector_norm(a base.Tensor) f64 {
	return wrap_dnrm2(a)
}

pub fn matrix_norm(a base.Tensor, norm byte) f64 {
	return wrap_dlange(a, norm)
}

pub fn cholesky(a base.Tensor, uplo byte) base.Tensor {
	return wrap_dpotrf(a, uplo)
}

pub fn det(a base.Tensor) f64 {
	return wrap_det(a)
}

pub fn inv(a base.Tensor) base.Tensor {
	return wrap_inv(a)
}

pub fn matmul(a base.Tensor, b base.Tensor) base.Tensor {
	return wrap_matmul(a, b)
}

pub fn eigh(a base.Tensor) []base.Tensor {
	return wrap_eigh(a)
}

pub fn eig(a base.Tensor) []base.Tensor {
	return wrap_eig(a)
}

pub fn eigvalsh(a base.Tensor) base.Tensor {
	return wrap_eigvalsh(a)
}

pub fn eigvals(a base.Tensor) base.Tensor {
	return wrap_eigvals(a)
}

pub fn solve(a base.Tensor, b base.Tensor) base.Tensor {
	return wrap_solve(a, b)
}

pub fn hessenberg(a base.Tensor) base.Tensor {
	return wrap_hessenberg(a)
}

pub fn tensordot(a base.Tensor, b base.Tensor, ax_a []int, ax_b []int) base.Tensor {
	as_ := a.shape
	nda := a.ndims
	bs := b.shape
	ndb := b.ndims
	mut equal := true
	mut axes_a := ax_a.clone()
	mut axes_b := ax_b.clone()
	if axes_a.len != axes_b.len {
		equal = false
	}
	else {
		for k in 0 .. axes_a.len {
			if as_[axes_a[k]] != bs[axes_b[k]] {
				equal = false
				break
			}
			if axes_a[k] < 0 {
				axes_a[k] += nda
			}
			if axes_b[k] < 0 {
				axes_b[k] += ndb
			}
		}
	}
	if !equal {
		panic('shape-mismatch for sum')
	}
	tmp := base.range(0, nda)
	notin := tmp.filter(!(it in axes_a))
	mut newaxes_a := notin.clone()
	newaxes_a << axes_a
	mut n2 := 1
	for axis in axes_a {
		n2 *= as_[axis]
	}
	firstdim := notin.map(as_[it])
	val := int(num.prod(num.from_int(firstdim, [firstdim.len])))
	newshape_a := [val, n2]
	tmpb := base.range(0, ndb)
	notinb := tmpb.filter(!(it in axes_b))
	mut newaxes_b := axes_b.clone()
	newaxes_b << notinb
	n2 = 1
	for axis in axes_b {
		n2 *= bs[axis]
	}
	firstdimb := notin.map(bs[it])
	valb := int(num.prod(num.from_int(firstdimb, [firstdimb.len])))
	newshape_b := [n2, valb]
	mut outshape := []int
	outshape << firstdim
	outshape << firstdimb
	at := a.transpose(newaxes_a).reshape(newshape_a)
	bt := b.transpose(newaxes_b).reshape(newshape_b)
	res := matmul(at, bt)
	return res.reshape(outshape)
}
