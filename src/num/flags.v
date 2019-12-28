module num
import strings

fn default_flags(order string) map[string]bool {
	mut m := {
		"contiguous": false
		"fortran": false
		"owndata": true
		"write": true
	}
	if (order == 'F') {
		m["fortran"] = true
	} else if (order == 'C') {
		m["contiguous"] = true
	}
	return m
}

pub fn (f map[string]bool) str() string {
	mut io := strings.new_builder(1000)
	io.write("C_CONTIGUOUS: ")
	io.write(f["contiguous"].str())
	io.write("\nF_CONTIGUOUS: ")
	io.write(f["fortran"].str())
	io.write("\nOWNDATA: ")
	io.write(f["owndata"].str())
	io.write("\nWRITE: ")
	io.write(f["write"].str())
	return io.str()
}

fn all_flags() map[string]bool {
	m := {
		"contiguous": true
		"fortran": true
		"owndata": true
		"write": true
	}
	return m
}

fn no_flags() map[string]bool {
	m := {
		"contiguous": false
		"fortran": false
		"owndata": false
		"write": true
	}
	return m
}

fn dup_flags(f map[string]bool) map[string]bool {
	mut ret := map[string]bool
	for i in ["contiguous", "fortran", "owndata", "write"] {
		ret[i] = f[i]
	}
	return ret
}