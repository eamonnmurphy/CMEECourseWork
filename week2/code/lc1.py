cobirds = ( ('Passerculus sandwichensis','Savannah sparrow',18.7),
          ('Delichon urbica','House martin',19),
          ('Junco phaeonotus','Yellow-eyed junco',19.5),
          ('Junco hyemalis','Dark-eyed junco',19.6),
          ('Tachycineata bicolor','Tree swallow',20.2),
         )

#(1) Write three separate list comprehensions that create three different
# lists containing the latin names, common names and mean body masses for
# each species in birds, respectively.



latin_names = [row[0] for row in cobirds]
print("Latin names: \n", latin_names)

common_names = [row[1] for row in cobirds]
print("Common names: \n", common_names)

mean_body_masses = [row[2] for row in cobirds]
print("Mean body masses: \n", mean_body_masses)

# (2) Now do the same using conventional loops (you can choose to do this 
# before 1 !).

latin_names = []
common_names = []
mean_body_masses = []

for i in cobirds:
    latin_names.append(i[0])
print("Latin names: \n", latin_names)

for i in cobirds:
    common_names.append(i[1])
print("Common names: \n", common_names)

for i in cobirds:
    mean_body_masses.append(i[2])
print("Mean body masses: \n", mean_body_masses)

# A nice example out out is:
# Step #1:
# Latin names:
# ['Passerculus sandwichensis', 'Delichon urbica', 'Junco phaeonotus', 'Junco hyemalis', 'Tachycineata bicolor']
# ... etc.
 