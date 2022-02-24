# Create a model for gene drive with lethal mutations
# Include population growth

beverton_holt <- function(Nt, R0, M){
  # Returns the pop size at time t + 1, based on bevholt model
  # Density dependent growth
  Nt_1 <- ceiling((R0 * Nt) / (1 + (Nt / M)))
  return(Nt_1)
}

count_genotype <- function(pop){
  # Counts the individual genotypes
  temp <- apply(pop, 2, sum)
  return(c(sum(temp == 0), sum(temp == 1), sum(temp == 2)))
}

sim_gene_drive <- function(q0=0.05, d=0.6, t=10, N0=500, R0=2, M=500){
  #browser()
  # Simulates gene drive in N for t generations
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
  
  # keep track of allele and genotype frequency over time
  tg.freq <- rep(NA, t + 1)
  genotype.freq <- matrix(nrow = 3, ncol = t + 1)
  
  # At gen 0 we have 2 * N * p0 copies of allele 0
  # shuffle these alleles, and assign them into 2xN matrix
  k <- 2 * N0 * q0
  pop[[1]] <- matrix(sample(c(rep(0, 2 * N0 - k), rep(1, k))), nr = 2)
  
  # The initial allele frequency
  tg.freq[1] <- sum(pop[[1]] == 1) / (2 * N0)
  genotype.freq[,1] <- count_genotype(pop[[1]]) / N0
  
  # Initiate vector to store population size
  N <- rep(NA, t + 1)
  N[1] <- N0
  
  # Propagation
  for (i in 1:t) {
    browser()
    # Test for collapsed population or loss of transgene
    if (N[i] == 1 | tg.freq[i] == 0) {
      break
    }
    # Apply population growth
    N[i + 1] <- beverton_holt(N[i], R0, M)
    
    # Calculate gamete frequencies
    tg_gamete_freq <- d * genotype.freq[2,i] / (genotype.freq[1,i] + genotype.freq[2,i])
    # wt_gamete_freq <- 
    #   genotype.freq[1,i] + (1 - d) * genotype.freq[2,i] / 
    #     (genotype.freq[1,i] + genotype.freq[2,i])
    
    # Create next population with sampling
    pop[[i + 1]] <- matrix(sample(0:1, 2 * N[i+1], replace = T,
                                  prob = c(1 - tg_gamete_freq, tg_gamete_freq)),
                           nr = 2)
    
    # Eliminate homozygote transgenes from populations
    j = 1
    genotype <- apply(pop[[i+1]], 2, sum)
    
    pop[[i+1]] <- pop[[i + 1]][,-pop[[i+1]][]]
    
    while (j <= length(pop[[i+1]][1,])) {
      if (genotype[j] == 2){
        pop[[i + 1]] <- pop[[i + 1]][,-j]
        next
      }
      j = j + 1
    }
    # for (j in 1:N[i+1]){
    #   if (pop[[i + 1]][1,j] == pop[[i + 1]][2,j] & pop[[i + 1]][1,j] == 1) {
    #     pop[[i + 1]] <- pop[[i + 1]][,-j]
    #   }
    # }
    N[i + 1] <- length(pop[[i + 1]][1,])
    tg.freq[i + 1] <- sum(pop[[i + 1]] == 1) / (2 * N[i + 1])
    genotype.freq[,i + 1] <- count_genotype(pop[[i + 1]]) / N[i + 1]
  }
  
  return(list(N, tg.freq, genotype.freq))
}
