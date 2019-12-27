import tensor
import num

fn main() {
	t := tensor.seq(10000)
	v := t
	r := num.array2string(v, ", ", "")
	println(r)
}