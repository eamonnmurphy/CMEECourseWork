# Read in dataset
recapture.data <- read.csv("../data/recapture.csv", header = T)

# Scatterplot
plot(recapture.data$day, recapture.data$length_diff)

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

b <- seq(0, 10, by = 0.1)
sigma <- seq(0.1, 10, by = 0.1)

log.likelihood.values <- matrix(nrow = length(b), ncol = length(sigma))

for (i in 1:length(b)) {
  for (j in 1:length(sigma))
  {
    log.likelihood.values[i,j] <- 
      m1.log.likelihood(parm = c(b[i], sigma[j]), dat = recapture.data)
  }
}

rel.log.likelihood.values <- log.likelihood.values - m1$value

persp(b, sigma, rel.log.likelihood.values, theta = 30, phi = 20, col = "grey")

contour(b, sigma, rel.log.likelihood.values, xlim = c(2.5,3.9), ylim = c(2,4.3),
        xlab = "b", ylab = "sigma",
        levels = c(-1:-5, -10), cex = 2)
points(m1$par[1], m1$par[2], pch = 3)

contour.line <- contourLines(b, sigma, rel.log.likelihood.values, levels = -2.99)[[1]]
lines(contour.line$x, contour.line$y, col = "red", lty = 2, lwd = 2)

##### Obtaining CI through Hessian matrix ######
# Obtain inverse of hessian to get variance-covariance matrix
var.cov.matrix <- (-1) * solve(m1$hessian)
var.cov.matrix

b_ci <- c(m1$par[1] + 1.96 * sqrt(var.cov.matrix[1,1]),
          m1$par[1] - 1.96 * sqrt(var.cov.matrix[1,1]))
sigma_ci <- c(m1$par[2] + 1.96 * sqrt(var.cov.matrix[2,2]),
              m1$par[2] - 1.96 * sqrt(var.cov.matrix[2,2]))


####### Bernoulli CI estimation #######
bernoulli.log.likelihood <- function(p, n = 50, r = 35)
{
  log(choose(n, r) * (p ^ r) * (1-p) ^ (n - r))
}
best <- optim(p = .5, bernoulli.log.likelihood, method = "Brent", hessian = T,
              lower = 0, upper = 1, control = list(fnscale = -1))

p <- seq(0.5, 0.9, 0.01)

bernoulli.log.values <- bernoulli.log.likelihood(p, 50, 35)
relative.log.values <- bernoulli.log.values - best$value
plot(p, relative.log.values, type = "l")
abline(h = -1.92, col = "red", lty = 2)

relative <- function(p)
{
  bernoulli.log.likelihood(p) - bernoulli.log.likelihood(0.7) + 1.92
}

# Find the roots
upper <- uniroot(relative, interval = c(0.7,0.9))
lower <- uniroot(relative, interval = c(0.5, 0.7))

abline(v = upper$root, col = "red", lty = 2)
abline(v = lower$root, col = "red", lty = 2)

i = 1
while (i <= length(p)) {
  if (relative.log.values[i] > -1.92) {
    print(p[i])
    break
  }
  i = i + 1
}

i = 101
while (i >= 1) {
  if (relative.log.values[i] > -1.92) {
    print(p[i])
    break
  }
  i = i - 1
}

inverse_hessian <- (-1) * solve(best$hessian)

large_sample_p_CI <- c(0.7 - 1.96 * sqrt(inverse_hessian),
          0.7 + 1.96 * sqrt(inverse_hessian))

bernoulli.log.likelihood <- function(p, n = 10, r = 7)
{
  log(choose(n, r) * (p ^ r) * (1-p) ^ (n - r))
}
best <- optim(p = .5, bernoulli.log.likelihood, method = "Brent", hessian = T,
              lower = 0, upper = 1, control = list(fnscale = -1))

p <- seq(0, 1, 0.01)

bernoulli.log.values <- bernoulli.log.likelihood(p)
relative.log.values <- bernoulli.log.values - best$value
plot(p, relative.log.values, type = "l")
abline(h = -1.92, col = "red", lty = 2)

inverse_hessian <- (-1) * solve(best$hessian)

small_sample_p_CI <- c(0.7 - 1.96 * sqrt(inverse_hessian),
                       0.7 + 1.96 * sqrt(inverse_hessian))

