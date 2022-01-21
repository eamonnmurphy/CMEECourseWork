# Runs the stochastic Ricker equation with gaussian fluctuations

rm(list = ls())

stochrick <- function(p0 = runif(1000, .5, 1.5), r = 1.2, K = 1, sigma = 0.2, numyears = 100)
{
  # p0 = 1000 uniformly distributed numbers from .5 to 1.5 for starting population size
  # r = growth rate
  # K = carrying capacity of environment
  # sigma = number of standard deviations
  # numyears = generations
  
  N <- matrix(NA, numyears, length(p0))  #initialize empty matrix

  N[1, ] <- p0
  
  for (pop in 1:length(p0)) { #loop through the populations

    for (yr in 2:numyears){ #for each pop, loop through the years

      N[yr, pop] <- N[yr-1, pop] * exp(r * (1 - N[yr - 1, pop] / K) + rnorm(1, 0, sigma)) # add one fluctuation from normal distribution
    
     }
  
  }
 return(N)

}

set.seed(123)

print("Stochastic Ricker takes:")
print(system.time(res1<-stochrick()))

# Now write another function called stochrickvect that vectorizes the above to
# the extent possible, with improved performance:

stochrickvect <- function(p0 = runif(1000, .5, 1.5), r = 1.2, K = 1, sigma = 0.2, numyears = 100)
{
  # p0 = 1000 uniformly distributed numbers from .5 to 1.5 for starting population size
  # r = growth rate
  # K = carrying capacity of environment
  # sigma = number of standard deviations
  # numyears = generations
  
  N <- matrix(NA, numyears, length(p0))  #initialize empty matrix
  
  N[1, ] <- p0
  
  # Pregenerate the random fluctuations to be added to every year except the first
  # Hence it is numyears - 1
  randoms <- matrix(rnorm(length(p0) * (numyears - 1), 0, sigma), numyears - 1, length(p0))
  
  for (yr in 2:numyears){ # Loop through the years
      # Use vectorised approach to loop through populations with [,]
      N[yr, ] <- N[yr-1, ] * exp(r * (1 - N[yr - 1, ] / K) + randoms[yr - 1, ]) # add one fluctuation from normal distribution
      
  }
  
  return(N)
  
}

set.seed(123)

print("Vectorized Stochastic Ricker takes:")
print(system.time(res2<-stochrickvect()))