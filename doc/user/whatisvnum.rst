*************
What is Vnum?
*************

Vnum is the core numerical computing shard for VLang.
It implements an N-Dimensional array for homogenous data, and provides
a large collection of routines for fast operations on these arrays.
These operations include mathematical, logical, sorting, selecting, basic linear
algebra, basic statistical operations, and more.

At the core of the vnum module is the `NdArray`.  This allows
for N-Dimensional representation of data.  There are key differences between
the `NdArray`, and a basic `V` array.

- NdArrays have a fixed size at creation.  Operations that reduce or re-size
  an NdArray copy data to create a new NdArray.

- Elements in an NdArray must be homogenous, so that they take up the same amount
  of space in memory.  NdArrays are navigated using strides, and strides must
  always be consistent to support fast operations.

- By taking advantage of low level C libraries, NdArrays
  support advanced mathematical operations on large numbers of data.  Since
  V is quite fast, and arrays do not have to worry about strides and
  contiguous memory, some operations on 1-dimensional data may be faster
  using standard library arrays.  However, the power of Vnum comes when
  data must be represented and manipulated in many dimensions.
