# Average UK Rainfall (mm) for 1910 by month
# http://www.metoffice.gov.uk/climate/uk/datasets
rainfall = (('JAN',111.4),
            ('FEB',126.1),
            ('MAR', 49.9),
            ('APR', 95.3),
            ('MAY', 71.8),
            ('JUN', 70.2),
            ('JUL', 97.1),
            ('AUG',140.2),
            ('SEP', 27.0),
            ('OCT', 89.4),
            ('NOV',128.4),
            ('DEC',142.2),
           )

# (1) Use a list comprehension to create a list of month,rainfall tuples where
# the amount of rain was greater than 100 mm.

high_rainfall_months = [pair for pair in rainfall if pair[1] > 100]
print("Months with rainfall > 100mm, with rainfall values:\n", high_rainfall_months)
 
# (2) Use a list comprehension to create a list of just month names where the
# amount of rain was less than 50 mm.

low_rainfall_months = [pair[0] for pair in rainfall if pair[1] < 50]
print("Months with rainfall volumes of less than 50mm:\n", low_rainfall_months)

# (3) Now do (1) and (2) using conventional loops (you can choose to do 
# this before 1 and 2 !).

high_rainfall_months = []
for pair in rainfall:
    if pair[1] > 100:
        high_rainfall_months.append(pair)
print("Months with rainfall > 100mm, with rainfall values:\n", high_rainfall_months)

low_rainfall_months = []
for pair in rainfall:
    if pair[1] < 50:
        low_rainfall_months.append(pair[0])
print("Months with rainfall volumes of less than 50mm:\n", low_rainfall_months)

# A good example output is:
#
# Step #1:
# Months and rainfall values when the amount of rain was greater than 100mm:
# [('JAN', 111.4), ('FEB', 126.1), ('AUG', 140.2), ('NOV', 128.4), ('DEC', 142.2)]
# ... etc.

