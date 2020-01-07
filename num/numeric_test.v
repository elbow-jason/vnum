import vnum.num
import vnum.ndarray as nd

fn test_seq() {
	expected := nd.from_int_1d([0, 1, 2, 3, 4])
	result := num.seq(5)
	assert (nd.allclose(expected, result))
}

fn test_seq_between() {
	expected := nd.from_int_1d([3, 4, 5, 6, 7, 8])
	result := num.seq_between(3, 9)
	assert (nd.allclose(expected, result))
}

fn test_linspace() {
	expected := num.seq(11)
	result := num.linspace(0, 5, 11)
	assert (nd.allclose(expected.scalar(2).divide(), result))
}

fn test_logspace() {
	expected := nd.from_f32_1d([1.0, 1.77827941, 3.16227766, 5.62341325, 10.])
	result := num.logspace(0, 1, 5)
	assert (nd.allclose(expected, result))
}
