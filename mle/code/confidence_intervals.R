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

contour.line <- contourLines(b, sigma, rel.log.likelihood.values, levels = -1.91)[[1]]
lines(contour.line$x, contour.line$y, col = "red", lty = 2, lwd = 2)
