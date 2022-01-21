#!/usr/bin/env python3
"""Run an R script inside python with subprocess"""

__author__ = "Eamonn Murphy"
__version__ = "0.0.1"

import subprocess
subprocess.Popen("Rscript --verbose TestR.R > ../results/TestR.Rout 2> ../results/TestR_errFile.Rout", shell = True).wait()
