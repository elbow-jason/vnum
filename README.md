Vnum is in active development, and contributions are always welcome!  Progress will not be that useful until generics are implemented in v.

```v
fn main() {
	t := from_shape([2, 2, 2])
	t.set([0, 1, 1], 2.0)
	t.set([1, 0, 0], 3.14)
	println(t)
}
```

```v
Tensor([[[0.000000, 0.000000],
         [0.000000, 2.000000]],

        [[3.140000, 0.000000],
         [0.000000, 0.000000]]]
```
