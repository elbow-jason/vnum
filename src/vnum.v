import tensor
import num

fn main() {
	t := tensor.seq(10000)
	v := tensor.reshape(t, [100, 100])
	r := num.array2string(v, ", ", "")
	println(r)
}