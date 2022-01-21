#!/usr/bin/env python3
"""Output information about some bird species from an input tuple.

Reads a tuple of tuples provided with some information about birds,
and outputs this information line by line for each species."""

__author__ = "Eamonn Murphy (etm21@ic.ac.uk)"
__version__ = "0.0.1"

birds = (('Passerculus sandwichensis', 'Savannah sparrow', 18.7),
         ('Delichon urbica', 'House martin', 19),
         ('Junco phaeonotus', 'Yellow-eyed junco', 19.5),
         ('Junco hyemalis', 'Dark-eyed junco', 19.6),
         ('Tachycineata bicolor', 'Tree swallow', 20.2),
         )

# Birds is a tuple of tuples of length three: latin name, common name, mass.
# write a (short) script to print these on a separate line or output block
# by species
#
# A nice example output is:
#
# Latin name: Passerculus sandwichensis
# Common name: Savannah sparrow
# Mass: 18.7
# ... etc.

# Hints: use the "print" command! You can use list comprehensions!

for species in birds:
    print('Latin name: ', species[0])
    print('Common name: ', species[1])
    print('Mass: ', species[2])
    print()
