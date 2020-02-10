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
$ ln -sf ~/.vmodules/christopherzimmerman/vnum/ ~/.vmodules/vnum
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

## For Numpy Users

<table>
   <tr>
      <th>NumPy </th>
      <th>Vnum</th>
   </tr>
   <tr>
      <td>
         <code>
         np.array([[1.,2.,3.], [4.,5.,6.]])
         </code>
      </td>
      <td>
         <code>
         num.from_int([1, 2, 3, 4, 5, 6], [2, 3])
         </code>
      </td>
   </tr>
   <tr>
      <td>
         <code>
         np.arange(10)
         </code>
      </td>
      <td>
         <code>
         num.seq(10)
         </code>
      </td>
   </tr>
   <tr>
      <td>
         <code>
         np.linspace(0, 10, 11)
         </code>
      </td>
      <td>
         <code>
         num.linspace(0, 10, 11)
         </code>
      </td>
   </tr>
   <tr>
      <td>
         <code>
         np.ones((3, 4, 5))
         </code>
      </td>
      <td>
         <code>
         num.ones([3, 4, 5])
         </code>
      </td>
   </tr>
   <tr>
      <td>
         <code>
         np.zeros((3, 4, 5))
         </code>
      </td>
      <td>
         <code>
         num.zeros((3, 4, 5))
         </code>
      </td>
   </tr>
   <tr>
      <td>
         <code>
         np.zeros((3, 4, 5), order='F')
         </code>
      </td>
      <td>
         <code>
         num.zeros([3, 4, 5]).copy('F')
         </code>
      </td>
   </tr>
   <tr>
      <td>
         <code>
         np.full((3, 4), 7)
         </code>
      </td>
      <td>
         <code>
         num.full([3, 4], 7)
         </code>
      </td>
   </tr>
   <tr>
      <td>
         <code>
         a[-1]
         </code>
      </td>
      <td>
         <code>
         a.get([-1])
         </code>
      </td>
   </tr>
   <tr>
      <td>
         <code>
         a[1, 4]
         </code>
      </td>
      <td>
         <code>
         a.get([1, 4])
         </code>
      </td>
   </tr>
   <tr>
      <td>
         <code>
         a[1]
         </code>
      </td>
      <td>
         <code>
         a.slice([1])
         </code>
      </td>
   </tr>
   <tr>
      <td>
         <code>
         a[0:5]
         </code>
      </td>
      <td>
         <code>
         a.slice([0, 5])
         </code>
      </td>
   </tr>
   <tr>
      <td>
         <code>
         a[1:4:2]
         </code>
      </td>
      <td>
         <code>
         a.slice([1, 4, 2])
         </code>
      </td>
   </tr>
   <tr>
      <td>
         <code>
         a.T
         </code>
      </td>
      <td>
         <code>
         a.t()
         </code>
      </td>
   </tr>
   <tr>
      <td>
         <code>
         mat1.dot(mat2)
         </code>
      </td>
      <td>
         <code>
         la.matmul(mat2, mat2)
         </code>
      </td>
   </tr>
   <tr>
      <td>
         <code>
         np.sum(a, axis=1)
         </code>
      </td>
      <td>
         <code>
         num.sum_axis(1)
         </code>
      </td>
   </tr>
   <tr>
      <td>
         <code>
         np.diag(a)
         </code>
      </td>
      <td>
         <code>
         num.diag(a)
         </code>
      </td>
   </tr>
   <tr>
      <td>
         <code>
         a[:] = 3
         </code>
      </td>
      <td>
         <code>
         a.fill(3)
         </code>
      </td>
   </tr>
   <tr>
      <td>
         <code>
         a[:] = b
         </code>
      </td>
      <td>
         <code>
         a.assign(b)
         </code>
      </td>
   </tr>
   <tr>
      <td>
         <code>
         np.concatenate((a, b), axis=1)
         </code>
      </td>
      <td>
         <code>
         num.concatenate([a, b], 1)
         </code>
      </td>
   </tr>
</table>

## License

[BSD-3](LICENSE)


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
