import scipy as sc
import numpy as np

from scipy import integrate

def dCR_dt(pops, t = 0):

    R = pops[0]
    C = pops[1]
    dRdt = (r * R) - (a * R * C)
    dCdt = -(z * C) + (e * a * R * C)

    return np.array([dRdt, dCdt])

type(dCR_dt)

r = 1.
a = 0.1
z = 1.5
e = 0.75

t = np.linspace(0, 15, 1000)

R0 = 10
C0 = 5
RC0 = np.array([R0, C0])

pops, infodict = integrate.odeint(dCR_dt, RC0, t, full_output=True)

pops
type(infodict)
infodict.keys()
infodict["message"]

import matplotlib.pylab as p
f1 = p.figure()

p.plot(t, pops[:,0], "g-", label = "Resource density") # Plot
p.plot(t, pops[:,1], "b-", label = "Consumer density")
p.grid()
p.legend(loc = "best")
p.xlabel("Time")
p.ylabel("Population density")
p.title("Consumer-Resource population dynamics")
p.show()

f1.savefig("../results/LV_model.pdf") # Save figure