import vnum.ndarray as nd
import vnum.internal

fn test_num_yielded() {
	a := nd.from_int([1, 2, 3, 4, 5, 6], [3, 2])
	mut yielded := 0
	for iter := a.iter(); !iter.done; iter.next() {
		yielded++
	}
	assert (yielded == a.size)
}

fn test_num_yielded_with() {
	a := nd.from_int([1, 2, 3, 4, 5, 6], [3, 2])
	mut yielded := 0
	for iter := a.with(a); !iter.done; iter.next() {
		yielded++
	}
	assert (yielded == a.size)
}

fn test_iter_values_1d() {
	a := nd.from_int([1, 2, 3], [3])
	values := [f64(1.0), f64(2.0), f64(3.0)]
	mut i := 0
	for iter := a.iter(); !iter.done; iter.next() {
		assert (*iter.ptr == values[i])
		i++
	}
}

fn test_axis_iter_values() {
	a := nd.from_int([0, 1, 2, 3, 4, 5, 6, 7, 8], [3, 3])
	first := nd.from_int_1d([0, 1, 2])
	second := nd.from_int_1d([3, 4, 5])
	third := nd.from_int_1d([6, 7, 8])
	arrs := [first, second, third]
	mut iter := a.axis(0)
	mut i := 0
	for i < a.shape[0] {
		tmp := iter.next()
		println(tmp)
		println(arrs[i])
		assert (nd.allclose(arrs[i], tmp))
		i++
	}
}
