
import num

fn main() {
	t := num.seq(3)
	println(t)
	println(num.broadcast_to(t, [3, 3, 3]))
}