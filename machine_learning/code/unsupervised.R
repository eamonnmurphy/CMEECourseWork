#### Generate data ########
library("mvtnorm")
set.seed(123)
covariance <- matrix(c(5,3,0,-3,0, 3,5,0,-3,0, 0,0,5,0,0,
                       -3,-3,0,6,0, 0,0,0,0,3), nrow=5)
data <- rmvnorm(1000, sigma=covariance)
names(data) <- c("a", "b", "c", "d", "e")

# Draw species' parameters
intercepts <- rnorm(20, mean=20)
env1 <- rnorm(20)
env2 <- rnorm(20)

# Create environment
env <- expand.grid(env1=seq(-3,3,.5), env2=seq(-3,3,.5))
biomass <- matrix(ncol=20, nrow=nrow(env))
for(i in seq_len(nrow(biomass)))
  biomass[i,] <- intercepts + env1*env[i,1] + env2*env[i,2]

dist <- dist(biomass)

##### Mantel test #######
mantel(dist, dist(env[,1]))

##### Quantile regressions ####
require(quantreg)
data <- data.frame(dist=as.numeric(dist),
                   env1=as.numeric(dist(env[,1])),
                   env2=as.numeric(dist(env[,2])))
model <- rq(dist ~ env1 + env2, data = data)
summary(model)

complex.model <- rq(dist ~ env1 + env2, data = data, tau = c(.2,.5,.8))
summary(complex.model)

simple.eh <- rq(dist ~ env1, data = data)
with(data, plot(dist ~ env1, pch = 20, xlab = "Environmental distance",
                ylab = "Site similarity"))
abline(simple.eh, col = "red", lwd = 3)
