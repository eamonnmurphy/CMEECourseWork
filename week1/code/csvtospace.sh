#!/bin/bash

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

echo "Creating a space delimited version of $1..."
cat $1 | tr -s "," " " >> ../results/`basename -s .csv $1`.txt
exit