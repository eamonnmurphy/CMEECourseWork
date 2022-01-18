#!/usr/bin/env python3#
""" Examples to show use of scope"""

_a_global = 10

if _a_global >= 5:
    _b_global = _a_global + 5

def a_function():
    """ Shows difference between local and global variables"""
    _a_global = 5

    if _a_global >= 5:
        _b_global = _a_global + 5
    
    _a_local = 4
    print("Inside the function, the value of _a_global is ", _a_global)
    print("Inside the function, the value of _b_global is ", _b_global)
    print("Inside the function, the value of _a_local is ", _a_local)

    return None

a_function()

print("Outside the function, the value of _a_global is ", _a_global)
print("Outside the function, the value of _b_global is ", _b_global)

_a_global = 10

def a_function():
    """ Defines a local variable"""
    _a_local = 4
    print("Inside the function, the value of a_local is", _a_local)
    print("Inside the function, the value of a_global is ", _a_global)

    return None

a_function()

print("Outside the function, the value of _a_global is ", _a_global)

_a_global = 10

print("Outside the function, the value of _a_global is ", _a_global)

def a_function():
    """ Defines a global function"""
    global _a_global
    _a_global = 5
    _a_local = 4

    print("Inside the function, the value of _a_global is ", _a_global)
    print("Inside the function, the value of _a_local is ", _a_local)

    return None

a_function()

print("Outside the function, the value of _a_global now is", _a_global)

def a_function():
    """Function with a subfunction"""
    _a_global = 10

    def _a_function2():
        """Defines a global variable"""
        global _a_global
        _a_global = 20
    
    print("Before calling a_function, value of _a_global is ", _a_global)

    _a_function2()

    print("After calling _a_function2, value of _a_global is ", _a_global)

    return None

a_function()

print("The value of a_global in main workspace / namespace is ", _a_global)

_a_global = 10

def a_function():
    """Function with a subfunction"""
    def _a_function2():
        """Defines global"""
        global _a_global
        _a_global = 20
    
    print("Before calling a_function, value of _a_global is ", _a_global)

    _a_function2()
    
    print("After calling _a_function2, value of _a_global is ", _a_global)

a_function()

print("The value of a_global in main workspace / namespace is ", _a_global)