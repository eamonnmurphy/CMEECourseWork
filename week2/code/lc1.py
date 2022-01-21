#!/usr/bin/env python3

"""Prints lists of latin names, common names and weights for a list of birds.

Uses list comprehensions and loops to create seperate lists for latin names,
common names and mean body masses, and prints them."""

__author__ = "Eamonn Murphy (etm21@ic.ac.uk)"
__version__ = "0.0.1"

cobirds = ( ('Passerculus sandwichensis','Savannah sparrow',18.7),
          ('Delichon urbica','House martin',19),
          ('Junco phaeonotus','Yellow-eyed junco',19.5),
          ('Junco hyemalis','Dark-eyed junco',19.6),
          ('Tachycineata bicolor','Tree swallow',20.2),
         )

#(1) Write three separate list comprehensions that create three different
# lists containing the latin names, common names and mean body masses for
# each species in birds, respectively.

sep = ", " # Define a seperator string to be used when printing

latin_names = [row[0] for row in cobirds]  #Comprehension to create list
print("Latin names: \n", sep.join(latin_names))

common_names = [row[1] for row in cobirds]
print("Common names: \n", sep.join(common_names))

mean_body_masses = [row[2] for row in cobirds]
print("Mean body masses:")
print(*mean_body_masses, sep=", ")

# (2) Now do the same using conventional loops (you can choose to do this 
# before 1 !).

# Create empty lists
latin_names = []
common_names = []
mean_body_masses = []

# Populate lists using for loops and print
for i in cobirds:
    latin_names.append(i[0])
    common_names.append(i[1])
    mean_body_masses.append(i[2])

print("Latin names: \n", sep.join(latin_names))
print("Common names: \n", sep.join(common_names))
print("Mean body masses:")
print(*mean_body_masses, sep=", ")

# A nice example output is:
# Step #1:
# Latin names:
# ['Passerculus sandwichensis', 'Delichon urbica', 'Junco phaeonotus', 'Junco hyemalis', 'Tachycineata bicolor']
# ... etc.
 