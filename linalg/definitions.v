module linalg

import base
import num

enum matrix_layout {
	row_major = 101
	col_major = 102
}

enum blas_transpose {
	no_trans = 111
	trans = 112
	conj_trans = 113
	con_no_trans = 114
}

struct Workspace {
	size int
	work &f64
}

fn C.cblas_ddot(n int, dx &f64, incx int, dy &f64, incy int) f64


fn C.cblas_dger(m int, n int, alpha f64, x &f64, incx int, y &f64, incy int, a &f64, lda int)


fn C.cblas_dnrm2(n int, x &f64, incx int) f64


fn C.cblas_idamax(n int, x &f64, incx int) int


fn C.cblas_daxpy(n int, alpha f64, x &f64, incx int, y &f64, incy int)


fn C.cblas_dgemv(trans byte, m int, n int, alpha f64, a &f64, lda int, x &f64, incx int, beta f64, y &f64, incy int)


fn C.dpotrf_(uplo &byte, n &int, a &f64, lda &int, info &int)


fn C.dgetrf_(m &int, n &int, a &f64, lda &int, ipiv &int, info &int)


fn C.dgetri_(n &int, a &f64, lda &int, ipiv &int, work &f64, lwork &int, info &int)


fn C.dgeqrf_(m &int, n &int, a &f64, lda &int, tau &f64, work &f64, lwork &int, info &int)


fn C.dorgqr_(m &int, n &int, k &int, a &f64, lda &int, tau &f64, work &f64, lwork &int, info &int)


fn C.dlange_(norm &byte, m &int, n &int, a &f64, lda &int, work &f64) f64


fn C.cblas_dgemm(transa blas_transpose, transb blas_transpose, m int, n int, k int, alpha f64, a &f64, lda int, b &f64, ldb int, c &f64, ldc int)


fn fortran_view_or_copy(t base.Tensor) base.Tensor {
	if t.flags['fortran'] {
		return t.dup_view()
	}
	else {
		return t.copy('F')
	}
}

fn fortran_copy(t base.Tensor) base.Tensor {
	return t.copy('F')
}

fn wrap_ddot(a base.Tensor, b base.Tensor) f64 {
	if a.ndims != 1 || b.ndims != 1 {
		panic('Tensors must be one dimensional')
	}
	else if a.size != b.size {
		panic('Tensors must have the same shape')
	}
	return C.cblas_ddot(a.size, a.buffer, a.strides[0], b.buffer, b.strides[0])
}

fn wrap_dger(a base.Tensor, b base.Tensor) base.Tensor {
	if a.ndims != 1 || b.ndims != 1 {
		panic('Tensors must be one dimensional')
	}
	out := base.allocate_tensor([a.size, b.size])
	C.cblas_dger(matrix_layout.row_major, a.size, b.size, 1.0, a.buffer, a.strides[0], b.buffer, b.strides[0], out.buffer, out.shape[1])
	return out
}

fn wrap_dnrm2(a base.Tensor) f64 {
	if a.ndims != 1 {
		panic('Tensor must be one dimensional')
	}
	return C.cblas_dnrm2(a.size, a.buffer, a.strides[0])
}

fn wrap_dlange(a base.Tensor, norm byte) f64 {
	if a.ndims != 2 {
		panic('Tensor must be two-dimensional')
	}
	m := fortran_view_or_copy(a)
	work := *f64(calloc(m.shape[0] * sizeof(f64)))
	return C.dlange_(&norm, &m.shape[0], &m.shape[1], m.buffer, &m.shape[0], work)
}

fn wrap_dpotrf(a base.Tensor, uplo byte) base.Tensor {
	if a.ndims != 2 {
		panic('Tensor must be two-dimensional')
	}
	ret := a.copy('F')
	info := 0
	C.dpotrf_(&uplo, &ret.shape[0], ret.buffer, &ret.shape[0], &info)
	if info > 0 {
		panic('Tensor is not positive definite')
	}
	if uplo == `U` {
		num.triu_inpl(ret)
	}
	else if uplo == `L` {
		num.tril_inpl(ret)
	}
	else {
		panic('Invalid option provided for UPLO')
	}
	return ret
}

fn wrap_det(a base.Tensor) f64 {
	ret := a.copy('F')
	m := a.shape[0]
	n := a.shape[1]
	ipiv := *int(calloc(sizeof(int) * n))
	info := 0
	C.dgetrf_(&m, &n, ret.buffer, &m, ipiv, &info)
	if info > 0 {
		panic('Singular matrix')
	}
	ldet := num.prod(ret.diag_view())
	mut detp := 1
	for i := 0; i < n; i++ {
		if (i + 1) != *(ipiv + i) {
			detp = -detp
		}
	}
	return ldet * detp
}

fn wrap_inv(a base.Tensor) base.Tensor {
	if a.ndims != 2 || a.shape[0] != a.shape[1] {
		panic('Matrix must be square')
	}
	ret := a.copy('F')
	n := a.shape[0]
	ipiv := *int(calloc(n * sizeof(int)))
	info := 0
	C.dgetrf_(&n, &n, ret.buffer, &n, ipiv, &info)
	if info > 0 {
		panic('Singular matrix')
	}
	lwork := n * n
	work := *f64(calloc(lwork * sizeof(f64)))
	C.dgetri_(&n, ret.buffer, &n, ipiv, work, &lwork, &info)
	return ret
}

fn wrap_matmul(a base.Tensor, b base.Tensor) base.Tensor {
	dest := num.empty([a.shape[0], b.shape[1]])
	ma := match (a.flags['contiguous']) {
		true{
			a
		}
		else {
			a.copy('C')}
	}
	mb := match (b.flags['contiguous']) {
		true{
			b
		}
		else {
			b.copy('C')}
	}
	C.cblas_dgemm(matrix_layout.row_major, blas_transpose.no_trans, .no_trans, ma.shape[0], mb.shape[1], ma.shape[1], 1.0, ma.buffer, ma.shape[1], mb.buffer, mb.shape[1], 1.0, dest.buffer, dest.shape[1])
	return dest
}
