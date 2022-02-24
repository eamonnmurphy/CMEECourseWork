# Genetic Drift Simulator
sim_migration <- function(p0a = 0.5, p0b = 0.5, t = 10, Na = 10, Nb = 10,
                              ma = 0.05, mb = 0.05){
  # Initialisation
  # pop is a list storing all the allelic configurations
  # From gen 0 to t, hence (t + 1) elements
  popa <- list()
  popb <- list()
  length(popa) <- t + 1
  length(popb) <- t + 1
  
  # Give names to the elements of a population
  names(popa) <- rep(NA, t + 1)
  for (i in 1:length(popa)){
    names(popa)[i] <- paste(c("generation", i - 1), collapse = " ")
  }
  
  names(popb) <- rep(NA, t + 1)
  for (i in 1:length(popb)){
    names(popb)[i] <- paste(c("generation", i - 1), collapse = " ")
  }
  
  # keep track of allele frequency over time
  allele.freq.a <- rep(NA, t + 1)
  allele.freq.b <- rep(NA, t + 1)
  
  # At gen 0 we have 2 * N * p0 copies of allele 0
  # shuffle these alleles, and assign them into 2xN matrix
  ka <- ceiling(2 * Na * p0a)
  popa[[1]] <- matrix(sample(c(rep(0, ka), rep(1, 2 * Na - ka))), nr = 2)
  
  kb <- ceiling(2 * Nb * p0b)
  popb[[1]] <- matrix(sample(c(rep(0, kb), rep(1, 2 * Nb - kb))), nr = 2)
  
  # The initial allele frequency
  allele.freq.a[1] <- sum(popa[[1]] == 0) / (2 * Na)
  allele.freq.b[1] <- sum(popb[[1]] == 0) / (2 * Nb)
  
  # Init gamete frequency
  gamete.freq.a <- rep(NA, t + 1)
  gamete.freq.b <- rep(NA, t + 1)
  
  # Propagation
  for (i in 1:(t)) {
    gamete.freq.a[i] <- (1 - ma) * allele.freq.a[i] + ma * allele.freq.b[i]
    gamete.freq.b[i] <- (1 - mb) * allele.freq.b[i] + mb * allele.freq.a[i]
    
    popa[[i + 1]] <- matrix(sample(0:1, size = 2 * Na, 
                                   prob = c(gamete.freq.a[i], 1 - gamete.freq.a[i]),
                                            replace = TRUE), nr = 2)
    popb[[i + 1]] <- matrix(sample(0:1, size = 2 * Nb, 
                                   prob = c(gamete.freq.b[i], 1 - gamete.freq.b[i]),
                                   replace = TRUE), nr = 2)
    
    allele.freq.a[i + 1] <- sum(popa[[i + 1]] == 0) / (2 * Na)
    allele.freq.b[i + 1] <- sum(popb[[i + 1]] == 0) / (2 * Nb)
  }
  # Outputs
  return(list(popa = popa, popb = popb, 
              allele.freq.a = allele.freq.a, allele.freq.b = allele.freq.b))
}

fst_calc <- function(allele.freq.a, allele.freq.b){
  xbar <- (allele.freq.a + allele.freq.b) / 2
  
  fst <- ((allele.freq.a - allele.freq.b) ^ 2) / (xbar * (1 - xbar))
  
  return(fst)
}

fst_over_time <- function(p0a = 0.95, p0b = 0.95, t = 100, Na = 100, Nb = 100,
                          ma = 0.05, mb = 0.05){
  pops <- sim_migration(p0a, p0b, t, Na, Nb, ma, mb)
  fst <- rep(NA, t + 1)
  
  for (i in 1:(t+1)) {
    fst[i] <- fst_calc(pops[[3]][i], pops[[4]][i]) 
  }
  
  return(fst)
}

repeat_fst <- function(reps = 1, start_points = 10){
  fst_rep <- list()
  length(fst_rep) <- reps * start_points
  starts <- seq(0, 1, length.out = start_points)
  for (j in 1:start_points){
    for (i in 1:reps) {
      fst_rep[[i * j]] <- fst_over_time(p0a = starts[j], ma = 0.01, mb = 0.01, t = 100)
    }
  }

  
  plot(fst_rep[[1]], type = "l")
  
  for (i in 2:(reps * start_points)){
    lines(fst_rep[[i]], col = i %% start_points + 1)
  }
}

repeat_migration_sim <- function(p0a = 0.5, p0b = 0.5, t = 10, Na = 100, Nb = 100,
                                 ma = 0.05, mb = 0.05, reps = 10000){
  #browser()
  freqsa <- rep(NA, reps)
  freqsb <- rep(NA, reps)
  
  for (i in 1:reps) {
    freqa <- sim_migration(p0a, p0b, t, Na, Nb, ma, mb)[[3]]
    freqsa[i] <- freqa[t + 1]
    
    freqb <- sim_migration(p0a, p0b, t, Na, Nb, ma, mb)[[4]]
    freqsb[i] <- freqb[t + 1]
  }
  
  meana = mean(freqsa)
  meanb = mean(freqsb)
  
  variancea = var(freqsa)
  varianceb = var(freqsb)
  
  hist(freqsa)
  hist(freqsb, col = "red", add = T)
  
  return(list(meana = meana, varianceb = varianceb,
              meanb = meanb, varianceb = varianceb))
}