#!/usr/bin/env python3

'''Some mathematical operation functions, including factorials.'''

__author__ = 'Eamonn Murphy (eamonn.murphy21@imperial.ac.uk)'
__version__ = '0.0.1'

## imports ##
import sys # module to interface our program with the operating system

## functions ##
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

def main(argv):
    print('foo_1(5): ', foo_1(5))
    print('foo_2(4, 5): ', foo_2(4, 5))
    print('foo_3(4, 2, 5): ', foo_3(4, 2, 5))
    print('foo_4(5): ', foo_4(5))
    print('foo_5(4): ', foo_5(4))
    print('foo_6(6): ', foo_6(6))
    return 0

if __name__ == '__main__':
    '''Makes sure the 'main' function is called from command line'''
    status = main(sys.argv)
    sys.exit(status)