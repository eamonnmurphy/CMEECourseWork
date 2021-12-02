#!/bin/bash
# Desc: Runs MiniProject and compiles LaTeX report

python3 add_ids.py

Rscript Rexplore.R

Rscript ModelFitting.R

latexmk -pdf -output-directory="../results/" ../writeup/main.tex