## Draw and save three figures, and a .csv file ##

###############
# Create three figures, each containing subplots of distributions
# of predator mass, prey mass, and size ratio of prey mass over
# predator mass, *by feeding interaction type*. Use log of mass.
# Files to create: Pred_Subplots.pdf, Prey_Subplots.pdf and
# SizeRatio_Subplots.pdf
# Use par() to create subplots

require(dplyr)
require(tidyverse)
require(dplyr)

rm(list = ls())

# Read data and look at feeding interaction data
MyDF <- read.csv("../data/EcolArchives-E089-51-D1.csv")
altered_df <- MyDF %>% subset(select = c(Predator.mass, Prey.mass, Type.of.feeding.interaction))
altered_df$Size.ratio <- (altered_df$Predator.mass/altered_df$Prey.mass)
table(altered_df$Type.of.feeding.interaction)

# Create 5 subplots for predator mass by feeding interaction type
pdf("../results/Pred_Subplots.pdf")
par(mfrow = c(3,2))
for (type in unique(altered_df$Type.of.feeding.interaction)) {
  plot(density(subset(log(altered_df$Predator.mass),
                      altered_df$Type.of.feeding.interaction == type)),
       xlab = "Log of Predator Mass (g)", main = paste(type))
}
dev.off()

# Create subplots for prey mass by feeding interaction type
pdf("../results/Prey_Subplots.pdf")
par(mfrow = c(3,2))
for (type in unique(altered_df$Type.of.feeding.interaction)) {
  plot(density(subset(log(altered_df$Prey.mass),
                      altered_df$Type.of.feeding.interaction == type)),
       xlab = "Log of Prey Mass (g)", main = paste(type))
}
dev.off()

# Create subplots for size ratios
pdf("../results/SizeRatio_Subplots.pdf")
par(mfrow = c(3,2))
for (type in unique(altered_df$Type.of.feeding.interaction)) {
  plot(density(subset((log(altered_df$Size.ratio)),
                      altered_df$Type.of.feeding.interaction == type)),
       xlab = "Log of Predator:Prey Size Ratio", main = paste(type))
}
dev.off()

################
# Calculate log mean and median predator mass, prey mass and predator-
# prey size-ratios to a csv file. Should have appropriate headers
# (initialise a new dataframe to store the calculations)
# File name: PP_Results.csv
# Calculate body size stats by tapply or ddply

columns <- c("Log_mean_predator_mass_g" ,
             "Log_mean_prey_mass_g" ,
             "Log_predator:prey_size_ratio")

output_df <- data.frame(matrix(nrow = 0,
                               ncol = length(columns)))

colnames(output_df) <- columns

for (type in unique(altered_df$Type.of.feeding.interaction)) {
  output_df[type,1] <- mean(subset((log(altered_df$Predator.mass)),
                                   altered_df$Type.of.feeding.interaction == type))
  output_df[type,2] <- mean(subset((log(altered_df$Prey.mass)),
                                   altered_df$Type.of.feeding.interaction == type))
  output_df[type,3] <- mean(subset(log(altered_df$Size.ratio),
                                   altered_df$Type.of.feeding.interaction == type))
}

write.csv(output_df, "../results/PP_Results.csv")
