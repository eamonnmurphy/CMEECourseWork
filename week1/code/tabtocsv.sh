#!/bin/bash
# Author: Eamonn Murphy eamonn.murphy21@imperial.ac.uk
# Script: tabtocsv.sh
# Description: substitute the tabs in the files with commas
# Saves the output into a .csv file
# Arguments: 1 -> tab delimited file
# Date: Oct 2021

# Return an error message if there is no input
if [ $# -eq 0 ]; then
    echo "No input file. Please add an input file as an argument."
    exit

# Return an error message if the input file doesn't exist
elif [ ! -f $1 ]; then
    echo "$1 does not exist"
    exit

# Return an error message if the input file format is incorrect
elif [[ $1 != *.txt ]] && [[ $1 != *.tsv ]]; then
    echo "Input file in incorrect format. Must be .txt or .tsv."
    exit
fi


# Convert tab delimited file to comma delimited and save
echo "Creating a comma delimited version of $1..."
if [[ $1 == *.txt ]]; then
    cat $1 | tr -s "\t" "," >> ../results/`basename -s .txt $1`.csv
elif [[ $1 == *.tsv ]]; then
    cat $1 | tr -s "\t" "," >> ../results/`basename -s .tsv $1`.csv
fi
exit
