#!/bin/bash
# Desc: Create pdf from LaTeX script and .bib file
# Arguments: LaTeX script name

# Process input if it includes .tex
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
