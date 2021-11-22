import scipy as sc
from scipy import stats

stats.norm.rvs(size = 10)

np.random.seed(1234)
stats.norm.rvs(size = 10)

stats.norm.rvs(size = 5, random_state = 1234)

stats.randint.rvs(0,10, size = 7)

stats.randint.rvs(0, 10, size = 7, random_state = 1234)

stats.randint.rvs(0, 10, size = 7, random_state = 3445)

import scipy.integrate as integrate

y = np.array([5,20,18,19,18,7,4])

import matplotlib.pylab as p
p.plot(y)
p.show()

area = integrate.trapz(y, dx = 1)
print("area =", area)

area = integrate.simps(y, dx = 2)
print("area =", area)

area = integrate.simps(y, dx = 3)
print("area =", area)