#!/bin/bash

if [[ $1 == *".tex"* ]]; then
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