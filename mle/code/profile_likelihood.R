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

m2 <- optim(par = c(0,0,0,0), logistic.log.likelihood.int,
            dat = flowering, control = list(fnscale=-1),
            hessian = T)
m2

D <- 2*(m2$value - m1$value)
D

qchisq(0.95, df = 1)

# Create a profile log likelihood for b
profile.log.likelihood <- function(b)
{
  f <- function(parm_acd)
  {
    logistic.log.likelihood.int(c(parm_acd[1], b, parm_acd[2], parm_acd[3]),
                                dat = flowering)
  }
  temp <- optim(c(0,0,0), f, control = list(fnscale = -1))
  return(temp$value)
}

profile.log.likelihood(b = - 0.03)

b <- seq(-0.19, -0.004, 0.002)
profile.log.likelihood.value <- rep(NA, length(b))
for (i in 1:length(b))
{
  profile.log.likelihood.value[i] <- profile.log.likelihood(b[i])
}

plot(b, profile.log.likelihood.value, type = "l")

abline(h = m2$value - 1.92, col = "red", lty = 2)


# 95% CI through assuming normality
inverse_hessian <- (-1) * solve(m2$hessian)

CI_b <- c(m2$par[2] - 1.96 * sqrt(inverse_hessian[2,2]),
          m2$par[2] + 1.96 * sqrt(inverse_hessian[2,2]))
