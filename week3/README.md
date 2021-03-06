## Week Three

This subdirectory contains work completed for week 3 of the CMEE MSc Course, Biological Computing in R. Topics include data wrangling and visualisation, vectorisation, debugging and R basics. More detailed usage instructions are available in the main repository README. Language and package versions are listed below, where available.

This subdirectory differs slightly from the normal structure, in that there is also a writeup directory. This contains pdf documents for the correlation analysis on the temperature data for Florida, for both the individual analysis and the groupwork autocorrelation analysis. Source code LaTeX files are available in the code directory.
***
### Languages and Packages
#### Languages
* Bash 5.0.17
* Python 3.8.10
  * sys
  * numpy 1.17.4
  * pandas 0.25.3
  * os
* R version 4.1.1
  * ggplot2 3.3.5
  * reshape2 1.4.4
  * tidyverse 1.3.1
  * tidyr 1.1.4
  * dplyr 1.0.7
  * maps 3.4.0
  * plyr 1.8.6
  * broom 0.7.10
* LaTeX - TeX Live 2019/Debian
***
### Code
#### In-class scripts for Biological Computing in R chapter
* basic_io.R
* control_flow.R
* break.R
* next.R
* boilerplate.R
* R_conditionals.R
* TreeHeight.R
* Vectorize1.R
* preallocate.R
* apply1.R
* apply2.R
* sample.R
* browse.R
* try.R

#### Biological Computing in R practical scripts
* TreeHeight.R - calculate a tree's height based on angle and distance
* Ricker.R - pop model to model recruitment of stock in fisheries
* Vectorize2.R - attempt to vectorise the stochastic Ricker model
* Florida.R - calculate correlation between year and temp in Florida
* Florida.tex - LaTeX writeup of the above results
* Florida.bib - references for LaTex writeup

#### Data Management and Visualisation in-class scripts
* DataWrang.R
* Girko.R
* MyBars.R
* plotLin.R

#### Practical scripts for Data Management and Visualisation
* DataWrangTidy.R - data wrangling using the tidyverse
* PP_Dists.R - plots mass distributions for a dataset of predator prey interactions
* PP_Regress.R - as above, but calculates a regression model and best fit
* GPDD_Data.R - create a world map using maps package

#### Groupwork scripts
* Floridabiblio.bib - bibliography file for LaTeX document
* get_TreeHeight.R - takes csv of measurements and outputs tree heights to a new file
* get_TreeHeight.py - as above, but a Python implementation
* PP_Regress_loc.R - runs a regression on pred-prey interactions, seperated by 3 factors including location
* TAutoCorr.R - calculates autocorrelation of temperature in Florida and runs permutation test
* TAutoCorr.tex - LaTeX document summarises results of analysis
* run_get_TreeHeight.sh - runs and test R and python scripts
***
### Data
* EcolArchives-E089-51-D1.csv - predator prey interactions dataset
* KeyWestAnnualMeanTemperature.Rdata - temp data for Key West from 1900-2000
* PoundHillMetaData.csv - information about the PoundHill dataset
* trees.csv - measurements from which tree height can be calculated
* GPDDFiltered.Rdata - Rdata file containing geographical data
* PoundHillData.csv - dataset of cultivation treatments
* Results.txt - example results to plot

