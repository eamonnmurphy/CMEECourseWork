# Return square root x
def foo_1(x):
    return x ** 0.5

# Return x and y if x > y, otherwise return y
def foo_2(x, y):
    if x > y:
        return x
    return y

# Switch value of x, y, z so that z will be the largest etc.
def foo_3(x,y,z):
    if x > y:
        tmp = y
        y = x
        x = tmp
    if y > z:
        tmp = z
        z = y
        y = tmp
    return [x,y,z]

# Return factorial of x
def foo_4(x):
    result = 1
    for i in range(1, x + 1):
        result = result * i
    return result

# a recursive function that calculates the factorial of x
def foo_5(x):
    if x == 1:
        return 1
    return x * foo_5(x -1)

# Different method of calculating factorial of x
def foo_6(x):
    facto = 1
    while x >=1:
        facto = facto * x
        x = x -1
    return facto

