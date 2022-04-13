#### Questions for practical 3 ###### 
# Length of alignment in bp
n  <- 948
# Total number of transitions (23+30+10+21)
ns <- 84
# Total number of transversions (1+0+2+0+2+1+0+0)
nv <- 6

# Define log-likelihood function, f(D|d,k).
# This uses Kimura's (1980) substitution model. See p.8 in Yang (2014).
#
# Arguments:
#
#   d  Numeric, value for the distance.
#   k  Numeric, value for parameter kappa.
#   n  Numeric, length of the alignment. Default: 948.
#   ns Numeric, total number of transitions. Default: 84.
#   nv Numeric, total number of transcersions. Default: 6.
k80.lnL <- function( d, k, n = 948, ns = 84, nv = 6 ) {

# Define probabilities
p0 <- .25 + .25 * exp( -4*d/( k+2 ) ) + .5 * exp( -2*d*( k+1 )/( k+2 ) )
p1 <- .25 + .25 * exp( -4*d/( k+2 ) ) - .5 * exp( -2*d*( k+1 )/( k+2 ) )
p2 <- .25 - .25 * exp( -4*d/( k+2 ) )

# Return log-likelihood
return ( ( n - ns - nv ) * log( p0/4 ) +
     ns * log( p1/4 ) + nv * log( p2/4 ) )

}

# Number of values that we want to collect for 
# each parameter of interest
dim <- 100
# Vector of `d` values
d.v <- seq( from = 0, to = 0.3, len = dim )
# Vector of `k` values
k.v <- seq( from = 0, to = 100, len = dim )
# Define grid where we will save all possible 
# combinations with the 100 values of `d` and 
# the 100 values of `k`
dk  <- expand.grid( d = d.v, k = k.v )

# Compute likelihood surface, f(D|d,k)
lnL <- matrix( k80.lnL( d = dk$d, k = dk$k ), ncol = dim )

# For numerical reasons, we scale the likelihood to be 1
# at the maximum, i.e., we subtract max(lnL)
L <- exp( lnL - max( lnL ) )

# Compute prior surface, f(D)f(k)
Pri <- matrix( dgamma( x = dk$d, shape = 2, rate = 20 ) *
                 dgamma( x = dk$k, shape = 2, rate = .1 ),
               ncol = dim )


# Compute unnormalised posterior surface, f(d)f(k)f(D|d,k)
Pos <- Pri * L

# Plot prior, likelihood, and unnormalised posterior surfaces.
# We want one row and three columns.
par( mfrow = c( 1, 3 ) )
# Prior surface. Note that the `contour()` function creates a contour plot.
image( x = d.v, y = k.v, z = -Pri, las = 1, col = heat.colors( 50 ),
       main = "Prior", xlab = "distance, d",
       ylab = "kappa, k", cex.main = 2.0,
       cex.lab = 1.5, cex.axis = 1.5 )
contour( x = d.v, y = k.v, z = Pri, nlev=10, drawlab = FALSE, add = TRUE )
# Likelihood surface + contour plot.
image( x = d.v, y = k.v, z = -L, las = 1, col = heat.colors( 50 ),
       main = "Likelihood", xlab = "distance, d",
       ylab = "kappa, k", cex.main = 2.0,
       cex.lab = 1.5, cex.axis = 1.5 )
contour( x = d.v, y = k.v, z = L, nlev = 10,
         drawlab = FALSE, add = TRUE)
# Unnormalised posterior surface + contour plot.
image( x = d.v, y = k.v, z = -Pos, las = 1, col = heat.colors( 50 ),
       main = "Posterior", xlab = "distance, d",
       ylab = "kappa, k", cex.main = 2.0,
       cex.lab = 1.5, cex.axis = 1.5 )
contour( x = d.v, y = k.v, z = Pos, nlev = 10,
         drawlab = FALSE, add = TRUE )


# Define function that returns the logarithm of the unnormalised posterior:
#                             f(d) * f(k) * f(D|d,k)
# By, default we set the priors as:
#                  f(d) = Gamma(d | 2, 20) and f(k) = Gamma(k | 2, .1)
#
# Arguments:
#
#   d     Numeric, value for the distance.
#   k     Numeric, value for parameter kappa.
#   n     Numeric, length of the alignment. Default: 948.
#   ns    Numeric, total number of transitions. Default: 84.
#   nv    Numeric, total number of transcersions. Default: 6.
#   a.d.  Numeric, alpha value of the Gamma distribution that works as a prior
#         for the distance (d). Default: 2.
#   b.d.  Numeric, beta value pf the Gamma distribution that works as a prior
#         for parameter distance (d). Default: 20.
#   a.k.  Numeric, alpha value for the Gamma distribution that works as a prior
#         for parameter kappa (k). Default: 2.
#   b.k.  Numeric, beta value for the Gamma distribution that works as a prior
#         for parameter kappa (k). Default: 0.1.
ulnPf <- function( d, k, n = 948, ns = 84, nv = 6,
                   a.d = 2, b.d = 20, a.k = 2, b.k = .1 ){
  
  # The normalising constant in the prior densities can be ignored
  lnpriord <- ( a.d - 1 )*log( d ) - b.d * d
  lnpriork <- ( a.k - 1 )*log( k ) - b.k * k
  
  # Define log-likelihood (K80 model)
  expd1 <- exp( -4*d/( k+2 ) )
  expd2 <- exp( -2*d*( k+1 )/( k+2 ) )
  p0 <- .25 + .25 * expd1 + .5 * expd2
  p1 <- .25 + .25 * expd1 - .5 * expd2
  p2 <- .25 - .25 * expd1
  lnL <- ( ( n - ns - nv ) * log( p0/4 ) + ns * log( p1/4 ) + nv * log( p2/4 ) )
  
  # Return unnormalised posterior (they are lnL, so 
  # you return their sum!)
  return ( lnpriord + lnpriork + lnL )
}

# Define function with MCMC algorithm.
#
# Arguments:
#
#   init.d  Numeric, initial state value for parameter d.
#   init.k  Numeric, initial state value for paramter k.
#   N       Numeric, number of iterations that the MCMC will run.
#   w.d     Numeric, width of the sliding-window proposal for d.
#   w.k     Numeric, width of the sliding-window proposal for k.
mcmcf <- function( init.d, init.k, N, w.d, w.k ) {
  
  # We keep the visited states (d, k) in sample.d and sample.k
  # for easy plotting. In practical MCMC applications, these
  # are usually written into a file. These two objects are numeric
  # vectors of length N+1.
  sample.d <- sample.k <- numeric( N+1 )
  
  # STEP 1: Set initial parameter values to be used during the first
  #         iteration of the MCMC.
  # 1.1. Get initial values for parameters k and d. Save these values
  #      in vectors sample.d and sample.k
  d <- init.d;  sample.d[1] <- init.d
  k <- init.k;  sample.k[1] <- init.k
  # 1.2. Get unnormalised posterior
  ulnP  <- ulnPf( d = d, k = k )
  # 1.3. Initialise numeric vectors that will be used to keep track of
  #      the number of times proposed values for each parameter,
  #      d and k, have been accepted
  acc.d <- 0; acc.k <- 0
  # 1.4. Start MCMC, which will run for N iterations
  for ( i in 1:N ){
    
    # STEP 2: Propose a new state d*.
    # We use a uniform sliding window of width w with reflection
    # to propose new values d* and k*
    # 2.1. Propose d* and accept/reject the proposal
    dprop <- d + runif( n = 1, min = -w.d/2, max = w.d/2 )
    # 2.2. Reflect if dprop is negative
    if ( dprop < 0 ) dprop <- -dprop
    # 2.3. Compute unnormalised posterior
    ulnPprop <- ulnPf( d = dprop, k = k )
    lnalpha  <- ulnPprop - ulnP
    
    # STEP 3: Accept or reject the proposal:
    #            if ru < alpha accept proposed d*
    #            else reject and stay where we are
    if ( lnalpha > 0 || runif( n = 1 ) < exp( lnalpha ) ){
      d      <- dprop
      ulnP   <- ulnPprop
      acc.d  <- acc.d + 1
    }
    
    # STEP 4: Repeat steps 2-3 to propose a new state k*.
    # 4.1. Propose k* and accept/reject the proposal
    kprop <- k + runif( n = 1, min = -w.k/2, max = w.k/2 )
    # 4.2. Reflect if kprop is negative
    if ( kprop < 0 ) kprop <- -kprop
    # 4.3. Compute unnormalised posterior
    ulnPprop <- ulnPf( d = d, k = kprop )
    lnalpha  <- ulnPprop - ulnP
    # 4.4. Accept/reject proposal:
    #          if ru < alpha accept proposed k*
    #          else reject and stay where we are
    if ( lnalpha > 0 || runif( n = 1 ) < exp( lnalpha ) ){
      k     <- kprop
      ulnP  <- ulnPprop
      acc.k <- acc.k + 1
    }
    
    # STEP 5: Save chain state for each parameter so we can later
    #         plot the corresponding histograms
    sample.d[i+1] <- d
    sample.k[i+1] <- k
  }
  
  # Print out the proportion of times
  # the proposals were accepted
  cat( "Acceptance proportions:\n", "d: ", acc.d/N, " | k: ", acc.k/N, "\n" )
  
  # Return vector of d and k visited during MCMC
  return( list( d = sample.d, k = sample.k ) )
  
}

set.seed( 12345 )

# Test run-time
system.time( mcmcf( init.d = 0.2, init.k = 20, N = 1e4,
                    w.d = 0.12, w.k = 180 ) )

# Run MCMC and save output
dk.mcmc <- mcmcf( init.d = 0.2, init.k = 20, N = 1e4,
                  w.d = 0.12, w.k = 180 )

# Plot traces of the values sampled for each parameter
par( mfrow = c( 1,3 ) )
# Plot trace for parameter d
plot( x = dk.mcmc$d, ty = 'l', xlab = "Iteration",
      ylab = "d", main = "Trace of d" )
# Plot trace for parameter k
plot( x = dk.mcmc$k, ty = 'l', xlab = "Iteration",
      ylab = "k", main = "Trace of k" )
# Plot the joint sample of d and k (points sampled from posterior surface)
plot( x = dk.mcmc$d, y = dk.mcmc$k, pch = '.', xlab = "d",
      ylab = "k", main = "Joint of d and k" )

####### Question One #####
new.mcmc <- mcmcf(init.d = 0.4, init.k = 40, N = 1e4,
                  w.d = 0.12, w.k = 180)

# Plot traces of the values sampled for each parameter
par( mfrow = c( 1,3 ) )
# Plot trace for parameter d
plot( x = new.mcmc$d, ty = 'l', xlab = "Iteration",
      ylab = "d", main = "Trace of d" )
# Plot trace for parameter k
plot( x = new.mcmc$k, ty = 'l', xlab = "Iteration",
      ylab = "k", main = "Trace of k" )
# Plot the joint sample of d and k (points sampled from posterior surface)
plot( x = new.mcmc$d, y = dk.mcmc$k, pch = '.', xlab = "d",
      ylab = "k", main = "Joint of d and k" )


# Run n=1e6 iterations
dk.mcmc2 <- mcmcf( init.d = 0.2, init.k = 20, N = 1e6,
                   w.d = .12, w.k = 180 )
# Plot ACF for each parameter
par( mfrow = c( 1,2 ) )
acf( x = dk.mcmc2$d )
acf( x = dk.mcmc2$k )


# Define efficiency function
#
# Arguments:
#  acf  Numeric, autocorrelation value
eff <- function( acf ) 1 / ( 1 + 2 * sum( acf$acf[-1] ) )

# Compute efficiency
eff( acf = acf( dk.mcmc2$d ) )
eff( acf = acf( dk.mcmc2$k ) )


dk.mcmc3 <- mcmcf( init.d = 0.2, init.k = 20, N = 1e4,
           w.d = 3, w.k = 5 )


# Plot traces for each parameter.
par( mfrow = c( 1,2 ) )
plot( x = dk.mcmc3$d, ty = 'l', main = "Trace of d", cex.main = 2.0,
cex.lab = 1.5, cex.axis = 1.5, ylab = "d" )
plot( x = dk.mcmc3$k, ty = 'l', main = "Trace of k", cex.main = 2.0,
cex.lab = 1.5, cex.axis = 1.5, ylab = "k" )


# Run MCMC
dk.mcmc4 <- mcmcf( init.d = 0.2, init.k = 20, N = 1e6,
           w.d = 3, w.k = 5 )
# Compute efficiency values
eff( acf = acf( dk.mcmc4$d, lag.max = 2e3 ) )
eff( acf = acf( dk.mcmc4$k, lag.max = 2e3 ) )
# Plot the traces for efficient (part 2) and inefficient chains.
par( mfrow = c( 2,2 ) )
plot( dk.mcmc$d, ty = 'l', las = 1, ylim = c( .05,.2 ),
main = "Trace of d, efficient chain", xlab = '',
ylab = "Distance, d", cex.main = 2.0, cex.lab = 1.5 )
plot( dk.mcmc3$d, ty = 'l', las = 1, ylim = c( .05,.2 ),
main = "Trace of d, inefficient chain", xlab='',
ylab = '', cex.main = 2.0, cex.lab = 1.5 )
plot( dk.mcmc$k, ty = 'l', las = 1, ylim = c( 0,100 ),
main = "Trace of k, efficient chain",
xlab = '', ylab = "ts/tv ratio, k",
cex.main = 2.0, cex.lab = 1.5 )
plot( dk.mcmc3$k, ty = 'l', las = 1, ylim = c( 0,100 ),
main = "Trace of k, inefficient chain",
xlab = '', ylab = '', cex.main = 2.0, cex.lab = 1.5 )

# Run MCMCs with high/low starting values for parameters d and k.
dk.mcmc.l <- mcmcf( init.d = 0.01, init.k = 20, N = 1e4,
            w.d = .12, w.k = 180 )
dk.mcmc.h <- mcmcf( init.d = 0.4, init.k = 20, N = 1e4,
            w.d = .12, w.k = 180 )
```

Now, we can compute the mean and the standard deviation of parameter d.
Below, we show you how this can be done when using the "low" chain, although we could 
have used the "high" chain too: 

```{r}
# Compute mean and sd for d
mean.d <- mean( dk.mcmc.l$d )
sd.d   <- sd( dk.mcmc.l$d )
```

Now, we can plot the two chains, "low" and "high", to observe how the chains 
move from either the high or low starting values towards the  
stationary phase (the area within the dashed lines). The area before it 
reaches stationarity is what we call the "burn-in" phase: 

```{r}
# Plot the two chains 
plot( dk.mcmc.l$d, xlim = c( 1,200 ), ylim = c( 0,0.4 ), ty = "l" )
lines( dk.mcmc.h$d, col = "red" )
# Plot a horizontal dashed line to indicate (approximately)
# the 95% CI.
abline( h = mean.d + 2 * c( -sd.d, sd.d ), lty = 2 )
```

## Example 2 
We are going to run two chains with different starting values so 
we can compare their efficiency: 

```{r}
# Run an efficient chain (i.e., good proposal step sizes)
dk.mcmc.b <- mcmcf( init.d = 0.05, init.k = 5, N = 1e4,
            w.d = .12, w.k = 180 )
# Run an inefficient chain (i.e., bad proposal step sizes)
dk.mcmc3.b <- mcmcf( init.d  = 0.05, init.k = 5, N = 1e4,
             w.d = 3, w.k = 5 )
# Plot and compare histograms
# Set breaking points for the plot
bks <- seq(from=0, to=150, by=1)
# Start plotting
par( mfrow = c( 1,2 ) )
hist( x = dk.mcmc.b$k, prob = TRUE, breaks = bks, border = NA,
col = rgb( 0, 0, 1, .5 ), las = 1, xlab = "kappa",
xlim = c( 0,100 ), ylim = c( 0,.055 ) )
hist( x = dk.mcmc$k, prob=TRUE, breaks=bks, border=NA,
col=rgb(.5, .5, .5, .5), add=TRUE)
hist( x = dk.mcmc3.b$k, prob=TRUE, breaks=bks, border=NA,
col=rgb(0, 0, 1, .5), las=1, xlab="kappa",
xlim=c(0,100), ylim=c(0,.055))
hist( x = dk.mcmc3$k, prob=TRUE, breaks=bks, border=NA,
col=rgb(.5, .5, .5, .5), add=TRUE)
```

Now, as we did in the previous example, we will compute the mean and 
the standard deviation for each chain. Then, we will plot the 
corresponding densities so it is easier to see which chains 
are more or less efficient:

```{r}
# A) Calculate the posterior means and s.d for each chain.
# Compute means for efficient chains (they are quite similar)
mean( dk.mcmc$d ); mean( dk.mcmc.b$d )
mean( dk.mcmc$k ); mean( dk.mcmc.b$k )
# Compute means for inefficient chains (not so similar)
mean( dk.mcmc3$d ); mean( dk.mcmc3.b$d )
mean( dk.mcmc3$k ); mean( dk.mcmc3.b$k )
# Standard error of the means for efficient chains
sqrt( 1/1e4 * var( dk.mcmc$d ) / 0.23 ) # roughly 2.5e-4
sqrt( 1/1e4 * var( dk.mcmc$k ) / 0.20 ) # roughly 0.2
# Standard error of the means for inefficient chain
sqrt( 1/1e4 * var( dk.mcmc3$d ) / 0.015 ) # roughly 9.7e-4
sqrt( 1/1e4 * var( dk.mcmc3$k ) / 0.003 ) # roughly 1.6
# B) Plot densities (smoothed histograms) for the efficient and
#    inefficient chains.
# Set value to scale the kernel densities for the MCMCs
adj <- 1.5
par( mfrow = c( 1,2 ) )
# Efficient chains
plot( x = density( x = dk.mcmc.b$k, adjust = adj ), col = "blue", las = 1,
xlim  = c( 0, 100 ), ylim = c( 0, .05 ), xaxs = "i", yaxs = "i" )
lines( x = density( x = dk.mcmc$k, adjust = adj ), col = "black" )
# Inefficient chains
plot( x = density( dk.mcmc3.b$k, adjust = adj ), col = "blue", las = 1,
xlim = c(0, 100), ylim = c( 0, .05 ), xaxs = "i", yaxs = "i" )
lines( x = density( x = dk.mcmc3$k, adjust = adj ), col = "black" )
```

######## JAGS ######
rm(list = ls())
