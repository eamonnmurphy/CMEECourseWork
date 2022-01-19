#!/bin/bash
# Author: Eamonn Murphy eamonn.murphy21@imperial.ac.uk
# Script: csvtospace.sh
# Description: substitute the commas in the file with spaces
# Saves the output into a .txt file
# Arguments: 1 -> comma delimited file

# Return an error message if there is no input
if [ $# -eq 0 ]; then
    echo "No input file. Please add an input file as an argument."
    exit

# Return an error message if the input file doesn't exist
elif [ ! -f $1 ]; then
    echo "$1 does not exist"
    exit

# Return an error message if the input file format is incorrect
elif [[ $1 != *.csv ]]; then
    echo "Input file in incorrect format. Must be .csv"
    exit
fi

# Create a comma delimited version of the input
echo "Creating a space delimited version of $1..."
cat $1 | tr -s "," " " >> ../results/`basename -s .csv $1`.txt
exit
