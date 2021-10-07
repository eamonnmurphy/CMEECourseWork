#!/bin/bash
# Author: Eamonn Murphy eamonn.murphy21@imperial.ac.uk
# Script: tabtocsv.sh
# Description: substitute the tabs in the files with commas
# Saves the output into a .csv file
# Arguments: 1 -> tab delimited file
# Date: Oct 2021

echo "Creating a comma delimited version of $1..."
cat $1 | tr -s "\t" "," >> $1.csv
if [$? == 0]
then
    echo "Done!"
    exit
fi
echo "Invalid/no input file"
exit