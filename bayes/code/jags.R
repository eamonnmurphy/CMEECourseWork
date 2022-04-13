######## JAGS ######
rm(list = ls())

D <- c( 0.5, 0.8, 0.9, 1.0, 1.15, 0.9, 0.8, 0.9, 1.7, 2, 1.1 )
n <- length(D)
sigma <- sd(D)
mu <- mean(D)
mu_prior <- 0.85
sd_prior <- 0.425

library("R2jags")
library("coda")

data_mod <- list(D = D, n = n, mu_prior = mu_prior, tau_prior = 1/sd_prior,
                 tau = 1/sigma)

mod_widthleave <- function()
{
  for(i in 1:n)
  {
    D[i] ~ dnorm(mu, tau)
  }
  
  mu ~ dnorm(mu_prior, tau_prior)
}

init1 <- list(mu = 3)
init2 <- list(mu = 1)
init_vals <- list(init1, init2)

params <- c("mu")

burnin <- 500
iter <- 2000
nchain <- 2

set.seed(12345)

mcmc_res <- R2jags::jags(model.file = mod_widthleave, data = data_mod,
                         inits = init_vals, parameters.to.save = params,
                         n.chains = nchain, n.burnin = burnin, n.iter = iter)

str(mcmc_res)
mcmc_res$BUGSoutput$summary

# Put the output in a list we can access and parse
mcmc_res_list <- coda::as.mcmc(mcmc_res)
mcmc1 <- mcmc_res_list[[1]]
mcmc2 <- mcmc_res_list[[2]]

plot(density(mcmc1[,"mu"], adj = 1), col = "red")
lines(density(mcmc2[,"mu"], adj = 1), col = "green")

##### Exercises ########
nbchicks <- c( 151, 105, 73, 107, 113, 87, 77, 108, 118, 122, 112, 120, 122, 89,
               69, 71, 53, 41, 53, 31, 35, 14, 18 )
nbpairs <- c( 173, 164, 103, 113, 122, 112, 98, 121, 132, 136, 133, 137, 145, 117,
              90, 80, 67, 54, 58, 39, 42, 23, 23 )
temp <- c( 15.1, 13.3, 15.3, 13.3, 14.6, 15.6, 13.1, 13.1, 15.0, 11.7, 15.3,
      14.4, 14.4, 12.7, 11.7, 11.9, 15.9, 13.4, 14.0, 13.9, 12.9, 15.1, 13.0)
rain <- c( 67, 52, 88, 61, 32, 36, 72, 43, 92, 32, 86, 28, 57, 55, 66, 26, 28, 96,
      48, 90, 86, 78, 87 )

datax <- list(N = 23, nbchicks = nbchicks, nbpairs = nbpairs,
              temp = (temp - mean(temp)) / sd(temp),
              rain = (rain - mean(rain)) / sd(rain))

model_chicks <- function()
{
  for(i in 1:N)
  {
    nbchicks[i] ~ dbin(p[i], nbpairs[i])
    
    # REGRESSION TO DEFINE RELATIONSHIP OF "p" PER YEAR WITH RAINFALL AND TEMPERATURE
    # For each year, you also want to account for the effect of rainfall and temperature.
    # You do this with a logistic regression that establishes this probability of success per year "i"
    # with temperature and rainfall. This will be a simple regression in which we specify that the probability
    # of breeding success per year "i" is a function of temperature in this same year "i" times a slope 
    # "b_{temp}" plus the effect of
    # rainfall in this same year "i" times the slope of this covariate. Then, we have an intercept, "a".
    # **IMPORTANT**
    # We do not say that the probability of breeding success per year, p_{i}, is a linear function of these
    # parameters directly on the scale of the probability of success. We use the logit function that sets "p"
    # per year between -inf to inf. Then, if we transform this, we will have "p" per year going from
    # 0 to 1. So we do not model "p", we model "logit of pi". 
    logit(p[i]) <- a + b.temp * temp[i] + b.rain * rain[i]
  }
  
  a ~ dnorm(0, 0.1)
  b.temp ~ dnorm(0, 0.01)
  b.rain ~ dnorm(0, 0.001)
}

init1 <- list(a = 0.5, b.temp = 0.5, b.rain = 0.5)
init2 <- list(a = -0.5, b.temp = -0.5, b.rain = -0.5)
init_vals <- list(init1, init2)

params <- c("a", "b.temp", "b.rain")

burnin <- 500
iter <- 2000
nchain <- 2

set.seed(12345)

mcmc.chicks <- R2jags::jags(model.file = model_chicks, data = datax,
                           inits = init_vals, parameters.to.save = params,
                           n.chains = nchain, n.burnin = burnin, n.iter = iter )

mcmc.chicks.list <- coda::as.mcmc(mcmc.chicks, start = burnin)
# mcmc1 <- mcmc.chicks.list[[ 1 ]]
# mcmc2 <- mcmc.chicks.list[[ 2 ]]
plot(mcmc.chicks.list)

###### To avoid burn in issues #####
mcmc1 <- coda::as.mcmc(mcmc.chicks$BUGSoutput$sims.matrix[1:(iter - burnin),])
mcmc2 <- coda::as.mcmc(mcmc.chicks$BUGSoutput$sims.matrix[(iter - burnin + 1):(2 * (iter - burnin)),])
graphics.off()

plot( density( mcmc1[,"b.temp"], adj = 1 ), col = "red" )
lines( density( mcmc2[,"b.temp"], adj = 1 ), col = "green" )


plot( density( mcmc1[,"b.temp"][(burnin + 1):iter], adj = 1 ), col = "red" )
lines( density( mcmc2[,"b.temp"][(burnin + 1):iter], adj = 1 ), col = "green" )

mean(mcmc1[,"a"])
mean(mcmc2[,"a"])

mean(mcmc1[,"b.rain"])
mean(mcmc2[,"b.rain"])

mean(mcmc2[,"b.temp"])
mean(mcmc2[,"b.temp"])

sd(mcmc1[,"a"])

graphics.off()

par(mfrow = c(3,1))
R2jags::traceplot( mcmc1[,"a"], ask = FALSE )
R2jags::traceplot( mcmc2[,"a"], ask = FALSE, add = T, col = "red" )

R2jags::traceplot( mcmc1[,"b.rain"], ask = FALSE )
R2jags::traceplot( mcmc2[,"b.rain"], ask = FALSE, add = T, col = "red" )

R2jags::traceplot( mcmc1[,"b.temp"], ask = FALSE )
R2jags::traceplot( mcmc2[,"b.temp"], ask = FALSE, add = T, col = "red" )


######### To get around burn in issues #########
# Get mcmc sample for each chain
len_mcmc <- length( mcmc.chicks$BUGSoutput$sims.list$a )
half_mcmc <- len_mcmc/2
mcmc_a <- coda::as.mcmc(mcmc.chicks$BUGSoutput$sims.list$a)
mcmc_a_r1 <- coda::as.mcmc(mcmc.chicks$BUGSoutput$sims.list$a[1:half_mcmc])
mcmc_a_r2 <- coda::as.mcmc(mcmc.chicks$BUGSoutput$sims.list$a[(half_mcmc+1):len_mcmc])
mcmc_bT <- coda::as.mcmc(mcmc.chicks$BUGSoutput$sims.list$b.temp)
mcmc_bT_r1 <- coda::as.mcmc(mcmc.chicks$BUGSoutput$sims.list$b.temp[1:half_mcmc])
mcmc_bT_r2 <- coda::as.mcmc(mcmc.chicks$BUGSoutput$sims.list$b.temp[(half_mcmc+1):len_mcmc])
mcmc_bR <- coda::as.mcmc(mcmc.chicks$BUGSoutput$sims.list$b.rain)
mcmc_bR_r1 <- coda::as.mcmc(mcmc.chicks$BUGSoutput$sims.list$b.rain[1:half_mcmc])
mcmc_bR_r2 <- coda::as.mcmc(mcmc.chicks$BUGSoutput$sims.list$b.rain[(half_mcmc+1):len_mcmc])



# Plot densities
par( mfrow = c(3,1) )
plot( density( mcmc_a_r1, adj = 1 ), col = "red", main = "Density, a")
lines( density( mcmc_a_r2, adj = 1 ), col = "green" )
plot( density( mcmc_bT_r1, adj = 1 ), col = "red", main = "Density, T" )
lines( density( mcmc_bT_r2, adj = 1 ), col = "green")
plot( density( mcmc_bR_r1, adj = 1 ), col = "red", main = "Density, rain" )
lines( density( mcmc_bR_r2, adj = 1 ), col = "green" )



# Get mean, sd, and quantiles
mcmcout_a_r1 <- list( mean = mean( mcmc_a_r1 ), sd = sd( mcmc_a_r1 ), q = quantile( mcmc_a_r1, probs = c(0.025,0.975) ) )
mcmcout_a_r2 <- list( mean = mean( mcmc_a_r2 ), sd = sd( mcmc_a_r2 ), q = quantile( mcmc_a_r2, probs = c(0.025,0.975) ) )
mcmcout_a <- list( mean = mean( mcmc_a ), sd = sd( mcmc_a ), q = quantile( mcmc_a, probs = c(0.025,0.975) ) )



mcmcout_bT_r1 <- list( mean = mean( mcmc_bT_r1 ), sd = sd( mcmc_bT_r1 ), q = quantile( mcmc_bT_r1, probs = c(0.025,0.975) ) )
mcmcout_bT_r2 <- list( mean = mean( mcmc_bT_r2 ), sd = sd( mcmc_bT_r2 ), q = quantile( mcmc_bT_r2, probs = c(0.025,0.975) ) )
mcmcout_bT <- list( mean = mean( mcmc_bT ), sd = sd( mcmc_bT ), q = quantile( mcmc_bT, probs = c(0.025,0.975) ) )



mcmcout_bR_r1 <- list( mean = mean( mcmc_bR_r1 ), sd = sd( mcmc_bR_r1 ), q = quantile( mcmc_bR_r1, probs = c(0.025,0.975) ) )
mcmcout_bR_r2 <- list( mean = mean( mcmc_bR_r2 ), sd = sd( mcmc_bR_r2 ), q = quantile( mcmc_bR_r2, probs = c(0.025,0.975) ) )
mcmcout_bR <- list( mean = mean( mcmc_bR ), sd = sd( mcmc_bR ), q = quantile( mcmc_bR, probs = c(0.025,0.975) ) )



# Plot trace plots
par(mfrow = c(3,1))
R2jags::traceplot( mcmc_a_r1, ask = FALSE )
R2jags::traceplot( mcmc_a_r2, ask = FALSE, add = T, col = "red" )



R2jags::traceplot( mcmc_bR_r1, ask = FALSE )
R2jags::traceplot( mcmc_bR_r2, ask = FALSE, add = T, col = "red" )



R2jags::traceplot( mcmc_bT_r1, ask = FALSE )
R2jags::traceplot( mcmc_bT_r2, ask = FALSE, add = T, col = "red" )
