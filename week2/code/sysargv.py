#!/usr/bin/env python3
"""Example use of sys.argv, which allows user to input arguments to script"""

import sys
print("This is the name of the script: ", sys.argv[0])
print('Number of arguments: ', len(sys.argv))
print('The arguments are: ', str(sys.argv))