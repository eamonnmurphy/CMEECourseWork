## Is Florida getting warmer? ##
# Calculate correlation coeffecients between temp and time
# Use a permutation analysis for p values

# Load in data
rm(list = ls())
load("../data/KeyWestAnnualMeanTemperature.RData")

# Inspect data
class(ats)
head(ats)
plot(ats)

# Calculate correlation between year and temperature
correlation <- cor(ats$Year, ats$Temp, method = "spearman")

# Create empty vector
cor_vec <- c()

# Calculate correlations for randomly shuffled temperatures
for(i in 1:10000){
  cor_vec <- append(cor_vec, cor(ats$Year[],
                                 sample(ats$Temp[], nrow(ats)),
                                 method = "spearman"))
}

# Get number of randoms correlations > original and calculate
# p value
num <- sum(cor_vec > correlation)
p_value <- num/100000
