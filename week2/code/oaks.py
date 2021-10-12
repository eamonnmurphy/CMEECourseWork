## Finds just those taxa that are oak trees from a list of species

taxa = ['Quercus robur',
        'Fraxinus excelsior',
        'Pinus sylvestris',
        'Quercus cerris',
        'Quercus petraea',
        ]

# check if input is an oak
def is_an_oak(name):
    return name.lower().startswith('quercus')

## create list of oaks using list comprehension
oaks_lc  = set([species for species in taxa if is_an_oak(species)])
print(oaks_lc)

## get names in UPPER CASE
oaks_lc = set([species.upper() for species in taxa if is_an_oak(species)])
print(oaks_lc)
