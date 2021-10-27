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

# Read data and look at feeding interaction data
MyDF <- read.csv("../data/EcolArchives-E089-51-D1.csv")
altered_df <- MyDF %>% subset(select = c(Predator.mass, Prey.mass, Type.of.feeding.interaction))
table(altered_df$Type.of.feeding.interaction)

# Split into seperate DFs based on feeding interaction
pred_pisc <- altered_df %>% filter(Type.of.feeding.interaction == "predacious/piscivorous")
insect <- altered_df %>% filter(Type.of.feeding.interaction == "insectivorous")
pisc <- altered_df %>% filter(Type.of.feeding.interaction == "piscivorous")
plank <- altered_df %>% filter(Type.of.feeding.interaction == "planktivorous")
pred <- altered_df %>% filter(Type.of.feeding.interaction == "predacious")

for (df in c(pred_pisc, insect, pisc, plank, pred)) {
  df <- subset(df, select = c(Predator.mass, Prey.mass))
}

c(pred_pisc, insect, pisc, plank, pred) <- c(pred_pisc, insect, pisc, plank, pred) %>%
  subset(select = c(Predator.mass, Prey.mass))
################
# Calculate log mean and median predator mass, prey mass and predator-
# prey size-ratios to a csv file. Should have appropriate headers
# (initialise a new dataframe to store the calculations)
# File name: PP_Results.csv
# Calculate body size stats by tapply or ddply

print(mean(pred_pisc))
output_df <- data.frame()
output_df$Names <- c("Predacious/piscivorous", "Insectivorous", "Piscivorous",
                     "Planktivorous", "Predacious")
output_df$Log_mean_predator_mass <- c(mean(pred_pisc$Predator.mass), mean(insect$Predator.mass), 
                                      mean(pisc$Predator.mass), mean(plank$Predator.mass), 
                                      mean(pred$Predator.mass))
print(c(mean(pred_pisc$Predator.mass), mean(insect$Predator.mass), 
        mean(pisc$Predator.mass), mean(plank$Predator.mass), 
        mean(pred$Predator.mass)))