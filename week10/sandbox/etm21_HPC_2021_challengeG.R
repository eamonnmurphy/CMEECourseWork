# CMEE 2021 HPC excercises R code challenge G pro forma

rm(list=ls()) # nothing written elsewhere should be needed to make this work

# please edit these data to show your information.
name <- "Eamonn Murphy"
preferred_name <- "Eamonn"
email <- "etm21@ic.ac.uk"
username <- "etm21"

# don't worry about comments for this challenge - the number of characters used will be counted starting from here
f=\(x,y,d,l,a){if(l>.001){m=x+l*cos(d);n=y+l*sin(d);lines(c(x,m),c(y,n));f(m,n,d,.87*l,a*-1);f(m,n,d+a,.38*l,a)}};frame();f(.5,0,pi/2,.1,1)