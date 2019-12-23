import tensor

fn main() {
	arr := tensor.from_shape([2, 2, 2])
	arr.set([0, 0, 1], 3.4)
	println(arr.add(arr))
}