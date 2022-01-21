## Is Florida getting warmer? ##
# Calculate correlation coeffecients between temp and time
# Use a permutation analysis for p values

# Load in data
library(ggplot2)
rm(list = ls())
load("../data/KeyWestAnnualMeanTemperature.RData")
set.seed(1)

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
p_value <- num/10000

# Create images for Latex file
png("../results/temp_year_scatter.png")
plot(x = ats$Year, y = ats$Temp, xlim = c(1900,2000), ylim = c(23.5, 26.5),
     xlab = "Year", ylab = "Temperature (Degrees Celcius)", pch = 16,
     col = "blue", cex.axis = 1.2, cex.lab = 1.6) + 
  abline(lm(ats$Temp ~ ats$Year), col = "black", lwd = 2)
dev.off()


png("../results/coeff_distro.png")
hist(cor_vec, main = NULL, xlab = "Correlation coefficients", col = "lightblue",
     cex.axis = 1.2, cex.lab = 1.6, ylim = c(0,2000))
dev.off()
