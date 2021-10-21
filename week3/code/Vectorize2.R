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
  
  for (pop in 1:length(p0)) { #loop through the populations
      
      apply(N[yr, pop], 2, N[yr-1, pop] * exp(r * (1 - N[yr - 1, pop] / K) + rnorm(1, 0, sigma)))
    
  }

  # for (pop in 1:length(p0)) { #loop through the populations
  # 
  #   for (yr in 2:numyears){ #for each pop, loop through the years
  # 
  #     N[yr, pop] <- N[yr-1, pop] * exp(r * (1 - N[yr - 1, pop] / K) + rnorm(1, 0, sigma)) # add one fluctuation from normal distribution
  # 
  #   }
  # 
  # }
  return(N)
  
}

print("Vectorized Stochastic Ricker takes:")
print(system.time(res2<-stochrickvect()))