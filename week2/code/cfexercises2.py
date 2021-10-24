#!/usr/bin/env python3
''' Combining loops with conditionals examples'''

def hello_1(x):
    ''' Return hello if divisible by 3'''
    for j in range(12):
        if j % 3 == 0:
            print('hello')
    print(' ')
hello_1(12)

def hello_2(x):
    ''' Return hello if remainders after division are correct'''
    for j in range(15):
        if j % 5 == 3:
            print('hello')
        elif j % 4 == 3:
            print('hello')
    print(' ')
hello_2(12)

def hello_3(x, y):
    ''' Print hello if i between x and y'''
    for i in range(x, y):
        print('hello')
    print(' ')

def hello_4(z):
    ''' Print hello if statement is true'''
    while z != 15:
        print('hello')
        z = z + 3
    print(' ')

hello_4(0)

def hello_5(z):
    ''' Print hello if one of two statements is true'''
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
    ''' While loop with break'''
    while x:
        print("hello!" + str(y))
        y += 1
        if y == 6:
            break
    print(' ')

hello_6(True, 0)