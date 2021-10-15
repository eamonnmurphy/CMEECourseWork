baserate = 0.015
sensitivity = 0.9
specificity = 0.99
students = 100

false_neg_campus = (baserate * (1-sensitivity))*students
print(round(false_neg_campus, 3))