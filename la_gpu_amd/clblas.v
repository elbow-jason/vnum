module la_gpu_amd

import vnum.ndarray

pub fn array_to_buf(a ndarray.NdArray, info ClInfo, flags ClMemFlags) C.cl_mem {
	err := 0
	buf := C.clCreateBuffer(info.context, flags, a.size * sizeof(f64), a.buffer, &err)
	if err != 0 {
		panic("Could not create buffer")
	}
	return buf
}

pub fn enqueue_write(a ndarray.NdArray, buffer C.cl_mem, info ClInfo) {

}

pub fn matmul(a ndarray.NdArray, b ndarray.NdArray, info ClInfo) {
	dest := ndarray.allocate_ndarray([a.shape[0], b.shape[1]], 'C')

	buf_a := array_to_buf(a, info, .copy_host_ptr)
	buf_b := array_to_buf(b, info, .copy_host_ptr)
	buf_c := array_to_buf(dest, info, .copy_host_ptr)

	C.clblasSetup()

	event := &C.cl_event(0)
	C.clblasDgemm(ClBlasOrder.row_major, ClBlasTranspose.no_trans, ClBlasTranspose.no_trans, a.shape[0], b.shape[1], a.shape[1], 1.0, buf_a, 0, a.shape[1], buf_b, 0, b.shape[1], 1.0, buf_c, 0, dest.shape[1], 1, info.queue, 0, calloc(1), &event)
	C.clWaitForEvents(1, event)

	C.clReleaseMemObject(buf_a)
	C.clReleaseMemObject(buf_b)
	C.clReleaseMemObject(buf_c)

	C.clblasTeardown()
}