#!/usr/bin/env python3
"""Explores methods for reading .txt files as input"""

__author__ = "Eamonn Murphy (etm21@ic.ac.uk)"
__version__ = "0.0.1"

######################
# FILE INPUT
######################
# Open a file for reading
f = open('../sandbox/test.txt', 'r')
# use "implicit" for loop:
# if the object is a file, python will cycle over lines
for line in f:
    print(line)

# close the file
f.close()

# Same example, skip blank lines
f = open('../sandbox/test.txt', 'r')
for line in f:
    if len(line.strip()) > 0:
        print(line)

f.close()