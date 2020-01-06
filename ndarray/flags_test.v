import vnum.ndarray as nd

fn test_dup_flags() {
	mut a := nd.all_flags()
	a.fortran = false
	b := nd.dup_flags(a)
	assert (a.owndata == b.owndata)
	assert (a.contiguous == b.contiguous)
	assert (a.fortran == b.fortran)
	assert (a.write == b.write)
}

fn test_update_flags_fortran() {
	mut a := nd.allocate_ndarray([3, 3], 'F')
	a.flags.fortran == false
	a.update_flags(nd.all_flags())
	assert (a.flags.fortran == true)
	assert (a.flags.contiguous == false)
}

fn test_update_flags_contiguous() {
	mut a := nd.allocate_ndarray([3, 3], 'C')
	a.flags.fortran == true
	a.update_flags(nd.all_flags())
	assert (a.flags.fortran == false)
	assert (a.flags.contiguous == true)
}
