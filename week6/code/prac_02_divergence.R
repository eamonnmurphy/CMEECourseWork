###### Calculate the divergence time of three species ######

# Load in the data
western <- read.csv("../data/western_banded_gecko.csv", header = F,
                    colClasses = c("character"))
bent_toed <- read.csv("../data/bent-toed_gecko.csv", header = F,
                      colClasses = c("character"))
leopard <- read.csv("../data/leopard_gecko.csv", header = F,
                    colClasses = c("character"))

# Count polymorphic sites
poly_count <- function(seqs){
  snps <- c()
  for (i in 1:ncol(seqs)) {
    if (length(unique(seqs[,i])) > 1) {
      snps <- append(snps, i)
    }
  }
  count <- length(snps)
  return(count)
}

western_poly_count <- poly_count(western)
bent_toed_poly_count <- poly_count(bent_toed)
leopard_poly_count <- poly_count(leopard)

# Record polymorphic sites
identify_polymorphisms <- function(seqs){
  snps <- c()
  for (i in 1:ncol(seqs)) {
    if (length(unique(seqs[,i])) > 1) {
      snps <- append(snps, i)
    }
  }
  return(snps)
}

western_poly <- identify_polymorphisms(western)
bent_toed_poly <- identify_polymorphisms(bent_toed)
leopard_poly <- identify_polymorphisms(leopard)

# Identify sites of difference between species
identify_divergence <- function(seq1, seq2){
  diverged <- c()
  for (i in 1:ncol(seq1)){
    if (sum(seq1[,i] == seq2[,i]) != 20 & 
        length(unique(seq1[,i])) <= 1 & 
        length(unique(seq2[,i])) <= 1) {
      diverged <- append(diverged, i)
    }
  }
  diverged_count = length(diverged)
  return(diverged_count)
}

bent_leopard_dif <- identify_divergence(bent_toed, leopard)
bent_western_dif <- identify_divergence(bent_toed, western)
leopard_western_dif <- identify_divergence(leopard, western)

# Calculate divergence
bent_leopard_div <- bent_leopard_dif / 
  (ncol(bent_toed) - length(union(bent_toed_poly, leopard_poly)))
bent_western_div <- bent_western_dif /
  (ncol(bent_toed) - length(union(bent_toed_poly, western_poly)))
leopard_western_div <- leopard_western_dif /
  (ncol(leopard) - length(union(leopard_poly, western_poly)))

# The shape of the tree must be [leopard, [bent_toed, western]]
# Calculate mu and time of divergence
mu = bent_leopard_div / (2 * 30 * (10 ** 6))
t = bent_western_div / (2 * mu)

print(paste("Time of divergence is", formatC(t), "million years ago"))

# Time of divergence is 12.1 mya