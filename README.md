> vnum development has been suspended until 0.2.  There are too many missing features regarding generics and interfaces that further work just doesn't make any sense for now, and would need to be re-written later anyways.  If you would like to become a member of the core team once 0.2 hits, contact me.

![vnum logo](https://raw.githubusercontent.com/vlang-num/vnum/master/static/logo.png)

`vnum` is the core shard needed for scientific computing with V.  It is looking for core developer team members to continue working on the library.  If you are interested, contact Chris.

It provides:

- An n-dimensional `NdArray` data structure
- sophisticated reduction, elementwise, and accumulation operations
- data structures that can easily be passed to C libraries
- powerful linear algebra routines backed by LAPACK and BLAS.

## Installation

Using [vpm](https://vpm.best/)

```sh
$ v install christopherzimmerman.num
$ cp -a ~/.vmodules/christopherzimmerman/vnum/ ~/.vmodules/
```

`vnum` requires LAPACK and OPENBLAS to be installed on linux, and the Accelerate framework on darwin.  Please review your OS's installation instructions to install these libraries.  If you wish you to use `vnum` without these, the `num` module will still function as normal.

## Basic Usage

```sh
>>> import vnum.num
>>> num.seq(30)
[ 0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 14, 15, 16, 17,
 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29]
```

`vnum` provides vectorized operations on ndarrays.

```sh
>>> a := num.seq(12).reshape([3, 2, 2])
>>> num.axis(1).sum()
[[ 2,  4],
 [10, 12],
 [18, 20]]
```

Use the `vnum.linalg` module for powerful `BLAS` backed routines.

```sh
>>> import vnum.num
>>> import vnum.la
>>> a := num.seq(60).reshape([3, 4, 5])
>>> b := num.seq(24).reshape([4, 3, 2])
>>> res := la.tensordot(a, b, [1, 0], [0, 1])
>>> res
[[4400, 4730],
 [4532, 4874],
 [4664, 5018],
 [4796, 5162],
 [4928, 5306]]
```

Or have some fun and make some basic plots! (VERY WIP)

```v
xs := num.linspace(-2.0 * math.pi, 2.0 * math.pi, 100)
ys := num.tan(xs)
mut chart := plot.line("Tan(X)")
chart.add_data("tan(X)", xs, ys)
mut svg := plot.new_svg(480, 320)
chart.draw(mut svg)
svg.save_svg('test.svg')
```

![basic plot](https://raw.githubusercontent.com/vlang-num/vnum/master/static/plot.png)

## License

[MIT](LICENSE)


## Core Team

- [Chris Zimmerman](https://github.com/christopherzimmerman)

Contributing
------------
`vnum` requires help in many different ways to continue to grow as a module.
Contributions such as high level documentation and code quality checks are needed just
as much as API enhancements.  If you are considering larger scale contributions
that extend beyond minor enhancements and bug fixes, contact Chris Zimmerman
in order to be added to the organization to gain access to review and merge
permissions.
