#!/usr/bin/env python3
"""Examples of how to open and read csv files"""

__author__ = "Eamonn Murphy (etm21@ic.ac.uk)"
__version__ = "0.0.1"

import csv

# Read a file containing:
# 'Species', 'Infraorder', 'Family', 'Distribution', 'Body mass male (Kg)'
with open('../data/testcsv.csv', 'r') as f:

    csvread = csv.reader(f) # Read in the file
    temp = []
    # Loop through each row in the csv
    for row in csvread:
        temp.append(tuple(row))
        print(row)
        print('The species is', row[0])

# Write a file containing only species name and Body mass
with open('../data/testcsv.csv', 'r') as f:
    with open('../data/bodymass.csv', 'w') as g:

        csvread = csv.reader(f) # Read in the file
        csvwrite = csv.writer(g) # Initialise file for writing to
        # Loop through rows in the csv
        for row in csvread:
            print(row)
            csvwrite.writerow([row[0], row[4]])