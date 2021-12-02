rm(list = ls())
library(ggplot2)
library(minpack.lm)
library(BICmodavg)
data <- read.csv("WrangledDataSet.csv")

######### Calculate a quadratic model for each ID, store models and bics #####
quad_models <- vector("list", max(data$ID))
quad_bics <- rep(Inf, max(data$ID))
for (i in unique(data$ID)) {
  #browser()
   temp_data <- data[which(data$ID == i),]
   try(temp_model <- lm(ln_PopBio ~ poly(Time, 2), temp_data))
   quad_models[[i]] <- temp_model
   quad_bics[i] <- BIC(temp_model)
}

# # Plot the data for the best and worst model
# max_bic <- which.max(quad_bics)
# predicted_worst <- predict.lm(quad_models[[max_bic]], data[which(data$ID == max_bic),])
# p <- ggplot(data[which(data$ID == max_bic),], aes(Time, log(PopBio))) + geom_point() +
#   geom_line(aes(data$Time[which(data$ID == max_bic)], predicted_worst))
# p
# 
# min_bic <- which.min(quad_bics)
# predicted_best <- predict.lm(quad_models[[min_bic]], data[which(data$ID == min_bic),])
# q <- ggplot(data[which(data$ID == min_bic),], aes(Time, log(PopBio))) + geom_point() +
#   geom_line(aes(data$Time[which(data$ID == min_bic)], predicted_best))
# q

####### Calculate a cubic model for each ID, store models and bics ######
cubic_models <- vector("list", max(data$ID))
cubic_bics <- rep(Inf, max(data$ID))
for (i in unique(data$ID)) {
  #browser()
  temp_data <- data[which(data$ID == i),]
  try(temp_model <- lm(PopBio ~ poly(Time, 3), temp_data))
  cubic_models[[i]] <- temp_model
  cubic_bics[i] <- BIC(temp_model)
}

# # Plot the data for the best and worst model
# max_bic <- which.max(cubic_bics)
# predicted_worst <- predict.lm(cubic_models[[max_bic]], data[which(data$ID == max_bic),])
# p <- ggplot(data[which(data$ID == max_bic),], aes(Time, log(PopBio))) + geom_point() +
#   geom_line(aes(data$Time[which(data$ID == max_bic)], log(predicted_worst)))
# p
# 
# min_bic <- which.min(cubic_bics)
# predicted_best <- predict.lm(cubic_models[[min_bic]], data[which(data$ID == min_bic),])
# q <- ggplot(data[which(data$ID == min_bic),], aes(Time, log(PopBio))) + geom_point() +
#   geom_line(aes(data$Time[which(data$ID == min_bic)], log(predicted_best)))
# q

####### Fit the logistic model ######
logistic <- function(N0, K, r, t){
  (N0 * K * exp(r * t)) / (K + N0 * (exp(r * t) -1))
}

logistic_models <- vector("list", max(data$ID))
logistic_bics <- rep(Inf, max(data$ID))
# logistic_summaries <- vector("list", max(data$ID))

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
  try(logistic_bics[i] <- BIC(temp_model))
  #logistic_summaries[i] <- summary(temp_model)
}

sum(logistic_bics != Inf)

# # # Plot the data for the best and worst model
# max_bic <- which.max(logistic_bics)
# worst_mod <- logistic_models[[max_bic]]
# plot_times <- seq(0, max(data$Time[which(data$ID == max_bic)]), len = 200)
# N0_worst <- coef(worst_mod)["N0"]
# r_worst <- coef(worst_mod)["r"]
# K_worst <- coef(worst_mod)["K"]
# predicted_worst <- N0_worst * K_worst * exp(plot_times * r_worst) /
#   (K_worst + N0_worst * (exp(r_worst * plot_times) -1))
# 
# plot(data$Time[which(data$ID == max_bic)], data$ln_PopBio[which(data$ID == max_bic)])
# lines(plot_times, log(predicted_worst))
# 
# min_bic <- which.min(logistic_bics)
# best_mod <- logistic_models[[min_bic]]
# plot_times <- seq(0, max(data$Time[which(data$ID == min_bic)]), len = 200)
# N0_best <- coef(best_mod)["N0"]
# r_best <- coef(best_mod)["r"]
# K_best <- coef(best_mod)["K"]
# predicted_best <- N0_best * K_best * exp(plot_times * r_best) /
#   (K_best + N0_best * (exp(r_best * plot_times) -1))
# 
# plot(data$Time[which(data$ID == min_bic)], data$ln_PopBio[which(data$ID == min_bic)])
# lines(plot_times, log(predicted_best))

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

params <- matrix(nrow = max(unique(data$ID)), ncol = 6)

for (i in unique(data$ID)) {
  temp_data <- data[which(data$ID == i),]
  params[i,1] <- max(temp_data$Time)
  params[i,2] <- min(temp_data$ln_PopBio)
  params[i,3] <- max(temp_data$ln_PopBio)
  params[i,4] <- max(diff(temp_data$ln_PopBio))
  params[i,5] <- nrow(data[which(data$ID == i),])
  params[i,6] <- data$Time[which.max(diff(diff(data$ln_PopBio[which(data$ID == i)])))]
}

gompertz_models <- vector("list", max(data$ID))
gompertz_bics <- rep(Inf, max(data$ID))

# system.time(try(for (i in unique(data$ID)) {
#   #browser()
#   reps <- 100
#   id_models <- vector("list", reps)
#   id_bics <- vector(length = reps)
#   temp_data <- data[which(data$ID == i),]
#   log_model <- logistic_models[[i]]
#   try(N0_start <- log(as.numeric(coef(log_model)["N0"])))
#   try(K_start <- log(as.numeric(coef(log_model)["K"])))
#   try(r_start <- as.numeric(coef(log_model)["r"]))
#   try(t_lag_start <- temp_data$Time[which.max(diff(diff(temp_data$ln_PopBio)))], silent = T)
#   
#   try(N0_vect <- rnorm(reps, mean = min(temp_data$ln_PopBio), sd = 3 * abs(min(temp_data$ln_PopBio))), silent = T)
#   try(K_vect <- rnorm(reps, mean = 2 * max(temp_data$ln_PopBio), sd = 6 * abs(max(temp_data$ln_PopBio))), silent = T)
#   try(r_vect <- runif(reps, min = 10 ^ -10, max = 10 ^ -2), silent = T)
#   try(t_lag_vect <- rnorm(reps, mean = t_lag_start, sd = 3 * abs(t_lag_start)), silent = T)
#   
#   for (j in 1:reps) {
#     temp_model <- NULL
#     try(temp_model <- nlsLM(ln_PopBio ~ gompertz(
#       N_0, K, r_max, t_lag, t = Time), data = temp_data,
#       start = list(N_0 = N0_vect[j], K = K_vect[j], r_max = r_vect[j], 
#                    t_lag = t_lag_vect[j])
#       #upper = c(1000 * max(temp_data$ln_PopBio), 1000 * max(temp_data$ln_PopBio), 1 * 10 ^ 9, 1 * 10 ^ 9)
#       #lower = c(-50, -50, -1 * 10 ^ 9, -1 * 10 ^ 9)
#     ), silent = T)
#     id_models[[j]] <- temp_model
#     try(id_bics[j] <- BIC(temp_model), silent = TRUE)
#   }
#   
#   try(best_model <- id_models[[which.min(id_bics)]])
#   try(gompertz_models[[i]] <- best_model)
#   try(gompertz_bics[i] <- BIC(best_model), silent = TRUE)
# }))

system.time(try(for (i in unique(data$ID)) {
  #browser()
  reps <- 100
  id_models <- vector("list", reps)
  id_bics <- rep(Inf, length = reps)
  temp_data <- data[which(data$ID == i),]
  log_model <- logistic_models[[i]]
  try(N0_start <- log(as.numeric(coef(log_model)["N0"])))
  try(K_start <- log(as.numeric(coef(log_model)["K"])))
  try(r_start <- as.numeric(coef(log_model)["r"]))
  try(t_lag_start <- temp_data$Time[which.max(diff(diff(temp_data$ln_PopBio)))], silent = T)
  
  # try(N0_vect <- rnorm(reps, mean = min(temp_data$ln_PopBio), sd = 3 * abs(min(temp_data$ln_PopBio))), silent = T)
  # try(K_vect <- rnorm(reps, mean = 2 * max(temp_data$ln_PopBio), sd = 6 * abs(max(temp_data$ln_PopBio))), silent = T)
  # try(r_vect <- runif(reps, min = 10 ^ -10, max = 10 ^ -2), silent = T)
  # try(t_lag_vect <- rnorm(reps, mean = t_lag_start, sd = 3 * abs(t_lag_start)), silent = T)
  
  id_models <- replicate(reps, {
            try(N0_vect <- rnorm(1, mean = min(temp_data$ln_PopBio), sd = 3 * abs(min(temp_data$ln_PopBio))), silent = T)
            try(K_vect <- rnorm(1, mean = 2 * max(temp_data$ln_PopBio), sd = 6 * abs(max(temp_data$ln_PopBio))), silent = T)
            try(r_vect <- runif(1, min = 10 ^ -10, max = 10 ^ -2), silent = T)
            try(t_lag_vect <- rnorm(1, mean = t_lag_start, sd = 3 * abs(t_lag_start)), silent = T)
            try(nlsLM(ln_PopBio ~ gompertz(
      N_0, K, r_max, t_lag, t = Time), data = temp_data,
      start = list(N_0 = N0_vect, K = K_vect, r_max = r_vect, t_lag = t_lag_vect)),
  silent = T)}, simplify = FALSE)
  
  for (j in 1:length(id_models)){
    try(id_bics[j] <- BIC(id_models[[j]]))
    }
  try(best_model <- id_models[[which.min(id_bics)]])
  try(gompertz_models[[i]] <- best_model)
  try(gompertz_bics[i] <- id_bics[[which.min(id_bics)]], silent = TRUE)
}))

coefs <- matrix(nrow = length(unique(data$ID)), ncol = 4)
for (i in unique(data$ID)) {
  try(coefs[i,1] <- as.numeric(coef(gompertz_models[[i]])["N_0"]), silent = T)
  try(coefs[i,2] <- as.numeric(coef(gompertz_models[[i]])["K"]), silent = T)
  try(coefs[i,3] <- as.numeric(coef(gompertz_models[[i]])["r_max"]), silent = T)
  try(coefs[i,4] <- as.numeric(coef(gompertz_models[[i]])["t_lag"]), silent = T)
}

# last is 137
sum(gompertz_bics != Inf)

# x <- 278
# mod <- gompertz_models[[x]]
# plot_times <- seq(0, max(data$Time[which(data$ID == x)]), len = 200)
# N_0<- coef(mod)["N_0"]
# r_max <- coef(mod)["r_max"]
# K <- coef(mod)["K"]
# t_lag <- coef(mod)["t_lag"]
# gomp_predicted <- N_0 + (K - N_0) * exp(-exp(r_max * exp(1) * (t_lag - plot_times)/((K - N_0) * log(10)) + 1))
# quad_predicted <- predict.lm(quad_models[[x]], data[which(data$ID == x),])
# cub_predicted <- predict.lm(cubic_models[[x]], data[which(data$ID == x),])
# 
# plot(data$Time[which(data$ID == x)], data$ln_PopBio[which(data$ID == x)])
# lines(plot_times, gomp_predicted)
# lines(data$Time[which(data$ID == x)], log(quad_predicted))
# lines(data$Time[which(data$ID == x)], log(cub_predicted))

###### Compare BICs #########
bic_compare <- matrix(nrow = 285, ncol = 4)
bic_compare[,1] <- quad_bics
bic_compare[,2] <- cubic_bics
bic_compare[,3] <- logistic_bics
bic_compare[,4] <- gompertz_bics
which.min(bic_compare[1,])

bic_compare <- data.frame(quadratic = quad_bics, cubic = cubic_bics,
                          logistic = logistic_bics, gompertz = gompertz_bics,
                          best = NA)

bic_compare[bic_compare == -Inf] <- Inf

for (i in 1:285) {
  bic_compare$best[i] <- which.min(bic_compare[i,1:4])
  if (bic_compare[i,1] == bic_compare[i,2] & 
      bic_compare[i,1] == bic_compare[i,3] &
      bic_compare[i,1] == bic_compare[i,4]) {
    bic_compare$best[i] <- 0
  }
}



tallies <- c(length(bic_compare$best[which(bic_compare$best == 1)]),
             length(bic_compare$best[which(bic_compare$best == 2)]),
             length(bic_compare$best[which(bic_compare$best == 3)]),
             length(bic_compare$best[which(bic_compare$best == 4)]))

tally_table <- data.frame(Model = c("Quadratic", "Cubic", "Logistic", "Gompertz"),
                          Tallies = tallies)

write.csv(tally_table, "../results/bic_tallies.csv", quote = FALSE, row.names = F)

