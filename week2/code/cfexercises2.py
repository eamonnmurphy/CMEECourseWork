#!/usr/bin/env python3
"""Examples of combining loops and conditionals"""

__author__ = "Eamonn Murphy (etm21@ic.ac.uk)"
__version__ = "0.0.1"

def hello_1(x):
    """Return hello if x is divisible by 3"""
    for j in range(12):
        if j % 3 == 0:
            print('hello')
    print(' ')
hello_1(12)

def hello_2(x):
    """Return hello, depending on the remainder when dividing x"""
    for j in range(15):
        if j % 5 == 3:
            print('hello')
        elif j % 4 == 3:
            print('hello')
    print(' ')
hello_2(12)

def hello_3(x, y):
    """Print hello for i between x and y"""
    for i in range(x, y):
        print('hello')
    print(' ')

def hello_4(z):
    """Print hello while statement is true, using z as an input"""
    while z != 15:
        print('hello')
        z = z + 3
    print(' ')

hello_4(0)

def hello_5(z):
    """Print hello while one of two statements about z is true"""
    while z < 100:
        if z == 31:
            for k in range(7):
                print('hello')
        elif z == 18:
            print('hello')
        z = z + 1
    print(' ')

hello_5(12)

def hello_6(x, y):
    """While loop with break"""
    while x:
        print("hello!" + str(y))
        y += 1
        if y == 6:
            break
    print(' ')

hello_6(True, 0)