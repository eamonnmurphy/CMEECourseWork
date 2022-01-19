#!/bin/bash
# Author: Eamonn Murphy eamonn.murphy21@imperial.ac.uk
# Script: ConcatenateTwoFies.sh
# Desc: Concatenate two files together
# Arguments: 3 -> Two input files and output destination

# Return an error message if an input file doesn't exist
if [ ! -f $1 ]; then
    echo "Input file 1 does not exist"
    exit

elif [ ! -f $2 ]; then
    echo "Input file 2 does not exist"
    exit

# Return an error message if there is no input
elif [ $# -eq 0 ] || [ $# -eq 1 ]; then
    echo "An input file is missing"
    exit

# Return an error message if no output destination
elif [ $# -eq 2 ]; then
    echo "No output destination provided. Please add an output destination."
    exit
fi

# Concatenate the files and exit
cat $1 > $3
cat $2 >> $3
echo "Merged File is"
cat $3
exit
