# Coalescence Theory #

###### Load in the data #####
killer_north <- read.csv("../data/killer_whale_North.csv", 
                         header = F, colClasses = c("character"))
killer_south <- read.csv("../data/killer_whale_South.csv", 
                          header = F, colClasses = c("character"))

# Calculate the genetic diversity
# Watterson's: theta = S / (sum(1/k) from 1 to n -1)

S_count <- function(seqs){
  snps <- c()
  for (i in 1:ncol(seqs)) {
    if (length(unique(seqs[,i])) > 1) {
      snps <- append(snps, i)
    }
  }
  count <- length(snps)
  return(count)
}

snp_finder <- function(seqs){
  snps <- c()
  for (i in 1:ncol(seqs)) {
    if (length(unique(seqs[,i])) > 1) {
      snps <- append(snps, i)
    }
  }
  return(snps)
}

snp_north <- snp_finder(killer_north)
snp_south <- snp_finder(killer_south)

S_north <- S_count(killer_north)
S_south <- S_count(killer_south)

seg_site_north <- killer_north[,snp_north]
seg_site_south <- killer_south[,snp_south]

watterson_estimator <- function(S, n){
  theta = S / sum(1/(1:(n-1)))
  return(theta)
}

watterson_north <- watterson_estimator(S_north, 20)
watterson_south <- watterson_estimator(S_south, 20)

# Tajima's: pi = sum(d(i,j)) / ((n-1)/2)

tajima_estimator <- function(seq, n){
  tot = 0
  i = 1
  
  for (x in i:(nrow(seq)-1)) {
    for (y in (i+1):nrow(seq)) {
      tot = tot + sum(seq[x,] == seq[y,])
    }
  }

  pi = tot / ((n*(n-1))/2)
  
  return(pi)
}

tajima_north <- tajima_estimator(seg_site_north, 20)
tajima_south <- tajima_estimator(seg_site_south, 20)

# theta = 4Nmu
mu = 1 * (10 ** -8)
Ne_watterson_north <- watterson_north / (4 * mu * ncol(killer_north))
Ne_watterson_south <- watterson_south / (4 * mu * ncol(killer_north))

Ne_tajima_north <- tajima_north / (4 * mu * ncol(killer_north))
Ne_tajima_south <- tajima_south / (4 * mu * ncol(killer_north))

# Calculate the site frequency spectrum
seg_site_north[] <- lapply(seg_site_north, function(x)
  as.numeric(x))
seg_site_south[] <- lapply(seg_site_south, function(x)
  as.numeric(x))

SFS_counter <- function(sites) {
  allele_freq <- c()
  for (i in 1:ncol(sites)){
    allele_freq <- colSums(sites)
  }
  
  SFS <- c()
  for (i in 1:nrow(sites)-1){
    SFS[i] <- (sum(allele_freq == i)/ncol(sites))
  }
  return(SFS)
}

SFS_north <- SFS_counter(seg_site_north)
SFS_south <- SFS_counter(seg_site_south)

SFS_expected <- c((1/1:19)/sum(1/(1:19)))

barplot(t(cbind(SFS_north, SFS_south, SFS_expected)), beside = T, legend.text = T)
