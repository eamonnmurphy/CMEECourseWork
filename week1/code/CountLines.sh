#!/bin/bash
# Desc: Count the lines in the input file
# Arguments: Text file

NumLines=`wc -l $1`
echo "The file $1 has $NumLines lines"
echo
