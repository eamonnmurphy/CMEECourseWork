rm(list = ls())
library(ggplot2)
library(minpack.lm)
data <- read.csv("WrangledDataSet.csv")

######### Calculate a quadratic model for each ID, store models and aics #####
quad_models <- vector("list", max(data$ID))
quad_aics <- vector(length = max(data$ID))
for (i in unique(data$ID)) {
  #browser()
   temp_data <- data[which(data$ID == i),]
   try(temp_model <- lm(ln_PopBio ~ poly(Time, 2), temp_data))
   quad_models[[i]] <- temp_model
   quad_aics[i] <- AIC(temp_model)
}

# # Plot the data for the best and worst model
# max_aic <- which.max(quad_aics)
# predicted_worst <- predict.lm(quad_models[[max_aic]], data[which(data$ID == max_aic),])
# p <- ggplot(data[which(data$ID == max_aic),], aes(Time, log(PopBio))) + geom_point() +
#   geom_line(aes(data$Time[which(data$ID == max_aic)], predicted_worst))
# p
# 
# min_aic <- which.min(quad_aics)
# predicted_best <- predict.lm(quad_models[[min_aic]], data[which(data$ID == min_aic),])
# q <- ggplot(data[which(data$ID == min_aic),], aes(Time, log(PopBio))) + geom_point() +
#   geom_line(aes(data$Time[which(data$ID == min_aic)], predicted_best))
# q

####### Calculate a cubic model for each ID, store models and aics ######
cubic_models <- vector("list", max(data$ID))
cubic_aics <- vector(length = max(data$ID))
for (i in unique(data$ID)) {
  #browser()
  temp_data <- data[which(data$ID == i),]
  try(temp_model <- lm(PopBio ~ poly(Time, 3), temp_data))
  cubic_models[[i]] <- temp_model
  cubic_aics[i] <- AIC(temp_model)
}

# # Plot the data for the best and worst model
# max_aic <- which.max(cubic_aics)
# predicted_worst <- predict.lm(cubic_models[[max_aic]], data[which(data$ID == max_aic),])
# p <- ggplot(data[which(data$ID == max_aic),], aes(Time, log(PopBio))) + geom_point() +
#   geom_line(aes(data$Time[which(data$ID == max_aic)], log(predicted_worst)))
# p
# 
# min_aic <- which.min(cubic_aics)
# predicted_best <- predict.lm(cubic_models[[min_aic]], data[which(data$ID == min_aic),])
# q <- ggplot(data[which(data$ID == min_aic),], aes(Time, log(PopBio))) + geom_point() +
#   geom_line(aes(data$Time[which(data$ID == min_aic)], log(predicted_best)))
# q

####### Fit the logistic model ######
logistic <- function(N0, K, r, t){
  (N0 * K * exp(r * t)) / (K + N0 * (exp(r * t) -1))
}

logistic_models <- vector("list", max(data$ID))
logistic_aics <- vector(length = max(data$ID))
logistic_summaries <- vector("list", max(data$ID))

for (i in unique(data$ID)) {
  #browser()
  temp_model <- 0
  temp_data <- data[which(data$ID == i),]
  if (min(temp_data$Time == 0)) {
    N0_start <- min(temp_data$PopBio[which(temp_data$Time == 0)])
  } else {
    N0_start <- min(temp_data$PopBio)
  }
  K_start <- 2 * max(temp_data$PopBio)
  r_start <- 0.00000001
  try(temp_model <- nlsLM(PopBio ~ logistic(N0, K, r, Time), 
                      start = list(N0 = N0_start, K = K_start, r = r_start),
                      data = temp_data))
                      # lower = c(-10000 * max(data$PopBio), -10000 * max(data$PopBio),
                      #           max(data$PopBio) * -10000),
                      # upper = c(10000 * max(data$PopBio), max(data$PopBio) * 10000, 
                      #           max(data$PopBio) * 10000)))
  logistic_models[[i]] <- temp_model
  try(logistic_aics[i] <- AIC(temp_model))
  #logistic_summaries[i] <- summary(temp_model)
}

sum(logistic_aics == 0)

# # Plot the data for the best and worst model
# max_aic <- which.max(logistic_aics)
# worst_mod <- logistic_models[[max_aic]]
# plot_times <- seq(0, max(data$Time[which(data$ID == max_aic)]), len = 200)
# N0_worst <- coef(worst_mod)["N0"]
# r_worst <- coef(worst_mod)["r"]
# K_worst <- coef(worst_mod)["K"]
# predicted_worst <- N0_worst * K_worst * exp(plot_times * r_worst) / 
#   (K_worst + N0_worst * (exp(r_worst * plot_times) -1))
# 
# plot(data$Time[which(data$ID == max_aic)], data$PopBio[which(data$ID == max_aic)])
# lines(plot_times, predicted_worst)
# 
# min_aic <- which.min(logistic_aics)
# best_mod <- logistic_models[[min_aic]]
# plot_times <- seq(0, max(data$Time[which(data$ID == min_aic)]), len = 200)
# N0_best <- coef(best_mod)["N0"]
# r_best <- coef(best_mod)["r"]
# K_best <- coef(best_mod)["K"]
# predicted_best <- N0_best * K_best * exp(plot_times * r_best) / 
#   (K_best + N0_best * (exp(r_best * plot_times) -1))
# 
# plot(data$Time[which(data$ID == min_aic)], data$PopBio[which(data$ID == min_aic)])
# lines(plot_times, predicted_best)

##### Fit Gompertz model ######
gompertz <- function(N_0, K, r_max, t_lag, t){
  return(N_0 + (K - N_0) * exp(-exp(r_max * exp(1) * (t_lag - t)/((K - N_0) * log(10)) + 1)))
}

# temp_model <- 0
# temp_data <- data[which(data$ID == 1),]
# log_model <- logistic_models[[1]]
# N0_start <- as.numeric(coef(log_model)["N0"])
# K_start <- as.numeric(coef(log_model)["K"])
# r_start <- as.numeric(coef(log_model)["r"])
# t_lag_start <- temp_data$Time[which.max(diff(diff(temp_data$ln_PopBio)))]
# 
# try(temp_model <- nlsLM(ln_PopBio ~ gompertz(
#   N_0, K, r_max, t_lag, t = Time), data = temp_data,
#   start = list(N_0 = N0_start, K = K_start, r_max = r_start, t_lag = t_lag_start)
# ))

gompertz_models <- vector("list", max(data$ID))
gompertz_aics <- vector(length = max(data$ID))

system.time(for (i in unique(data$ID)) {
  #browser()
  reps <- 1000
  id_models <- vector("list", reps)
  id_aics <- vector(length = reps)
  temp_data <- data[which(data$ID == i),]
  log_model <- logistic_models[[i]]
  N0_start <- as.numeric(coef(log_model)["N0"])
  K_start <- as.numeric(coef(log_model)["K"])
  r_start <- as.numeric(coef(log_model)["r"])
  t_lag_start <- temp_data$Time[which.max(diff(diff(temp_data$ln_PopBio)))]
  
  N0_vect <- rnorm(reps, mean = N0_start, sd = N0_start)
  K_vect <- runif(reps, min = 0, max = 1 * 10 ^ 10)
  r_vect <- rnorm(reps, mean = r_start, sd = 5 * r_start)
  t_lag_vect <- rnorm(reps, mean = t_lag_start, sd = 5 * t_lag_start)
  
  for (j in 1:reps) {
    temp_model <- NULL
    try(temp_model <- nlsLM(ln_PopBio ~ gompertz(
      N_0, K, r_max, t_lag, t = Time), data = temp_data,
      start = list(N_0 = N0_vect[j], K = K_vect[j], r_max = r_vect[j], 
                   t_lag = t_lag_vect[j])
    ))
    id_models[[j]] <- temp_model
    try(id_aics[j] <- AIC(temp_model))
  }
  
  best_model <- id_models[[which.min(id_aics)]]
  
  gompertz_models[[i]] <- best_model
  try(gompertz_aics[i] <- AIC(best_model))
})

sum(gompertz_aics == 0)

x <- 280
mod <- gompertz_models[[x]]
plot_times <- seq(0, max(data$Time[which(data$ID == x)]), len = 200)
N_0<- coef(mod)["N_0"]
r_max <- coef(mod)["r_max"]
K <- coef(mod)["K"]
t_lag <- coef(mod)["t_lag"]
predicted <- N_0 + (K - N_0) * exp(-exp(r_max * exp(1) * (t_lag - plot_times)/((K - N_0) * log(10)) + 1))

plot(data$Time[which(data$ID == x)], data$ln_PopBio[which(data$ID == x)])
lines(plot_times, predicted)

