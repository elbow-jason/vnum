module basenew

import strings
import vnum.internal

struct ArrayFlags {
pub mut:
	contiguous bool
	fortran bool
	owndata bool
	write bool
}

fn default_flags(order string) ArrayFlags {
	mut m := ArrayFlags{
		contiguous: false
		fortran: false
		owndata: true
		write: true
	}
	if (order == 'F') {
		m.fortran = true
	}
	else if (order == 'C') {
		m.contiguous = true
	}
	return m
}

pub fn (f ArrayFlags) str() string {
	mut io := strings.new_builder(1000)
	io.write('C_CONTIGUOUS: ')
	io.write(f.contiguous.str())
	io.write('\nF_CONTIGUOUS: ')
	io.write(f.fortran.str())
	io.write('\nOWNDATA: ')
	io.write(f.owndata.str())
	io.write('\nWRITE: ')
	io.write(f.write.str())
	return io.str()
}

fn all_flags() ArrayFlags {
	m := ArrayFlags{
		contiguous: true
		fortran: true
		owndata: true
		write: true
	}
	return m
}

pub fn no_flags() ArrayFlags {
	m := ArrayFlags{
		contiguous: false
		fortran: false
		owndata: false
		write: false
	}
	return m
}

fn dup_flags(f ArrayFlags) ArrayFlags {
	ret := ArrayFlags{
		contiguous: f.contiguous
		fortran: f.fortran
		owndata: f.owndata
		write: f.write
	}
	return ret
}

pub fn update_flags(shape []int, strides []int, ndims int, flags mut ArrayFlags, mask ArrayFlags) {
	if (mask.fortran && flags.fortran) {
		if internal.is_fortran_contiguous(shape, strides, ndims) {
			flags.fortran = true
			if ndims > 1 {
				flags.contiguous = false
			}
		}
		else {
			flags.fortran = false
		}
	}
	if (mask.contiguous && flags.contiguous) {
		if internal.is_contiguous(shape, strides, ndims) {
			flags.contiguous = true
			if ndims > 1 {
				flags.fortran = false
			}
		}
		else {
			flags.contiguous = false
		}
	}	
}
