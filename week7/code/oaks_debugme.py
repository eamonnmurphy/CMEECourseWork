#!/usr/bin/env python3
"""Reads an input file of tree names and outputs the oaks to a csv.

Robust to slight typos and misspellings."""

__author__ = 'Eamonn Murphy (eamonn.murphy21@imperial.ac.uk)'
__version__ = '0.0.1'

import csv
import sys

#Define function
def is_an_oak(name):
    """ Returns True if name is starts with 'quercus'

    Insensitive to case. Doctests listed below show the expected behaviour.

    >>> is_an_oak('Quercus cirrus')
    True

    >>> is_an_oak('quercus cirrus')
    True

    >>> is_an_oak('Quercuss cirrus')
    False

    >>> is_an_oak(' Quercus cirrus')
    True

    >>> is_an_oak('Fagus sylvatica')
    False
    """

    # Return T/F if quercus begins the string, after lower (makes it case 
    # insensitive) and strip (removes leading spaces)
    return name.lower().strip().startswith('quercus ')

def main(argv):
    """Main entry point of program. Writes oaks to csv.
    
    Takes an input csv of tree species, and writes only the oak species to
    a new file."""

    # Open csvs for reading and writing
    with open('../data/TestOaksData.csv','r') as f,\
            open('../data/JustOaksData.csv','w') as g:
        taxa = csv.reader(f) # Read lines in input csv
        csvwrite = csv.writer(g) # Prepare to write to output csv

        # Loop through the rows in the input csv
        for row in taxa:
            # Print out each tree species from the csv
            print(row)
            print ("The genus is: ") 
            print(row[0] + '\n')

            # Check if species is an oak, combining genus and species from each
            # row into a single string with join
            if is_an_oak(" ".join(row)):
                print('FOUND AN OAK!\n')
                csvwrite.writerow([row[0], row[1]])    

    return 0
    
if (__name__ == "__main__"):
    import doctest
    doctest.testmod() # Runs embedded doctests
    
    status = main(sys.argv)
    sys.exit(status)