
import num

fn main() {
	t := num.seq(12).reshape([3, 2, 2]).transpose([2, 0, 1])
	a := num.min_axis(t, 1)
	println(a)
}