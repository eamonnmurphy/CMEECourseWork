#!/usr/bin/env/ python3 
"""More effecient scripts to test profiling"""
__author__ = "Eamonn Murphy"
__version__ = "0.0.1"

import numpy as np

def my_squares(iters):
    """Return list of squares"""
    out = [i ** 2 for i in range(iters)]
    return out

def my_join(iters, string):
    """Join together a string iters times"""
    out = ''
    for i in range(iters):
        out += ", " + string
    return out

def run_my_funcs(x, y):
    """Run the defined functions"""
    print(x, y)
    my_squares(x)
    my_join(x, y)
    return 0

run_my_funcs(10000000, "My string")