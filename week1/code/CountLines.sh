#!/bin/bash
# Author: Eamonn Murphy
# Script: CountLines.sh
# Desc: Count the lines in the input file
# Arguments: 1 -> text file

# Return an error message if the input file doesn't exist
if [ ! -f $1 ]; then
    echo "$1 does not exist"
    exit
fi

# Return an error message if there is no input
if [ $# -eq 0 ]; then
    echo "No input file. Please add an input file as an argument."
    exit
fi

NumLines=`wc -l < $1`
echo "The file $1 has $NumLines lines"
echo
