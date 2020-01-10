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

.. code-block:: crystal

    a = ndarray.new(5, 4) do |i, j|
      10 * i + j
    end
    puts a

    puts a[[2, 3]]
    puts a[...5, 1]
    puts a[..., 1]
    puts a[1...3, ...]

.. code-block:: crystal

    ndarray([[ 0,  1,  2,  3],
            [10, 11, 12, 13],
            [20, 21, 22, 23],
            [30, 31, 32, 33],
            [40, 41, 42, 43]])
    23
    ndarray([ 1, 11, 21, 31, 41])
    ndarray([ 1, 11, 21, 31, 41])
    ndarray([[10, 11, 12, 13],
            [20, 21, 22, 23]])


Shape Manipulation
==================

Changing the shape of an ndarray
------------------------------

NdArrays have shapes defined by the number of elements along each axis.

.. code-block:: crystal

    a = ndarray.random(0...10, [3, 4])
    puts a
    puts a.shape

.. code-block:: crystal

    ndarray([[8, 4, 8, 5],
            [7, 5, 9, 5],
            [3, 7, 5, 5]])
    [3, 4]

The shape of a andarray can be changed with many routines.  Many methods return
a view of the original data, but do not change the origin ndarray.

.. code-block:: crystal

    puts a.ravel
    puts a.reshape([6, 2])
    puts a.transpose
    puts a.transpose.shape
    puts a.shape

.. code-block:: crystal

    ndarray([8, 4, 8, 5, 7, 5, 9, 5, 3, 7, 5, 5])
    ndarray([[8, 4],
            [8, 5],
            [7, 5],
            [9, 5],
            [3, 7],
            [5, 5]])
    ndarray([[8, 7, 3],
            [4, 5, 7],
            [8, 9, 5],
            [5, 5, 5]])
    [4, 3]
    [3, 4]

If a dimension is provided as -1 in an operation that reshapes the ndarray, the other dimensions
are calculated automatically.  Only a single dimension can be dynamically calculated.

.. code-block:: crystal

    puts a.reshape(3, 2, -1)

.. code-block:: crystal

    ndarray([[[8, 4],
             [8, 5]],

            [[7, 5],
             [9, 5]],

            [[3, 7],
             [5, 5]]])


Stacking together different NdArrays
-----------------------------------

Many NdArrays can be stacked together along an axis.  Shapes must be the same on
the off-axis dimensions of the NdArrays.

.. code-block:: crystal

    a = ndarray.random(0...10, [2, 2])
    b = ndarray.random(0...10, [2, 2])

    puts a
    puts b

    puts B.vstack([a, b])
    puts B.hstack([a, b])
    puts B.column_stack([a, b])

.. code-block:: crystal

    ndarray([[7, 7],
            [1, 3]])
    ndarray([[3, 9],
            [7, 0]])
    ndarray([[7, 7],
            [1, 3],
            [3, 9],
            [7, 0]])
    ndarray([[7, 7, 3, 9],
            [1, 3, 7, 0]])
    ndarray([[7, 7, 3, 9],
            [1, 3, 7, 0]])

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
