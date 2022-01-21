#!/usr/bin/env python3
""" Contains an example buggy function"""

__author__ = "Eamonn Murphy (etm21@ic.ac.uk)"
__version__ = "0.0.1"


def buggyfunc(x):
    """An example function to be debugged"""
    y = x
    for i in range(x):
        try:
            y = y-1
            z = x/y
        except ZeroDivisionError:
            print(f"The result of dividing a number by zero is undefined")
        except:
            print(f"This didn't work; x = {x}; y = {y}")
        else:
            print(f"OK; x = {x}; y = {y}, z = {z};")
    return z

buggyfunc(20)