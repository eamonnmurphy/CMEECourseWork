binomial.likelihood <- function(p, n, r)
{
  choose(n, r) * p ^ (r) * (1-p) ^ (n-r)
}

binomial.likelihood(10, 7, 0.1)

p <- seq(0, 1, 0.01)
y <- binomial.likelihood(10, 7, p)
plot(p, y, type = "l")
y[which(x = max(y))]

###### Log likelihood ######'
log.binomial.likelihood <- function(n, r, p)
{
  log(choose(n, r) * p ^ (r) * (1-p) ^ (n-r))
}

p <- seq(0, 1, 0.01)
y <- log.binomial.likelihood(10, 7, p)
plot(p, y, type = "l")

###### Find maximums using optimize #######
optimise(binomial.likelihood(interval,10,7), interval = c(0,1), maximum = T)


####### Linear regression #########
# Read in dataset
recapture.data <- read.csv("../data/recapture.csv", header = T)

# Scatterplot
plot(recapture.data$day, recapture.data$length_diff)

regression.log.likelihood <- function(parm, dat)
{
  # Log likelihood function for linear regression
  # Parameters must be input as vector
  # Parameters are a, b and sigma
  a <- parm[1]
  b <- parm[2]
  sigma <- parm[3]
  
  # Define the data
  x <- dat[,1]
  y <- dat[,2]
  
  # Model on y, vectorised
  # Each y[i] is normally and indepenently distributed, with mean a+b*x[i]
  # and a common variance sigma^2
  density <- dnorm(y, mean = a + b*x, sd = sigma, log = T)
  
  # Log likelihood is sum of individual log-density
  return(sum(density))
}

# Optimise the log-likelihood function
s <- optim(par = c(1,1,1), regression.log.likelihood, method = "L-BFGS-B",
      lower = c(-1000, -1000, 0.0001), upper = c(1000,1000,10000),
      control = list(fnscale = -1), dat = recapture.data, hessian = T)

m <- lm(length_diff~day, data = recapture.data)
summary(m)

abline(s$par[1], s$par[2], add = T)

#### Poisson #####
poisson <- function(x)
{
  ((4^x) * (exp(-4))) / factorial(x)
}

x <- seq(0, 10, by = 1)
y <- poisson(x)
plot(x,y, type = "l")
