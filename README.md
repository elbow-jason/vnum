Vnum is in active development, and contributions are always welcome!  Progress will not be that useful until generics are implemented in v.

```v
import num

fn main() {
	t := num.seq(12).reshape([3, 2, 2]).transpose([2, 0, 1])
	println(t)
	println(num.divide(t, t))
	a := num.sum_axis(t, 1)
	println(a)
}
```

```v
[[[ 0.000,  2.000],
  [ 4.000,  6.000],
  [ 8.000, 10.000]],

 [[ 1.000,  3.000],
  [ 5.000,  7.000],
  [ 9.000, 11.000]]]

[[[-nan, 1.000],
  [1.000, 1.000],
  [1.000, 1.000]],

 [[1.000, 1.000],
  [1.000, 1.000],
  [1.000, 1.000]]]
  
[[12.000, 18.000],
 [15.000, 21.000]]
```
