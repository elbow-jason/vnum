
import num

fn main() {
	t := num.seq(12).reshape([3, 2, 2]).transpose([2, 0, 1])
	println(t)
	println(num.divide(t, t))
	a := num.sum_axis(t, 1)
	println(a)
}