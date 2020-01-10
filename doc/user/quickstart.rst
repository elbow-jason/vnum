===================
Quickstart tutorial
===================

Prerequisites
=============

Before reading this tutorial you should know V Lang. If you
would like to refresh your memory, take a look at the `V
introduction <https://vlang.io/docs/>`__.

The Basics
==========

Vnum's main object is the homogeneous multidimensional narray. It is a
table of elements (usually numbers), all of the same type, indexed by
integers. In Vnum dimensions are called *axes*.

For example, the coordinates of a point in 3D space ``[1, 2, 1]`` has
one axis. That axis has 3 elements in it, so we say it has a length
of 3. In the example pictured below, the ndarray has 2 axes. The first
axis has a length of 2, the second axis has a length of 3.

::

    [[0, 1, 2],
     [3, 4, 5]]


Vnum's ndarray struct is called ``NdArray``. The more important attributes of
a ``ndarray`` object are:

NdArray.ndims
    the number of axes (dimensions) of the ndarray.
NdArray.shape
    the dimensions of the ndarray. This is an Array of integers indicating
    the size of the ndarray in each dimension. For a matrix with *n* rows
    and *m* columns, ``shape`` will be ``[n, m]``. The length of the
    ``shape`` Array is therefore the number of axes, ``ndims``.
NdArray.size
    the total number of elements of the ndarray. This is equal to the
    product of the elements of ``shape``.
NdArray.buffer
    the buffer containing the actual elements of the array. Normally, we
    won't need to use this attribute because we will access the elements
    in an array using indexing facilities.

An example
----------

.. code-block:: v

    >>> t := num.seq(15).reshape([3, 5])
    >>> t
    [[ 0,  1,  2,  3,  4],
     [ 5,  6,  7,  8,  9],
     [10, 11, 12, 13, 14]]
    >>> t.shape
    [3, 5]
    >>> t.ndims
    2
    >>> t.size
    15


NdArray Creation
---------------

There are many ways to create NdArrays.

NdArrays can be created from standard Crystal arrays, using the class method:
``from_array``.

.. code-block:: v

    >>> arr := ndarray.from_int([1, 2, 3, 4, 5, 6], [2, 3])
    >>> arr
    [[1, 2, 3],
     [4, 5, 6]]


Often, the elements of an ndarray are originally unknown, but its size of known.  Hence,
Vnum offers many routines to create NdArrays with initial placeholder data.  These
minimize the number of NdArrays that need to grow to fit data, which is an
expensive operation.

The routine ``zeros`` creates an ndarray full of zeros.  The routine ``ones`` creates
an ndarray full of ones, and the function ``empty`` creates an array with an empty
allocated data buffer.

.. code-block:: v

    >>> println(num.zeros([3, 4]))
    [[0, 0, 0, 0],
     [0, 0, 0, 0],
     [0, 0, 0, 0]]
    >>> println(num.ones([2, 3, 4]))
    [[[1, 1, 1, 1],
     [1, 1, 1, 1],
     [1, 1, 1, 1]],

    [[1, 1, 1, 1],
     [1, 1, 1, 1],
     [1, 1, 1, 1]]]

To create sequences of numbers, Vnum provides functions similar to ranges that return
NdArrays instead of iterators.

.. code-block:: v

    >>> println(num.seq_between(10, 15))
    [10, 11, 12, 13, 14]


``linspace`` is routine that receives as an argument the number of desired elements between two
values.

.. code-block:: v

    >>> println(num.linspace(0, 2, 9))
    [   0, 0.25,  0.5, 0.75,    1, 1.25,  1.5, 1.75,    2]

Basic Operations
----------------

Arithmetic operations on NdArrays apply *elementwise*.  A new ndarray is created and filled
with the result.

.. code-block:: v

    >>> a1 := ndarray.from_int_1d([20, 30, 40, 50])
    >>> b1 := num.seq(4)
    >>> c := a1 - b1
    >>> c
    [20, 29, 38, 47]
    >>> println(num.pows(b1, f64(2.0)))
    [0, 1, 4, 9]
    >>> println(num.pows(b1, 2))
    [0, 1, 4, 9]
    >>> println(num.sin(a1))
    [ 0.912945, -0.988032,  0.745113, -0.262375]

Many statistical operations, such as the sum of an ndarray, or the minimum/maximum are implemented
directly as methods on the ndarray class.

.. code-block:: v

    >>> r := num.random(0, 1, [2, 3])
    >>> r
    [[ 0.216403,  0.881004,  0.250914],
     [0.0504559,   0.42504,  0.151933]]
    >>> a.iter().sum()
    15.000000
    >>> a.iter().min()
    0.151933
    >>> a.iter().max()
    0.881004

By default, these operations treat the ndarray as though it was a flattened version
of itself, returning a reduction on the entire ndarray.  However, by specifying
and ``axis`` parameter, you can apply an operation along a specified access of an ndarray.

.. code-block:: v

    >>> br := num.seq(12).reshape([3, 4])
    >>> br
    [[ 0,  1,  2,  3],
    [ 4,  5,  6,  7],
    [ 8,  9, 10, 11]]
    >>> br.axis(0).sum()
    [12, 15, 18, 21]
    >>> br.axis(1).minimum()
    [0, 4, 8]


Universal Functions
-------------------

Vnum provides familiar mathematical functions such as sin, cos, and exp.  These functions
operate elementwise on NdArrays, producing NdArrays as output.

    >>> a := num.seq(3)
    >>> a
    [0, 1, 2]
    >>> num.exp(a)
    [      1, 2.71828, 7.38906]
    >>> num.sqrt(a)
    [      0,       1, 1.41421]

Indexing, Slicing and Iterating
-------------------------------

**One-dimensional** NdArrays can be indexed, sliced and iterated over, very similar to
Crystal arrays.

.. code-block:: v

    >>> b := num.seq(10)
    >>> a.get([2])
    2.000000
    >>> a.slice([2, 5])
    [2, 3, 4]

**N-Dimensional** NdArrays can have a single index operation per axis. These indices are provided
as *args.

.. code-block:: v

    >>> a := num.seq(20).reshape([5, 4])
    >>> a
    [[ 0,  1,  2,  3],
     [ 4,  5,  6,  7],
     [ 8,  9, 10, 11],
     [12, 13, 14, 15],
     [16, 17, 18, 19]]
    >>> println(a.slice([0, 5], [1]))
    [ 1,  5,  9, 13, 17]
    >>> println(a.slice([]int, [1]))
    [ 1,  5,  9, 13, 17]
    >>> println(a.slice([1, 3], []))
    [[ 4,  5,  6,  7],
     [ 8,  9, 10, 11]]


Shape Manipulation
==================

Changing the shape of an ndarray
------------------------------

NdArrays have shapes defined by the number of elements along each axis.

.. code-block:: v

    >>> ar := num.random(0, 10, [3, 4])
    >>> println(ar.shape)
    [3, 4]
    >>> ar
    [[ 8.18468,  5.32759, 0.248512,  3.87761],
     [ 9.54492,  3.74844,  1.30248, 0.362413],
     [ 3.97763,  8.35798,  5.88077,  2.13291]]

The shape of a andarray can be changed with many routines.  Many methods return
a view of the original data, but do not change the origin ndarray.

.. code-block:: v

    >>> ar.ravel()
    [  2.6021,  6.77886,  3.06252,   4.3558,  7.18489, 0.915223,  4.58138,
    1.37091,  5.56711,  2.68335,  6.80612,  9.01151]
    >>> ar.reshape([6, 2])
    >>> println(ar.reshape([6, 2]))
    [[ 2.77477,  4.60744],
     [0.442733,  9.17142],
     [ 7.94581,  6.84151],
     [ 5.12616,  2.66994],
     [ 3.34875,  9.54148],
     [ 8.12602,  1.69212]]
    >>> println(ar.t())
    [[ 8.66651,  1.39074,  8.94975],
     [0.948504,  3.96881,  3.09888],
     [ 5.74682,  1.30439,  9.13915],
     [ 1.24638,  2.22516,  7.94207]]
    >>> println(ar.t().shape)
    [4, 3]


If a dimension is provided as -1 in an operation that reshapes the ndarray, the other dimensions
are calculated automatically.  Only a single dimension can be dynamically calculated.

.. code-block:: v

    >>> println(ar.reshape([3, 2, -1]))
    [[[  0.5637,  4.27407],
      [0.267578,  2.17197]],

    [[ 9.41788,  1.58302],
     [ 5.69251,   9.5946]],

    [[ 1.16419,   2.7269],
     [  8.0944, 0.194529]]]


Stacking together different NdArrays
-----------------------------------

Many NdArrays can be stacked together along an axis.  Shapes must be the same on
the off-axis dimensions of the NdArrays.

.. code-block:: v

    >>> a1 := num.random(0, 10, [2, 2])
    >>> b1 := num.random(0, 10, [2, 2])
    >>> a1
    [[8.13498, 1.10927],
     [5.02861,  1.8071]]
    >>> b1
    [[2.04858, 9.54664],
     [3.53256,  6.2523]]
    >>> println(num.vstack([a1, b1]))
    [[5.34553, 2.90882],
     [ 8.0248, 2.42008],
     [8.13823, 2.16565],
     [1.94479, 8.34849]]
    >>> println(num.hstack([a1, b1]))
    [[6.55104, 7.66096, 9.59723, 6.02242],
     [7.32896, 3.88884, 9.45543,  3.0551]]
    >>> println(num.column_stack([a1, b1]))
    [[ 2.71795,  2.35145, 0.977813,   9.9081],
     [ 6.66114,  5.31986,  6.93087,  2.66366]]

Copies and Views
================

When operating and manipulating NdArrays, data is sometimes copied into a new ndarray, and
sometimes an ndarray shares memory with another ndarray.  This can lead to confusing
behavior if a user is not aware of this fact.

No copy at all
--------------

Simple assignments make no copy of NdArrays or their data

.. code-block:: crystal

    a = B.arange(12).reshape([3, 4])
    b = a  # no copy of the NdArrays data is made


View or Shallow Copy
--------------------

Different NdArrays can share the same data, however some NdArrays will point to subsets
of another NdArrays data, and therefore the objects will not be the same.

.. code-block:: crystal

    c = a.dup_view()

    puts a.buffer == c.buffer
    puts c.flags.own_data?

    c = c.reshape([2, 6])
    c[[0, 4]] = 12345
    puts a

.. code-block:: crystal

    true
    false
    ndarray([[    0,     1,     2,     3],
            [12345,     5,     6,     7],
            [    8,     9,    10,    11]])

Slicing NdArrays returns a view

.. code-block:: crystal

    s = a[..., 1...3]
    s[...] = 10

    puts a

.. code-block:: crystal

    ndarray([[    0,    10,    10,     3],
            [12345,    10,    10,     7],
            [    8,    10,    10,    11]])

Deep copies
-----------

The ``dup`` method makes a copy of an ndarray and its data

.. code-block:: crystal

    d = a.dup
    puts d.buffer == a.buffer

    d[[0, 0]] = 9999
    puts a

.. code-block:: crystal

    false
    ndarray([[    0,    10,    10,     3],
            [12345,    10,    10,     7],
            [    8,    10,    10,    11]])
