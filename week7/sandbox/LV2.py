#!/usr/bin/env python3
"""Generate two figures for the Lotka-Volterra model"""

import scipy as sc
import numpy as np
import sys
from scipy import integrate

def dCR_dt(pops, t = 0):
    """Function that returns growth rate of consumer and resource population"""
    R = pops[0]
    C = pops[1]
    dRdt = (r * R * (1 - R/K)) - (a * R * C)
    dCdt = -(z * C) + (e * a * R * C)

    return np.array([dRdt, dCdt])

type(dCR_dt)

# Assign parameter values
r = 1.
a = 0.1
z = 1.5
e = 0.75

# Define time vector, returning 1000 evenly spaced nos from 0 to 15
t = np.linspace(0, 15, 1000)

# Set initial condition
R0 = 10
C0 = 5
RC0 = np.array([R0, C0])

# Numerically integrate this system forward
pops, infodict = integrate.odeint(dCR_dt, RC0, t, full_output=True)
pops
type(infodict)
infodict.keys()
infodict["message"]

# Visualise results, plotting resource and consumer density vs time
import matplotlib.pylab as p

def figure_one(time = t, populations = pops):
    f1 = p.figure()

    p.plot(t, pops[:,0], "g-", label = "Resource density") # Plot
    p.plot(t, pops[:,1], "b-", label = "Consumer density")
    p.grid()
    p.legend(loc = "best")
    p.xlabel("Time")
    p.ylabel("Population density")
    p.title("Consumer-Resource population dynamics")

    f1.savefig("../results/LV_model.pdf") # Save figure

    return None


# Plot resource density vs consumer density
def figure_two(populations = pops):
    f2 = p.figure()

    p.plot(pops[:,0], pops[:,1], "r-")
    p.grid()
    p.xlabel("Resource density")
    p.ylabel("Consumer density")
    p.title("Consumer-Resource population dynamics")

    f2.savefig("../results/LV_model_2.pdf")

    return None

def main(argv):
    figure_one()
    figure_two()
    return None

if (__name__ == "__main__"):
    status = main(sys.argv)
    sys.exit(status)