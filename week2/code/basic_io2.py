#!/usr/bin/env python3
"""Writing to a file"""

#############
# FILE OUTPUT
#############
# Save the elements of a list to a file
list_to_save = range(100)

f = open('../sandbox/testout.txt', 'w')
for i in list_to_save:
    f.write(str(i) + '\n')

f.close()