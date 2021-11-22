import numpy as np

a = np.array(range(5))
a

print(type(a[0]))

print(type(a[0]))

a = np.array(range(5), float)
a
a.dtype

x = np.arange(5)
x

x = np.arange(5.)
x
x.shape

b = np.array([i for i in range(10) if i % 2 == 1])
b

c = b.tolist()
c

mat = np.array([[0,1], [2,3]])
mat

mat.shape

mat[1]
mat[:,1]
mat[0,0]
mat[1,0]
mat[:,0]
mat[0,1]
mat[0,-1]
mat[-1,0]
mat[0,-2]

mat[0,0] = -1
mat

mat[:,0] = [12,12]
mat

np.append(mat, [[12,12]], axis = 0)
np.append(mat, [[12], [12]], axis = 1)

newRow = [[12,12]]

mat = np.append(mat, newRow, axis = 0)
mat

np.delete(mat, 2, 0)

mat = np.array([[0,1], [2,3]])
mat0 = np.array([[0,10], [-1,3]])
np.concatenate((mat, mat0), axis = 0)

mat.ravel()
mat.reshape((4,1))
mat.reshape((1,4))
mat.reshape((3,1))

np.ones((4,2))
np.zeros((4,2))

m = np.identity(4)
m

m.fill(16)
m

mm = np.arange(16)
mm = mm.reshape(4,4)
mm

mm.transpose()

mm + mm.transpose()

mm - mm.transpose()

mm * mm.transpose()

mm // mm.transpose()
mm // (mm + 1).transpose()

mm * np.pi

mm.dot(mm)

mm
