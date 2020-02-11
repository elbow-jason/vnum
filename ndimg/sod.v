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

fn C.sod_img_load_from_file(z_file byteptr, nchannels int) C.sod_img


fn C.sod_img_save_as_png(input C.sod_img, z_path byteptr) int


fn C.sod_binarize_image(input C.sod_img, reverse int) sod_img


pub fn (img C.sod_img) str() string {
	return 'Image($img.h, $img.w, $img.c)'
}

pub fn (img C.sod_img) to_array() num.NdArray {
	ret := num.empty([img.h, img.w, img.c])
	mut i := 0
	for iter := ret.iter(); !iter.done; iter.next() {
		*iter.ptr = img.data[i]
		i++
	}
	return ret
}

pub fn from_array(arr num.NdArray) C.sod_img {
	dup := arr.copy('C').buffer()
	mut img := C.sod_img{}
	img.h = arr.shape[0]
	img.w = arr.shape[1]
	img.c = arr.shape[2]
	img.data = dup
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
