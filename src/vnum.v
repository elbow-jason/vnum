import tensor

fn main() {
	t := tensor.seq(9).shape_into([3, 3])
	a := [t, t]
	tensor.concatenate(a, 1)
}