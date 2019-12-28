import num
import num.linalg

fn main() {
	a := num.from_f32([0.0, 1.0, 1.0, 1.0, 1.0, 1.0, 2.0, 1.0], [4, 2])
	r := linalg.qr(a)
	println(r[0])
	println(r[1])
}