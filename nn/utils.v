module nn

import vnum.num
import math

fn normals(rows, cols int) num.NdArray {
	return num.random(0, 1, [rows, cols])
}

fn sigmoid(z f64) f64 {
	return f64(1) / (f64(1) + math.exp(-z))
}

fn sigmoid_prime(z f64) f64 {
	return sigmoid(z) * (f64(1) - sigmoid(z))
}

fn htan(z f64) f64 {
	return (math.exp(f64(2) * z) - 1) / (math.exp(f64(2) * z) + 1)
}

fn htan_prime(z f64) f64 {
	return f64(1) - (math.pow((math.exp(f64(2) * z) - 1) / (math.exp(f64(2) * z) + 1), 2))
}
