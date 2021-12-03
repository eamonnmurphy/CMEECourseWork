#!/bin/bash
# Desc: Runs MiniProject and compiles LaTeX report

python3 add_ids.py

Rscript Rexplore.R

Rscript ModelFitting.R

mkdir ../results/scatterplots

Rscript Plotting.R

cd ../writeup

texcount -1 -sum=1,2 main.tex > main-words.sum

#latexmk -pdf -output-directory="../results/" ../writeup/main.tex

# Process input for other cases
pdflatex main.tex
bibtex main
pdflatex main.tex
pdflatex main.tex

# Cleanup of extra files
rm *.aux
rm *.log
rm *.bbl
rm *.blg
rm *.bcf
rm *.run.xml