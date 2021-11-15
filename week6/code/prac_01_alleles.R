##### Practical on allele and genotype frequencies ######

# import the data
bears <- read.csv("../data/bears.csv", header = FALSE, 
                  colClasses = c("character"))

# Identify the SNPs
identify_snps <- function(seqs = bears){
  snps <- c()
  for (i in 1:ncol(seqs)) {
    if (length(unique(seqs[,i])) > 1) {
      snps <- append(snps, i)
    }
  }
  return(snps)
}

snps <- identify_snps()

bears_snps <- bears[snps]

####### Calculate allele frequencies #######
allele_freq <- function(seqs = bears_snps){
  allele_freqs <- data.frame(matrix(ncol = 4, nrow = 0))
  colnames(allele_freqs) <- c("allele1", "freq1", "allele2", "freq2")
  for (i in 1:ncol(seqs)){
    alleles <- c(unique(seqs[,i]))
    freq <- sum(seqs[,i] == seqs[1,i])/40
    allele_freqs[nrow(allele_freqs) + 1,] <- 
      c(alleles[1], freq, alleles[2], 1 - freq)
  }
  allele_freqs$freq1 <- as.numeric(allele_freqs$freq1)
  allele_freqs$freq2 <- as.numeric(allele_freqs$freq2)
  return(allele_freqs)
}

allele_freqs <- allele_freq()

plot(allele_freqs[,2])
barplot(t(as.matrix(allele_freqs[,2])), ylim = c(0,1))

###### Calculate genotype frequencies ######
genotype_freq <- function(seqs = bears_snps){
  genotype_freqs <- data.frame(matrix(ncol = 5, nrow = 0))
  colnames(genotype_freqs) <- 
    c("allele1", "allele2", "homozygous1", "heterozygous", "homozygous2")
  for (i in 1:ncol(seqs)){
    alleles <- c(unique(seqs[,i]))
    x <- 1      
    homo1 <- 0
    homo2 <- 0
    hetero <- 0
    while (x < 40) {
      if (seqs[x,i] == seqs[x + 1, i] & 
        seqs[x,i] == seqs[1,i]){
        homo1 <- homo1 + 1
      }
      else if (seqs[x,i] == seqs[x + 1, i] & 
          seqs[x,i] != seqs[1,i]){
        homo2 <- homo2 + 1
      }
      else if (seqs[x,i] != seqs[x+1,i]) {
        hetero <- hetero + 1 
      }
      x = x + 2
    }
    genotype_freqs[nrow(genotype_freqs) + 1,] <- 
      c(alleles[1], alleles[2], homo1 / 20, hetero / 20, homo2 / 20)
  }
  genotype_freqs$homozygous1 <- as.numeric(genotype_freqs$homozygous1)
  genotype_freqs$heterozygous <- as.numeric(genotype_freqs$heterozygous)
  genotype_freqs$homozygous2 <- as.numeric(genotype_freqs$homozygous2)
  return(genotype_freqs)
}

genotype_freqs <- genotype_freq()

##### Calculate observed homozygosity and heterozygosity #####
homo_hetero <- function(seqs = bears_snps){
  homo_hetero_data <- data.frame(matrix(ncol = 2, nrow = 0))
  colnames(homo_hetero_data) <- c("homozygous", "heterozygous")
  for (i in 1:ncol(seqs)){
    alleles <- c(unique(seqs[,i]))
    x <- 1      
    homo <- 0
    hetero <- 0
    while (x < 40) {
      if (seqs[x,i] == seqs[x + 1, i]) {
        homo <- homo + 1
      }
      else if (seqs[x,i] != seqs[x+1,i]) {
       hetero <- hetero + 1 
      }
      x = x + 2
    }
    homo_hetero_data[nrow(homo_hetero_data) + 1,] <- 
      c(homo/20, hetero/20)
  }
  return(homo_hetero_data)
}

homo_hetero_data <- homo_hetero()

###### Expected genotype counts ######
expected_genotype_calc <- 
  function(seqs = bears_snps, allele = allele_freqs){
  expected_freqs <- data.frame(matrix(ncol = 5, nrow = 0))
  colnames(expected_freqs) <- 
    c("allele1", "allele2", "homozygous1", "heterozygous", "homozygous2")
  for (i in 1:ncol(seqs)){
    alleles <- c(unique(seqs[,i]))
    homo1 <- allele[i,2]^2
    hetero <- 2 * allele[i,2] * allele[i,4]
    homo2 <- allele[i,4]^2
    expected_freqs[nrow(expected_freqs) + 1,] <- 
      c(alleles[1], alleles[2], homo1, hetero, homo2)
  }
  expected_freqs$homozygous1 <- as.numeric(expected_freqs$homozygous1)
  expected_freqs$heterozygous <- as.numeric(expected_freqs$heterozygous)
  expected_freqs$homozygous2 <- as.numeric(expected_freqs$homozygous2)
  return(expected_freqs)
  }

expected_freqs <- expected_genotype_calc()

expected_count <- function(freqs = expected_freqs) {
  expected_counts <- freqs
  expected_counts[,3:5] <- expected_counts[,3:5] * 20
  return(expected_counts)
}

expected_counts <- expected_count()

##### Test for HWE ######
chi_squared <- function(expected = expected_counts, observed = genotype_freqs){
  chi_values <- c()
  for (i in 1:nrow(expected_freqs)){
    chi <- 0
    if (expected[i,3] != 0) {
      chi <- chi + ((expected[i,3] - (observed[i,3]*20))^2)/expected[i,3]
    }
    if (expected[i,4] != 0) {
      chi <- chi + ((expected[i,4] - (observed[i,4]*20))^2)/expected[i,4]
    }
    if (expected[i,5] != 0) {
      chi <- chi + ((expected[i,5] - (observed[i,5]*20))^2)/expected[i,5]
    }
    chi_values <- append(chi_values, chi)
  }
  p_values <- c()
  for (i in 1:nrow(expected_freqs)){
    p_value <- 1 - pchisq(chi_values[i], df = 1)
    p_values <- append(p_values, p_value)
  }
  return(p_values)
}

p_values <- chi_squared()

barplot(-log(p_values))

##### Calculate inbreeding coefficients ######
inbreeding_calc <- function(expected = expected_freqs, observed = genotype_freqs){
  f_values <- c()
  for (i in 1:nrow(expected)) {
    f <- (expected[i,4] - observed[i,4])/expected[i,4]
    f_values <- append(f_values, f)
  }
  return(f_values)
}

f_values <- inbreeding_calc()

plot(f_values)
