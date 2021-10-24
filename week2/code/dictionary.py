#!/usr/bin/env python3

'''Populate a dictionary using an order key with species'''

taxa = [('Myotis lucifugus', 'Chiroptera'),
        ('Gerbillus henleyi', 'Rodentia',),
        ('Peromyscus crinitus', 'Rodentia'),
        ('Mus domesticus', 'Rodentia'),
        ('Cleithrionomys rutilus', 'Rodentia'),
        ('Microgale dobsoni', 'Afrosoricida'),
        ('Microgale talazaci', 'Afrosoricida'),
        ('Lyacon pictus', 'Carnivora'),
        ('Arctocephalus gazella', 'Carnivora'),
        ('Canis lupus', 'Carnivora'),
        ]

# Write a short python script to populate a dictionary called taxa_dic
# derived from  taxa so that it maps order names to sets of taxa.
#
# An example output is:
#
# 'Chiroptera' : set(['Myotis lucifugus']) ... etc.
#  OR,
# 'Chiroptera': {'Myotis lucifugus'} ... etc

# Create taxa_dic with the correct keys
taxa_dic = {'Rodentia': [], 'Afrosoricida': [],
            'Carnivora': [], 'Chiroptera': []}

# Create a seperate set for each order
rodentia = {pair[0] for pair in taxa if pair[1] == 'Rodentia'}
afrosoricida = {pair[0] for pair in taxa if pair[1] == 'Afrosoricida'}
carnivora = {pair[0] for pair in taxa if pair[1] == 'Carnivora'}
chiroptera = {pair[0] for pair in taxa if pair[1] == 'Chiroptera'}

# Map each set to the correct key in taxa_dic
taxa_dic['Rodentia'] = rodentia
taxa_dic['Chiroptera'] = chiroptera
taxa_dic['Carnivora'] = carnivora
taxa_dic['Afrosoricida'] = afrosoricida

# Print output
print('Afrosoricida: ', taxa_dic['Afrosoricida'])
print('Carnivora: ', taxa_dic['Carnivora'])
print('Chiroptera: ', taxa_dic['Chiroptera'])
print('Rodentia: ', taxa_dic['Rodentia'])
