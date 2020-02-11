module ndimg

import vnum.num

#flag -I "./vnum/ext/"
#flag "./vnum/ext/sod.o"
#include "sod.h"
#include "sod_img_reader.h"
#include "sod_img_writer.h"
struct C.sod_img {
pub mut:
	h    int
	w    int
	c    int
	data &f64
}

fn C.sod_free_image(input C.sod_img)


fn C.sod_img_load_from_file(z_file byteptr, nchannels int) C.sod_img


fn C.sod_img_save_as_png(input C.sod_img, z_path byteptr) int


fn C.sod_binarize_image(input C.sod_img, reverse int) sod_img


fn C.sod_hilditch_thin_image(input sod_img) sod_img


fn C.sod_minutiae(input C.sod_img, ptotal &int, pep &int, pbp &int) C.sod_img


fn C.sod_canny_edge_image(input C.sod_img, reduce_noise int) C.sod_img


fn C.sod_sobel_image(input C.sod_img) C.sod_img


fn C.sod_grayscale_image(input C.sod_img) C.sod_img


pub fn (img C.sod_img) str() string {
	return 'Image($img.h, $img.w, $img.c)'
}

pub fn (img C.sod_img) free() {
	C.sod_free_image(img)
}

pub fn (img C.sod_img) to_array() num.NdArray {
	ret := num.empty([img.w, img.h, img.c])
	mut i := 0
	for iter := ret.iter(); !iter.done; iter.next() {
		*iter.ptr = img.data[i]
		i++
	}
	return ret
}

pub fn from_array(arr num.NdArray) C.sod_img {
	mut downcast := []f32
	for iter := arr.iter(); !iter.done; iter.next() {
		downcast << f32(*iter.ptr)
	}
	mut img := C.sod_img{}
	img.w = arr.shape[0]
	img.h = arr.shape[1]
	img.c = arr.shape[2]
	img.data = downcast.data
	return img
}

pub fn imread(fname string, nchannels int) C.sod_img {
	return C.sod_img_load_from_file(fname.str, nchannels)
}

pub fn (img C.sod_img) save_png(fname string) int {
	err := C.sod_img_save_as_png(img, fname.str)
	return err
}

pub fn (img C.sod_img) binarize(reverse int) C.sod_img {
	return C.sod_binarize_image(img, reverse)
}

pub fn (img C.sod_img) hilditch() C.sod_img {
	return C.sod_hilditch_thin_image(img)
}

pub fn (img C.sod_img) minutiae() C.sod_img {
	toss := 0
	return C.sod_minutiae(img, &toss, &toss, &toss)
}

pub fn (img C.sod_img) canny(reduce_noise int) C.sod_img {
	return C.sod_canny_edge_image(img, reduce_noise)
}

pub fn (img C.sod_img) sobel() C.sod_img {
	return C.sod_sobel_image(img)
}

pub fn (img C.sod_img) grayscale() C.sod_img {
	return C.sod_grayscale_image(img)
}
