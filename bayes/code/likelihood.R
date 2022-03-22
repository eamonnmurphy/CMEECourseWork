dbinom(3, 8, 0.375)

#prob <- seq(0, 1, by = 0.01)

f <- function(prob)
{
  dbinom(90, 100, prob)
}

optimise(f, c(0,1), maximum = T)

prob <- seq(0.001,0.999, by = 0.001)

likelihood <- rep(NA, length(prob))

for (i in 1:length(prob))
{
  likelihood[i] <- f(prob[i])
}

plot(prob, likelihood, type = "l")
