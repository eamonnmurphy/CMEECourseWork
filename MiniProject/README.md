# MiniProject Directory
Contains scripts and data for the Computing Miniproject. A number of linear and non-linear models were fit to a bacterial growth dataset, and a LaTeX report was written about the findings.

## Computing tools
Languages: Bash, Python, R

Dependencies:
* R:
    * ggplot2
    * minpack.lm
    * AICcmodavg
* Python:
        * pandas

## Code files
In code directory
* add_ids.py - Basic data cleaning
* Rexplore.R - Further data cleaning and exploration
* ModelFitting.R - Fitting linear and non-linear models to the dataset
* Plotting.R - Generation of figures for the report
* run_MiniProject.sh - Run all the scripts and generate outputs, and compile LaTeX

## Writeup
In writeup directory.
Main.tex - Final LaTeX report for the MiniProject submission

## Data
In data directory
* LogisticGrowthData.csv - Original dataset
* LogisticGrowthMetaData.csv - Explanation of each data column in above
* EditedDataSet.csv - First data cleaning, including adding IDs
* WrangledDataSet.csv - Final dataset, ready for analysis