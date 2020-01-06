# vnum

`vnum` is the core shard needed for scientific computing with V.

It provides:

- An n-dimensional `Tensor` data structure
- sophisticated reduction, elementwise, and accumulation operations
- data structures that can easily be passed to C libraries
- powerful linear algebra routines backed by LAPACK and BLAS.

## Installation

Using [vpm](https://vpm.best/) (symlink must be created).

```sh
$ v install christopherzimmerman.num
$ ln -s path/to/.vmodules/christopherzimmerman/vnum vnum
```

`vnum` requires LAPACK and OPENBLAS to be installed on linux, and the Accelerate framework on darwin.  Please review your OS's installation instructions to install these libraries.  If you wish you to use `vnum` without these, the `num` module will still function as normal.

## Basic Usage

```sh
>>> import vnum.num
>>> num.seq(30)
[ 0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 14, 15, 16, 17,
 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29]
```

`vnum` provides vectorized operations on tensors.

```sh
>>> a := num.seq(12).reshape([3, 2, 2])
>>> num.sum_axis(a, 1)
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
