#!/usr/bin/env python3
"""Example code to try out profiling"""

__author__ = 'Eamonn Murphy (eamonn.murphy21@imperial.ac.uk)'
__version__ = '0.0.1'

def my_squares(iters):
    """Return squares for items in list"""
    out = []
    for i in range(iters):
        out.append(i ** 2)
    return out

def my_join(iters, string):
    """Join string iters times"""
    out = ''
    for i in range(iters):
        out += string.join(", ")
    return out

def run_my_funcs(x,y):
    """Run the functions on x and y"""
    print(x,y)
    my_squares(x)
    my_join(x,y)
    return 0

run_my_funcs(10000000, "My string")