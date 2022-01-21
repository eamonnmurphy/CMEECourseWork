#!/usr/bin/env python3
"""Generate two figures for the Lotka-Volterra model

The Lotka-Volterra (LV) model is a classical model in biology, for a
predator-prey or consumer-resource system in 2D space. This script integrates 
an equation for the growth rate at any time step, to generate population sizes
for each time step.

Two figures are generated based on this model. The first plots consumer
and resource density against time. The second plots consumer density against
resource density.

Requires the numpy and scipy packages for the modelling and integration, and
matplotlib for plotting."""

__author__ = 'Eamonn Murphy (eamonn.murphy21@imperial.ac.uk)'
__version__ = '0.0.1'

import scipy as sc
import numpy as np
import sys
from scipy import integrate
import matplotlib.pylab as p

def dCR_dt(pops, t = 0, r = 1., a = 0.1, z = 1.5, e = 0.75):
    """Returns growth rate of consumer and resource population at any time step

    Where:
        C = Consumer abundance/density
        R = Resource abundance/density
        r = Growth rate of resource population
        a = Rate of consumption of resource by consumer (integrating search
            rate and attack success probability
        z = Mortality rate of consumer
        e = Efficiency of consumer at converting resource to consumer biomass"""
    
    # Start values for R and C
    R = pops[0]
    C = pops[1]

    # Equations for growth rate of resource and consumer population
    dRdt = (r * R) - (a * R * C)
    dCdt = -(z * C) + (e * a * R * C)

    return np.array([dRdt, dCdt])

def integrate_LV(t, R0 = 10, C0 = 5):
    """Numerically integrate the LV system forward from the starting conditions

    Using the formulas for consumer and resource growth at a given time point,
    this function will return the population densities at all time points
    given in t, by forward numerical integration of the ODE. R0 and C0
    represent the starting resource and consumer densities, respectively."""
    RC0 = np.array([R0, C0]) # Create array from initial densities

    # Forward integrate using scipy function integrate.odeint for
    # integration of ODEs
    pops, infodict = integrate.odeint(dCR_dt, RC0, t, full_output=True)

    return pops


# Visualise results, plotting resource and consumer density vs time
def figure_one(populations, time):
    """Outputs resource and consumer density vs. time to a pdf file."""
    f1 = p.figure() # Initialise figure

    p.plot(time, populations[:,0], "g-", label = "Resource density") # Plot resource
    p.plot(time, populations[:,1], "b-", label = "Consumer density") # Plot consumer
    p.grid() # Add grid
    p.legend(loc = "best") # Add legend at 'best' position
    p.xlabel("Time")
    p.ylabel("Population density")
    p.title("Consumer-Resource population dynamics")

    f1.savefig("../results/LV_model.pdf") # Save figure

    return None


# Plot resource density vs consumer density
def figure_two(populations):
    """Outputs resource density vs. consumer density"""
    f2 = p.figure() # Initialise figure

    p.plot(populations[:,0], populations[:,1], "r-") # Plot resource vs. consumer density
    p.grid()
    p.xlabel("Resource density")
    p.ylabel("Consumer density")
    p.title("Consumer-Resource population dynamics")

    f2.savefig("../results/LV_model_2.pdf") # Save figure to output

    return None

def main(argv):
    """Main entry point of the program. Creates defined figures based on default values"""
    t = np.linspace(0, 15, 1000) # Initialise time vector
    pops = integrate_LV(t)
    figure_one(pops, t)
    figure_two(pops)
    return None

if __name__ == "__main__":
    status = main(sys.argv)
    sys.exit(status)