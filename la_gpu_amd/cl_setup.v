module la_gpu_amd

#flag -lclBLAS -lOpenCL
#include "clBLAS.h"

enum ClDeviceType {
	default_device = 1
	cpu = 2
	gpu = 4
}

enum ClMemFlags {
	read_write = 1
	write_only = 2
	read_only = 4
	copy_host_ptr = 32
}

enum ClBlasOrder {
	row_major = 0
	col_major = 1
}

enum ClBlasTranspose {
	no_trans = 0
	trans = 1
	conj_trans = 1
}

struct C.cl_platform_id
struct C.cl_device_info
struct C.cl_context_properties
struct C.cl_context
struct C.cl_command_queue
struct C.cl_mem
struct C.cl_event

struct ClInfo {
	context &C.cl_context
	queue   &C.cl_command_queue
}


fn C.clGetPlatformIDs(num_entries u32, platform_id C.cl_platform_id, num_platforms &u32) int
fn C.clGetDeviceIDs(platform C.cl_platform_id, dtype ClDeviceType, num_entries u32, device_id &C.cl_device_info, num_devices &u32) int
fn C.clCreateContext(properties &C.cl_context_properties, num_devices u32, devices &C.cl_device_info, pfn voidptr, user_data voidptr, err &int) C.cl_context
fn C.clCreateCommandQueue(context C.cl_context, device C.cl_device_info, properties int, err &int) C.cl_command_queue
fn C.clCreateBuffer(context C.cl_context, flags ClMemFlags, size u64, host voidptr, err &int) C.cl_mem
fn C.clReleaseMemObject(obj C.cl_mem)
fn C.clWaitForEvents(num_events u32, event &C.cl_event)

fn C.clblasSetup() int
fn C.clblasTeardown() int
fn C.clblasDgemm(order ClBlasOrder, trans_a ClBlasTranspose, trans_b ClBlasTranspose, m u64, n u64, k u64, alpha f64, a C.cl_mem, offa u64, lda u64, b C.cl_mem, offb u64, ldb u64, beta f64, c C.cl_mem, offc u64, ldc u64, num_queues u32, queue &C.cl_command_queue, num_wait u32, waitlist voidptr, events &C.cl_event) int


fn get_platform() &C.cl_platform_id {
	platform_id := &C.cl_platform_id(0)
	num := u32(0)
	err := C.clGetPlatformIDs(1, &platform_id, &num)

	if err != 0 {
		panic("Unable to find platform")
	}	

	return platform_id
}


fn get_device(platform &C.cl_platform_id) &C.cl_device_info {
	device_id := &C.cl_device_info(0)
	num := u32(0)
	err := C.clGetDeviceIDs(platform, ClDeviceType.gpu, 1, &device_id, &num)

	if err != 0 {
		panic("Unable to find device")
	}	
	return device_id
}

fn get_context(device &C.cl_device_info, platform &C.cl_platform_id) &C.cl_context {
	a := &C.cl_context_properties(C.CL_CONTEXT_PLATFORM)
	platform_prop := &C.cl_context_properties(platform)
	toss := &C.cl_context_properties(0)
	err := 0
	mut props := []C.cl_context_properties
	props << a
	props << platform_prop
	props << toss

	ctx := C.clCreateContext(props.data, 1, &device, calloc(1), calloc(1), &err)

	if err != 0 {
		panic("Unable to create context")
	}

	return ctx
}

fn get_queue(context &C.cl_context, device &C.cl_device_info) &C.cl_command_queue {
	err := 0
	queue := C.clCreateCommandQueue(context, device, 0, &err)

	if err != 0 {
		panic("Unable to create command queue")
	}

	return queue
}

pub fn init_opencl() ClInfo {
	platform := get_platform()
	device := get_device(platform)
	context := get_context(device, platform)
	queue := get_queue(context, device)

	return ClInfo{
		context: context
		queue: queue
	}
}

