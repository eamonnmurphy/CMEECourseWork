#!usr/bin/env python3
'''Finds just those taxa that are oak trees from a list of species'''

taxa = ['Quercus robur',
        'Fraxinus excelsior',
        'Pinus sylvestris',
        'Quercus cerris',
        'Quercus petraea',
        ]

# check if input is an oak
def is_an_oak(name):
    '''Check if name is an oak'''
    return name.lower().startswith('quercus')

##Using for loops
oaks_loops = set()
for species in taxa:
    if is_an_oak(species):
        oaks_loops.add(species)
print(oaks_loops)

## create list of oaks using list comprehension
oaks_lc  = set([species for species in taxa if is_an_oak(species)])
print(oaks_lc)

##Get names in UPPER CASE using for loops
oaks_loops = set()
for species in taxa:
    if is_an_oak(species):
        oaks_loops.add(species.upper())
print(oaks_loops)

## get names in UPPER CASE
oaks_lc = set([species.upper() for species in taxa if is_an_oak(species)])
print(oaks_lc)
