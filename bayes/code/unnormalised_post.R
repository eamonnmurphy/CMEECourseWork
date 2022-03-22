rm(list = ls())

####### Predefined #####
# Likelihood function under the JC69 model
L_d <- function(d, x, n){
  return( (3/4 - 3*exp(-4*d/3)/4)ˆx * (1/4 + 3*exp(-4*d/3)/4)ˆ(n - x) )
}
# Prior function on my parameter of interest.
# We will assume that an exponential distribution
# fits best and that the mean will be 0.2
prior_d <- function(d, mu){
  return( exp(-d/mu) / mu )
}

######### Question One ######