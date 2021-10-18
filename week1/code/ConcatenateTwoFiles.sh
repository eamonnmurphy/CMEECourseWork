#!/bin/bash
# Desc: Concatenate two files together
# Arguments: Two input files and output destination

# Return an error message if an input file doesn't exist
if [ ! -f $1 ] || [ ! -f $2 ]; then
    echo "Input file does not exist"
    exit
fi

# Return an error message if there is no input
if [ $# -eq 0 ] || [ $# -eq 1 ]; then
    echo "An input file is missing"
    exit
fi

# Return an error message if no output destination
if [ $# -eq 2 ]; then
    echo "No output destination"
    exit
fi

# Concatenate the files and exit
cat $1 > $3
cat $2 >> $3
echo "Merged File is"
cat $3
exit
