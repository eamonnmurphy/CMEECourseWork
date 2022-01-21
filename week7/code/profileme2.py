#!/usr/bin/env/ python3 
"""More efficient scripts to test profiling and compare"""
__author__ = "Eamonn Murphy"
__version__ = "0.0.1"

import numpy as np

def my_squares(iters):
    """Return list of squares"""
    out = [i ** 2 for i in range(iters)] # List comprehension
    return out

def my_join(iters, string):
    """Join input string to a new string iters times"""
    out = ''
    for i in range(iters):
        out += ", " + string
    return out

def run_my_funcs(x, y):
    """Run the defined functions on inputs x and y
    
    x -> integer
    y -> string"""
    print(x, y)
    my_squares(x)
    my_join(x, y)
    return 0

run_my_funcs(10000000, "My string")