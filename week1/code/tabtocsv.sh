#!/bin/bash
# Author: Eamonn Murphy eamonn.murphy21@imperial.ac.uk
# Script: tabtocsv.sh
# Description: substitute the tabs in the files with commas
# Saves the output into a .csv file
# Arguments: 1 -> tab delimited file
# Date: Oct 2021

# Return an error message if the input file doesn't exist
if [ ! -f $1 ]; then
    echo "$1 does not exist"
    exit
fi

# Return an error message if there is no input
if [ $# -eq 0 ]; then
    echo "No input file"
    exit
fi

echo "Creating a comma delimited version of $1..."
cat $1 | tr -s "\t" "," >> ../results/`basename -s .txt $1`.csv
exit
