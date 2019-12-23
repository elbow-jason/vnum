import tensor

fn main() {
	t := tensor.from_shape([3, 3, 3])
	v := t.diag_view()
	println(v)
}