#################################################
# GENE DRIVE SIMULATOR. WRITTEN IN R
# CMEE MSc 2022 TIN-YU HUI
# DRIFT: WRIGHT-FISHER MODEL
# SELECTION: 11 HOMOZYGOTES ARE LETHAL
# DRIVE: SUPER-MENDELIAN INHERITANCE OF TG WITH RATIO d, d>0.5
# 0=WT ALLELE; 1=TG ALLELE
#################################################

# INPUT PARAMETERS: 
# q0: INITIAL RELEASING FREQ OF TG
# N0: INITIAL POPULATION SIZE (DIPLOID)
# d: TRANSMISSION RATE OF TG (d>0.5 IN ORDER TO DRIVE)
# t: NUMBER OF GENERATIONS TO SIMUATE FORWARD IN TIME
# R0, M: TWO EXTRA PARAMETERS FOR THE BEVERTON-HOLT MODEL FOR POPULATION REGULATION

sim_gene_drive<-function(q0=0.05, d=0.6, t=10, N0=500, R0=2, M=500)
{
# SOME CHECKS ON THE INPUT PARAMETERS (OPTIONAL)
if (q0<=0 || q0>0.5)
	{stop('PLEASE MAKE SURE THAT 0<q0<0.5!')}
if (d<=0.5 || d>=1)
	{stop('PLEASE MAKE SURE THAT 0.5<d<1!')}

	# INNER FUNCTIONS. THESE INNER FUNCTIONS ARE ONLY VISIBLE WITHIN sim_gene_drive()
	# 1) THE BEVERTON-HOLT MODEL. ceiling() TO ROUND UP. RETURN NEW POPULATION SIZE. 
	bh<-function(N, R0, M)
	{return(ceiling(R0*N/(1+N/M)))}
	# 2) RETURN THE COUNTS FOR 00, 01, 11 GENOTYPES
	count_genotype<-function(x)
	{
	temp<-apply(x, 2, sum)
	return(c(sum(temp==0), sum(temp==1), sum(temp==2)))
	}
# INITIALISE
# CREATE A LIST TO STORE ALL THE ALLEIC CONFIGURATIONS
population<-list()
length(population)<-(t+1)
for (i in 1:(t+1))
{names(population)[i]<-paste(c('generation', i-1), collapse='')}
# ALSO CREATE TWO VECTORS TO STORE THE POPULATION SIZES AND THE FREQ OF TG OVER TIME
population.size<-rep(NA, t+1)
TG.freq<-rep(NA, t+1)

# INITIAL POPULATION SIZE AND TG FREQ
population.size[1]<-N0
TG.freq[1]<-q0

# WE WILL RELEASE k TRANSGENIC MOSQUITOES, WHO CARRY 01 HETEROZYGOTE
# WHICH MEANS AT GEN 0 THERE ARE (N0-k) WT MOSQUITOES WITH 00 HOMOZYGOTES
k<-ceiling(2*N0*q0)
population[[1]]<-cbind(matrix(c(0,0), nr=2, nc=N0-k), matrix(c(0,1), nr=2, nc=k))
# CALCULATE THE GENOTYPE COUNTS (WE'LL REUSE THE VECTOR genotype IN THE FOR LOOP)
genotype<-count_genotype(population[[1]])
# PROPAGATION
for (i in 1:t)
{
	# CALCULATE THE NEW POPULATION SIZE. ONLY genotype[1]+genotype[2] WILL SURVIVE TILL ADULTHOOD 
	population.size[i+1]<-bh(genotype[1]+genotype[2], R0, M)	
	# EARLY EXIT CONDITION 1, IF POPULATION SIZE DROP TO 1
	if (population.size[i+1]<=1)
	{
		print(paste(c('Oops! The population crashed after generation ', i-1), collapse=''))
		return(list(population=population[1:i], population.size=population.size[1:i], 
			TG.freq=TG.freq[1:i]))
	}
	# EARLY EXIT CONDITION 2, IF THERE IS NO MORE TG ALLELE
	if (genotype[2]+genotype[3]==0)
	{
		print(paste(c('Oops! TG allele went extinct at generation ', i-1), collapse=''))
		return(list(population=population[1:i], population.size=population.size[1:i], 
			TG.freq=TG.freq[1:i]))
	}
	# CALCULATE TG GAMETIC FREQ
	TG.gametic.freq<-d*genotype[2]/(genotype[1]+genotype[2])
	# SAMPLE THE NEXT GENERATION
	population[[i+1]]<-matrix(sample(0:1, size=2*population.size[i+1], 
				prob=c(1-TG.gametic.freq, TG.gametic.freq), replace=T), nr=2)
	# CALCULATE NEW GENOTYPE COUNTS AND TG FREQ
	genotype<-count_genotype(population[[i+1]])
	TG.freq[i+1]<-(0.5*genotype[2]+genotype[3])/population.size[i+1]	
}
# OUTPUTS. RETURN A BIG LIST OF EVERYTHING
return(list(population=population, population.size=population.size, TG.freq=TG.freq))
}

###### Problem III #####
require(doParallel)
c1 <- makeCluster()
registerDoParallel(c1)
transmission_tests <- seq(0.51, 0.99, length.out = 100)
sims <- list()
length(sims) <- 100
for (i in 1:100) {
  temp <- sim_gene_drive(t = 30, d = transmission_tests[i])
  sims[i] <- temp$population.size[length(temp$population.size)]
}

plot(transmission_tests, sims)
abline(h = 300)

###### Problem IV #########
require(doParallel)
c1 <- makeCluster(7)
registerDoParallel(c1)
popa_sims <- foreach(i = 1:1000, .combine = "cbind") %dopar%
  {
    popa <- sim_gene_drive(d = 0.75, t = 30, R0 = 2, M = 500)[[2]]
    return(popa)
  }
stopCluster(c1)

c2 <- makeCluster(7)
registerDoParallel(c2)
popb_sims <- foreach(i = 1:1000, .combine = "cbind") %dopar%
  {
    popb <- sim_gene_drive(d = 0.75, t = 30, R0 = 6, M = 100)[[2]]
    return(popb)
  }
stopCluster(c2)

popa_mean <- rep(NA, 31)
popb_mean <- rep(NA, 31)

for (i in 1:31)
{
  popa_mean[i] <- mean(popa_sims[i,])
  popb_mean[i] <- mean(popb_sims[i,])
}

plot(0:30, popa_mean, type = "l", xlab = "Time", ylab = "N (population size)")
lines(0:30, popb_mean, col = "red")
legend(x = "topright", legend = c("R0 = 2, M = 500", "R0 = 6, M = 100"), 
       col = c(1,2), lty = c(1,1))

#### Problem V #####
freqs <- seq(0.01, 0.49, length.out = 100)

require(doParallel)
c1 <- makeCluster(7)
registerDoParallel(c1)
q0_sims_a <- foreach(i = 1:100, .combine = "cbind") %dopar%
  {
    popa <- sim_gene_drive(d = 0.6, t = 50, q0 = freqs[i])[[3]]
    return(popa)
  }

q0_sims_b <- foreach(i = 1:100, .combine = "cbind") %dopar%
  {
    popa <- sim_gene_drive(d = 0.7, t = 50, q0 = freqs[i])[[3]]
    return(popa)
  }

q0_sims_c <- foreach(i = 1:100, .combine = "cbind") %dopar%
  {
    popa <- sim_gene_drive(d = 0.8, t = 50, q0 = freqs[i])[[3]]
    return(popa)
  }

q0_sims_d <- foreach(i = 1:100, .combine = "cbind") %dopar%
  {
    popa <- sim_gene_drive(d = 0.9, t = 50, q0 = freqs[i])[[3]]
    return(popa)
  }
stopCluster(c1)

plot(0:50, q0_sims_a[,1], type = "l", ylim = c(0,1))
for (i in 1:1000) {
  try(lines(0:50, q0_sims_a[,i]), silent = T)
  try(lines(0:50, q0_sims_b[,i], col = "red"), silent = T)
  try(lines(0:50, q0_sims_c[,i], col = "blue"), silent = T)
  try(lines(0:50, q0_sims_d[,i], col = "green"), silent = T)
}

