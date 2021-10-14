#!/usr/bin/env python3

'''This is a boilerplate script.
It prints 'This is a boilerplate', and checks to ensure the function is called.'''

__appname__ = 'boilerplate'
__author__ = 'Eamonn Murphy (eamonn.murphy21@imperial.ac.uk)'
__version__ = '0.0.1'
__licence__ = 'Licence for this code/program'

## imports ##
import sys # module to interface our program with the operating system

## constants ##


## functions ##
def main(argv):
    '''Main entry point of the program'''
    print('This is a boilerplate') # NOTE: indented using two tabs or 4 spaces
    return 0

if __name__ == '__main__':
    '''Makes sure the 'main' function is called from command line'''
    status = main(sys.argv)
    sys.exit(status)