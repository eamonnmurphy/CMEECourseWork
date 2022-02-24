####### Graph pmf for Poisson ########
x <- 0:10
y <- dpois(x, lambda = 2)
plot(x, y, pch = 16, ylab = "pmf", xlab = "outcome")

# Pr (X = 4)
dpois(4, lambda = 2)

# Pr (X <= 3)
ppois(3, lambda = 2)
sum(dpois(0:3, lambda = 2))

# Simulate poisson random numbers
x <- rpois(1000, lambda = 2)
x
hist(x)

##### Plot pdf for exponential #######
x <- seq(0, 5, by = 0.01)
y <- dexp(x, rate = 2)
plot(x, y, pch = 16)

# Probablility of Pr(0 <= X <= 1) for X ~ Exponential(lambda = 2)
integrate(dexp, lower = 0, upper = 1, rate = 2)

##### Plot standard normal #####
x <- seq(-3, 3, by = 0.01)
y <- dnorm(x)
plot(x, y, pch = 16)

integrate(dnorm, lower = 2, upper = 3)
integrate(dnorm, lower = -1.96, upper = 1.96)

pnorm(3) - pnorm(2)
pnorm(1.96) - pnorm(-1.96)

##### Central Limit Theorem #######
y <- rnbinom(1000, 1, 0.2)
hist(y)


# Generate 30000 random negative binomial numbers and put them into a matrix
y <- matrix(rnbinom(100*1000, 1, 0.2), nr = 1000, nc = 100)

# Calculate row mean
y.row.mean <- apply(y, 1, mean)

# Plot their histogram
hist(y.row.mean)
