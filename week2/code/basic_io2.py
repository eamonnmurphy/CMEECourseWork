#!/usr/bin/env python3
"""Explores how to write to a file"""

__author__ = "Eamonn Murphy (etm21@ic.ac.uk)"
__version__ = "0.0.1"

#############
# FILE OUTPUT
#############
# Save the elements of a list to a file
list_to_save = range(100)

f = open('../sandbox/testout.txt', 'w')
for i in list_to_save:
    f.write(str(i) + '\n')

f.close()