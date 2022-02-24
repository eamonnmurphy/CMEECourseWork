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

m1.log.likelihood <- function(parm,dat)
{
 # Log likelihood function for linear regression with 0 intercept
  # Params input as vector
  # Parameters are b and sigma
  b <- parm[1]
 sigma <- parm[2]
 
 # Define the data
 x <- dat[,1]
 y <- dat[,2]
 
 density <- dnorm(y, mean = b*x, sd = sigma, log = T)
 
 return(sum(density))
}

m1 <- optim(par=c(1,1), m1.log.likelihood,
            dat = recapture.data, method = "L-BFGS-B",
            lower = c(-1000,0.0001), upper = c(1000,10000),
            control = list(fnscale=-1), hessian = T)
m2 <- optim(par=c(1,1,1), regression.log.likelihood,
            dat = recapture.data, method = "L-BFGS-B",
            lower = c(-1000,-1000,0.0001), upper = c(1000,1000,10000),
            control = list(fnscale=-1), hessian = T)

D <- 2*(m2$value-m1$value)
D

qchisq(0.95, df = 1)

####### Non constant variance ######
regression.non.constant.var.log.likelihood <- function(parm,dat)
{
  b <- parm[1]
  sigma <- parm[1]
  
  x <- dat[,1]
  y <- dat[,2]
  
  error.term <- (y-b*x)
  
  density <- dnorm(error.term, mean = 0, sd = x*sigma, log = T)
  
  return(sum(density))
}

m3 <- optim(par=c(1,1), regression.non.constant.var.log.likelihood,
            dat = recapture.data, method = "L-BFGS-B",
            lower = c(-1000,0.0001), upper = c(1000,10000),
            control = list(fnscale=-1), hessian = T)

D <- 2*(m3$value - m1$value)
D

###### Practical question 4 ######
flowering <- read.table("../data/flowering.txt", header = T)
names(flowering)

par(mfrow = c(1,2))
plot(flowering$Flowers, flowering$State)
plot(flowering$Root, flowering$State)

logistic.log.likelihood <- function(parm, dat)
{
  # Define parameters
  a <- parm[1]
  b <- parm[2]
  c <- parm[3]
  
  # Define response variable, first column of dat
  state <- dat[,1]
  
  # Define explanatory variables
  flowers <- dat[,2]
  root <- dat[,3]
  
  # Model success prob, using expit transform
  p <- exp(a + b*flowers + c*root) / (1 + exp(a + b*flowers + c*root))
  
  log.like <- sum(state*log(p) + (1-state) * log(1-p))
  
  return(log.like)
}

logistic.log.likelihood(c(0,0,0), dat = flowering)

m1 <- optim(par = c(0,0,0), logistic.log.likelihood,
            dat = flowering, control = list(fnscale=-1),
            hessian = T)
m1

logistic.log.likelihood.int <- function(parm, dat)
{
  # Define parameters
  a <- parm[1]
  b <- parm[2]
  c <- parm[3]
  d <- parm[4]
  
  # Define response variable, first column of dat
  state <- dat[,1]
  
  # Define explanatory variables
  flowers <- dat[,2]
  root <- dat[,3]
  
  # Model success prob, using expit transform
  p <- exp(a + b*flowers + c*root + d*root*flowers) / 
    (1 + exp(a + b*flowers + c*root + d*root*flowers))
  
  log.like <- sum(state*log(p) + (1-state) * log(1-p))
  
  return(log.like)
}

m2 <- optim(par = c(0,0,0,0), logistic.log.likelihood,
            dat = flowering, control = list(fnscale=-1),
            hessian = T)
m2

D <- 2*(m2$value - m1$value)
D

qchisq(0.95, df = 1)

###### Confidence interval estimation #######
integr