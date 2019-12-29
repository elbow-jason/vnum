module linalg

import base
import num

#flag -lopenblas -llapack
#include "cblas.h"
#include "lapacke.h"
fn C.cblas_ddot(n int, dx &f64, incx int, dy &f64, incy int) f64


fn C.cblas_dasum(n int, x &f64, incx int) f64


fn C.cblas_drnm2(n int, x &f64, incx int) f64


fn C.cblas_idamax(n int, x &f64, incx int) int


fn C.cblas_daxpy(n int, alpha f64, x &f64, incx int, y &f64, incy int)


fn C.cblas_dgemv(trans byte, m int, n int, alpha f64, a &f64, lda int, x &f64, incx int, beta f64, y &f64, incy int)


fn C.dpotrf_(uplo &byte, n &int, a &f64, lda &int, info &int)


fn C.dgetrf_(m &int, n &int, a &f64, lda &int, ipiv &int, info &int)


fn C.dgetri_(n &int, a &f64, lda &int, ipiv &int, work &f64, lwork &int, info &int)


fn C.dgeqrf_(m &int, n &int, a &f64, lda &int, tau &f64, work &f64, lwork &int, info &int)


fn C.dorgqr_(m &int, n &int, k &int, a &f64, lda &int, tau &f64, work &f64, lwork &int, info &int)


fn squash_warning_linalg() {
	base.allocate_tensor([1])
}

pub fn cholesky(t base.Tensor) base.Tensor {
	ret := t.copy('F')
	uplo := `L`
	info := 0
	C.dpotrf_(&uplo, &t.shape[0], ret.buffer, &t.shape[0], &info)
	if info != 0 {
		panic('dpotrf returned $info')
	}
	num.tril_inpl(ret)
	return ret
}

fn dgeqrf_work(m int, n int, buffer &f64, taubuff &f64) int {
	outwork := f64(0)
	info := 0
	lwork := -1
	C.dgeqrf_(&m, &n, buffer, &m, taubuff, &outwork, &lwork, &info)
	return int(outwork)
}

fn qr_setup(a base.Tensor, m int, n int, k int) base.Tensor {
	tau := num.empty([k])
	lwork := dgeqrf_work(m, n, a.buffer, tau.buffer)
	work := *f64(calloc(lwork * sizeof(f64)))
	info := 0
	C.dgeqrf_(&m, &n, a.buffer, &m, tau.buffer, &work, &lwork, &info)
	return tau
}

pub fn qr(t base.Tensor) []base.Tensor {
	m := t.shape[0]
	n := t.shape[1]
	mut k := m
	if (m > n) {
		k = n
	}
	a := t.copy('F')
	tau := qr_setup(a, m, n, k)
	r := num.triu(a)
	lwork := n * n
	work := *f64(calloc(lwork * sizeof(f64)))
	info := 0
	C.dorgqr_(&m, &n, &k, a.buffer, &m, tau.buffer, work, &lwork, &info)
	return [a, r]
}

pub fn inv(t base.Tensor) base.Tensor {
	ret := t.copy('F')
	n := t.shape[0]
	ipiv := *int(calloc(n * sizeof(int)))
	mut info := 0
	C.dgetrf_(&n, &n, ret.buffer, &n, ipiv, &info)
	worksize := n * n
	work := *f64(calloc(worksize * sizeof(f64)))
	C.dgetri_(&n, ret.buffer, &n, ipiv, work, &worksize, &info)
	if info != 0 {
		panic('dgetri returned $info')
	}
	return ret
}
