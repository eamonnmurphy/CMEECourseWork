rm(list = ls())
library(ggplot2)
library(minpack.lm)
library(AICcmodavg)
library(scales)
data <- read.csv("../data/WrangledDataSet.csv")

######### Calculate a quadratic model for each ID, store models and aiccs #####
quad_models <- vector("list", max(data$ID))
quad_aiccs <- rep(Inf, max(data$ID))
for (i in unique(data$ID)) {
  #browser()
   temp_data <- data[which(data$ID == i),]
   try(temp_model <- lm(ln_PopBio ~ poly(Time, 2), temp_data))
   quad_models[[i]] <- temp_model
   quad_aiccs[i] <- AICc(temp_model)
}

####### Calculate a cubic model for each ID, store models and aiccs ######
cubic_models <- vector("list", max(data$ID))
cubic_aiccs <- rep(Inf, max(data$ID))
for (i in unique(data$ID)) {
  #browser()
  temp_data <- data[which(data$ID == i),]
  try(temp_model <- lm(PopBio ~ poly(Time, 3), temp_data))
  cubic_models[[i]] <- temp_model
  cubic_aiccs[i] <- AICc(temp_model)
}

####### Fit the logistic model ######
logistic <- function(N0, K, r, t){
  (N0 * K * exp(r * t)) / (K + N0 * (exp(r * t) -1))
}

logistic_models <- vector("list", max(data$ID))
logistic_aiccs <- rep(Inf, max(data$ID))

# Loop through each ID and find a model for each subset
for (i in unique(data$ID)) {
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
                      data = temp_data, control = nls.lm.control(maxiter = 100)))
  logistic_models[[i]] <- temp_model
  try(logistic_aiccs[i] <- AICc(temp_model))
}


##### Fit Gompertz model ######
gompertz <- function(N_0, K, r_max, t_lag, t){
  return(N_0 + (K - N_0) * exp(-exp(r_max * exp(1) * (t_lag - t)/((K - N_0) * log(10)) + 1)))
}

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
gompertz_aiccs <- rep(Inf, max(data$ID))

# Loop through each unique ID and find the best model for each one
try(for (i in unique(data$ID)) {
  reps <- 100
  id_models <- vector("list", reps)
  id_aiccs <- rep(Inf, length = reps)
  temp_data <- data[which(data$ID == i),]
  try(t_lag_start <- temp_data$Time[which.max(diff(diff(temp_data$ln_PopBio)))], silent = T)
  
  # Sample starting values in order to find a well-fitting model
  id_models <- replicate(reps, {
            try(N0_vect <- rnorm(1, mean = min(temp_data$ln_PopBio), sd = 3 * abs(min(temp_data$ln_PopBio))), silent = T)
            try(K_vect <- rnorm(1, mean = 2 * max(temp_data$ln_PopBio), sd = 6 * abs(max(temp_data$ln_PopBio))), silent = T)
            try(r_vect <- runif(1, min = 10 ^ -10, max = 10 ^ -2), silent = T)
            try(t_lag_vect <- rnorm(1, mean = t_lag_start, sd = 3 * abs(t_lag_start)), silent = T)
            try(nlsLM(ln_PopBio ~ gompertz(N_0, K, r_max, t_lag, t = Time), 
                      data = temp_data, control = nls.lm.control(maxiter = 100),
      start = list(N_0 = N0_vect, K = K_vect, r_max = r_vect, t_lag = t_lag_vect)),
  silent = T)}, simplify = FALSE)
  
  # Calculate AICc and store models and scores
  for (j in 1:length(id_models)){
    try(id_aiccs[j] <- AICc(id_models[[j]]))
    }
  try(best_model <- id_models[[which.min(id_aiccs)]])
  try(gompertz_models[[i]] <- best_model)
  try(gompertz_aiccs[i] <- id_aiccs[[which.min(id_aiccs)]], silent = TRUE)
})

# Extract model coefficients
coefs <- matrix(nrow = length(unique(data$ID)), ncol = 4)
for (i in unique(data$ID)) {
  try(coefs[i,1] <- as.numeric(coef(gompertz_models[[i]])["N_0"]), silent = T)
  try(coefs[i,2] <- as.numeric(coef(gompertz_models[[i]])["K"]), silent = T)
  try(coefs[i,3] <- as.numeric(coef(gompertz_models[[i]])["r_max"]), silent = T)
  try(coefs[i,4] <- as.numeric(coef(gompertz_models[[i]])["t_lag"]), silent = T)
}


###### Compare AICcs #########
aicc_compare <- matrix(nrow = 285, ncol = 4)
aicc_compare[,1] <- quad_aiccs
aicc_compare[,2] <- cubic_aiccs
aicc_compare[,3] <- logistic_aiccs
aicc_compare[,4] <- gompertz_aiccs
which.min(aicc_compare[1,])

aicc_compare <- data.frame(quadratic = quad_aiccs, cubic = cubic_aiccs,
                          logistic = logistic_aiccs, gompertz = gompertz_aiccs,
                          best = NA)

for (i in 1:285) {
  aicc_compare$best[i] <- which.min(aicc_compare[i,1:4])
  if (aicc_compare[i,1] == aicc_compare[i,2] & 
      aicc_compare[i,1] == aicc_compare[i,3] &
      aicc_compare[i,1] == aicc_compare[i,4]) {
    aicc_compare$best[i] <- 0
  }
}

# Tally the best model for each subset
tallies <- c(length(aicc_compare$best[which(aicc_compare$best == 1)]),
             length(aicc_compare$best[which(aicc_compare$best == 2)]),
             length(aicc_compare$best[which(aicc_compare$best == 3)]),
             length(aicc_compare$best[which(aicc_compare$best == 4)]))

percent <- c(tallies[1] / sum(tallies), tallies[2] / sum(tallies),
             tallies[3] / sum(tallies), tallies[4] / sum(tallies))

tally_table <- data.frame(Model = c("Quadratic", "Cubic", "Logistic", "Gompertz"),
                          Tally = tallies,
                          Percentage = scales::percent(percent))

write.csv(tally_table, "../results/aicc_tallies.csv", quote = FALSE, row.names = F)

