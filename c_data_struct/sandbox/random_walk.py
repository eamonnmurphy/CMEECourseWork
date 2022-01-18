import random
import matplotlib.pyplot as plt

walk = [1000]

for i in range(99):
    walk.append(walk[i] + 0.1 + random.randint(-10,10))

plt.scatter(range(100), walk)
plt.show()
