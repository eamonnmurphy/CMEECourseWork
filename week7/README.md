## Week Seven
This subdirectory contains work completed for week 7 of CMEE MSc Course, Biological Computing in Python II. Topics include use of the numpy and scipy packages, using subprocess to run other languages via Python, and Jupyter Notebooks. More detailed usage instructions are available in the main repository README. This code was written in Python 3.8.10.

### Dependencies and packages
* jupyter-notebook version 6.4.6
* matplotlib 3.1.2
* scipy 1.3.3
* subprocess
* numpy 1.17.4
* sys
* csv
* doctest
* timeit
* time

### Code files
Scripts are contained in **code** directory.

#### In-class scripts
* MyFirstJupyterNb.ipynb - Jupyter notebook example
* profileme.py - Some example functions to profile
* profileme2.py - Faster example functions
* TestR.py - Python script running R via subprocess
* TestR.R - Test R file
* timeitme.py - Times profileme and profileme2 from above

#### Practical scripts
* LV1.py - Generate graphs for the Lotka-Volterra model
* oaks_debugme.py - Reads a list of species names and return only the oaks

#### Groupwork scripts
* group_oaks_debugme.py - Improvements to the output of the oaks finder script

### Data files
* TestOaksData.csv - List of species names
* JustOaksData.csv - Cleaned species names with oaks only