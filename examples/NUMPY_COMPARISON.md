# Numpy compared with Vnum

This is a collection of common exercises using numpy, and their equivalent solutions using vnum

#### 1. Import the numpy package under the name `np` (★☆☆)


```python
import numpy as np
```

```v
import vnum.num
```

#### 2. Print the numpy version and the configuration (★☆☆)


```python
print(np.__version__)
np.show_config()
```

```v
import vnum
println(vnum.VERSION)
```

#### 3. Create a null vector of size 10 (★☆☆)


```python
Z = np.zeros(10)
print(Z)
```

```v
a := num.zeros([10])
```
#### 4. Create a null vector of size 10 but the fifth value which is 1 (★☆☆)


```python
Z = np.zeros(10)
Z[4] = 1
print(Z)
```

```v
z := num.zeros([10])
z.set([4], 1)
println(z)
```
#### 5. Create a vector with values ranging from 10 to 49 (★☆☆)


```python
Z = np.arange(10,50)
print(Z)
```

```v
z := num.seq_between(10, 50)
println(z)
```
#### 6. Reverse a vector (first element becomes last) (★☆☆)


```python
Z = np.arange(50)
Z = Z[::-1]
print(Z)
```

```v
z := num.seq(50)
r := z.slice([0, 50, -1])
println(z)
```
#### 7. Create a 3x3 matrix with values ranging from 0 to 8 (★☆☆)


```python
nz = np.arange(9).reshape(3, 3)
print(nz)
```

```v
nz := num.seq(9).reshape([3, 3])
```
#### 8. Create a 3x3 identity matrix (★☆☆)


```python
Z = np.eye(3)
print(Z)
```

```v
z := num.eye(3)
println(z)
```
#### 9. Create a 3x3x3 array with random values (★☆☆)


```python
Z = np.random.random((3,3,3))
print(Z)
```

```
z := num.random(0, 1, [3, 3, 3])
println(z)
```
#### 10. Create a 10x10 array with random values and find the minimum and maximum values (★☆☆)


```python
Z = np.random.random((10,10))
Zmin, Zmax = Z.min(), Z.max()
print(Zmin, Zmax)
```

```v
z := num.random(0, 1, [10, 10])
zmin := z.min()
zmax := z.max()
println(zmin, zmax)
```
#### 11. Create a random vector of size 30 and find the mean value (★☆☆)


```python
Z = np.random.random(30)
m = Z.mean()
print(m)
```

```v
z := num.random(0, 1, [30])
m := z.mean()
println(m)
```
#### 12. Create a 2d array with 1 on the border and 0 inside (★☆☆)


```python
Z = np.ones((10,10))
Z[1:-1,1:-1] = 0
print(Z)
```

```v
z := num.ones([10, 10])
z.slice([1, -1], [1, -1]).fill(0)
println(z)
```