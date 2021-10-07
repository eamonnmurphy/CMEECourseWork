#!/bin/bash
pdflatex $1
bibtex $(basename -s "$1")
pdflatex $1
pdflatex $1
evince $(basename -s "$1").pdf &

## Cleanup
rm *.aux
rm *.log
rm *.bbl
rm *.blg