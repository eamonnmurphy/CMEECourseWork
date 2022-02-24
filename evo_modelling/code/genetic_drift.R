# Genetic Drift Simulator
sim_genetic_drift <- function(p0 = 0.5, t = 10, N = 10){
  # Initialisation
  # pop is a list storing all the allelic configurations
  # From gen 0 to t, hence (t + 1) elements
  pop <- list()
  length(pop) <- t + 1
  
  # Give names to the elements of a population
  names(pop) <- rep(NA, t + 1)
  for (i in 1:length(pop)){
    names(pop)[i] <- paste(c("generation", i - 1), collapse = " ")
  }
  
  # keep track of allele frequency over time
  allele.freq <- rep(NA, t + 1)
  
  # At gen 0 we have 2 * N * p0 copies of allele 0
  # shuffle these alleles, and assign them into 2xN matrix
  k <- ceiling(2 * N * p0)
  pop[[1]] <- matrix(sample(c(rep(0, k), rep(1, 2 * N - k))), nr = 2)
  
  # The initial allele frequency
  allele.freq[1] <- sum(pop[[1]] == 0) / (2 * N)
  
  # Propagation
  for (i in 2:(t+1)) {
    pop[[i]] <- matrix(sample(pop[[i-1]], replace = TRUE), nr = 2)
    
    allele.freq[i] <- sum(pop[[i]] == 0) / (2 * N)
  }
  # Outputs
  return(list(pop = pop, allele.freq = allele.freq))
}

repeat_sim <- function(p0 = 0.5, t = 10, N = 200, reps = 10000){
  freqs <- rep(NA, reps)
  
  for (i in 1:reps) {
    freq <- sim_genetic_drift(p0, t, N)[[2]]
    freqs[i] <- freq[t + 1]
  }
  
  mean = mean(freqs)
  variance = var(freqs)
  hist(freqs)
  
  return(list(mean = mean, variance = variance))
}

sim_persistence <- function(p0 = 0.05, N = 100){
  # Initialisation
  # pop is a list storing all the allelic configurations
  # From gen 0 to t, hence (t + 1) elements
  pop <- list()
  
  # keep track of allele frequency over time
  allele.freq <- c()
  
  # At gen 0 we have 2 * N * p0 copies of allele 0
  # shuffle these alleles, and assign them into 2xN matrix
  k <- ceiling(2 * N * p0)
  pop[[1]] <- matrix(sample(c(rep(0, k), rep(1, 2 * N - k))), nr = 2)
  
  # The initial allele frequency
  allele.freq <- append(allele.freq, sum(pop[[1]] == 0) / (2 * N))
    
  # Propagation
  i = 2
  while (i != 0) {
    pop <- append(pop, matrix(sample(pop[[i-1]], replace = TRUE), nr = 2))
    
    allele.freq <- append(allele.freq, sum(pop[[i]] == 0) / (2 * N))
    
    i = i + 1
    
    if (allele.freq[i] == 0) {
      i = 0
    }
  }
  
  # Outputs
  return(list(pop = pop, allele.freq = allele.freq))
}

sim_genetic_drift_start_pop <- function(pop, t = 10){
  # keep track of allele frequency over time
  allele.freq <- rep(NA, t + 1)
  
  # The initial allele frequency
  allele.freq[1] <- sum(pop[[1]] == 0) / (2 * length(pop))
  
  # Propagation
  for (i in 2:(t+1)) {
    pop[[i]] <- matrix(sample(pop[[i-1]], replace = TRUE), nr = 2)
    
    allele.freq[i] <- sum(pop[[i]] == 0) / (2 * N)
  }
  # Outputs
  return(list(pop = pop, allele.freq = allele.freq))
}

ne_estimator <- function(p0 = 0.5, t1 = 40, t2 = 50, N = 200, reps = 10000){
  for (i in 1:10000){
    x0 <- sim_genetic_drift(p0, t1, N)[[]][[t1 + 1]]
    xt <- sim_genetic_drift_start_pop(x0)
  }
}
