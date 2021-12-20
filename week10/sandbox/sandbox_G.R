# CMEE 2021 HPC excercises R code challenge G pro forma

rm(list=ls()) # nothing written elsewhere should be needed to make this work

# please edit these data to show your information.
name <- "Eamonn Murphy"
preferred_name <- "Eamonn"
email <- "etm21@ic.ac.uk"
username <- "etm21"

# don't worry about comments for this challenge - the number of characters used will be counted starting from here
f=\(x,y,d,l,a=1){m=x+l*cos(d);n=y+l*sin(d);if(l>.002)lines(c(x,m),c(y,n))&f(m,n,d,.9*l,-a)&f(m,n,d+a,.4*l)};frame();f(0,.5,0,.1)