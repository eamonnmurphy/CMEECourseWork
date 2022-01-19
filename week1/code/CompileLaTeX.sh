#!/bin/bash
# Author: Eamonn Murphy eamonn.murphy21@imperial.ac.uk
# Script: ConcatenateTwoFies.sh
# Desc: Concatenate two files together
# Arguments: 3 -> Two input files and output destination

# Check for an input argument
if [ $# -eq 0 ]; then
    echo "No input provided. Please provide the name of a LaTeX file."
    exit

# Process input if it includes .tex
elif [[ $1 == *".tex"* ]]; then
    pdflatex $1
    bibtex `basename -s .tex $1`
    pdflatex $1
    pdflatex $1
    evince `basename -s .tex $1`.pdf &

    # Cleanup of extra files
    rm *.aux
    rm *.log
    rm *.bbl
    rm *.blg

    exit
fi

# Process input for other cases
pdflatex $1.tex
bibtex $1
pdflatex $1.tex
pdflatex $1.tex
evince $1.pdf &

# Cleanup of extra files
rm *.aux
rm *.log
rm *.bbl
rm *.blg

exit
