module linalg

import base

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
