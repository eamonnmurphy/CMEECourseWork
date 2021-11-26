####### Load in the data #####
rm(list = ls())
growth_data <- read.csv("../data/LogisticGrowthData.csv")
meta_data <- read.csv("../data/LogisticGrowthMetaData.csv")

###### Basic exploration ######
str(growth_data)

print(unique(growth_data$Temp))
print(unique(growth_data$Time_units))
print(unique(growth_data$PopBio_units))
print(unique(growth_data$Medium))
print(unique(growth_data$Species))
print(unique(growth_data$Citation))
print(unique(growth_data$Rep))

##### Examining values of < 0 ######
range(growth_data$PopBio)
sum(growth_data$PopBio < 0)
unique(growth_data$Citation[which(growth_data$PopBio < 0)])

plot(growth_data)

##### Load in dataset with IDs ########
new_data <- read.csv("EditedDataSet.csv")
new_data$Rep <- character(new_data$Rep)
str(new_data)

###### Examining values of < 0 #######
unique(new_data$ID[which(new_data$PopBio < 0)])
unique(new_data$ID[which(new_data$PopBio == 0)])

unique(new_data$PopBio_units[which(new_data$PopBio < 0)])

# For now, remove IDs with negative values of PopBio (will check papers after)
to_remove <- unique(new_data$ID[which(new_data$PopBio < 0)])
new_data <- subset(new_data, !(new_data$ID %in% to_remove))

# Examining time
unique(new_data$ID[which(new_data$Time < 0)])
unique(new_data$Citation[which(new_data$Time < 0)])
range(new_data$Time)

# Will standardize time in each experiment after removing replicates

##### Exploring replicated experiments ######
library(ggplot2)
print(unique(new_data$ID[which(new_data$Citation == "Bernhardt, J.R., Sunday, J.M. and O’Connor, M.I., 2018. Metabolic theory and the temperature-size rule explain the temperature dependence of population carrying capacity. The American naturalist, 192(6), pp.687-697.")]))

qplot(Time, PopBio, data = subset(new_data, Citation == "Bernhardt, J.R., Sunday, J.M. and O’Connor, M.I., 2018. Metabolic theory and the temperature-size rule explain the temperature dependence of population carrying capacity. The American naturalist, 192(6), pp.687-697."),
      colour = as.character(Rep)) + theme(legend.position = "none") + geom_smooth(se = F)

model_reps <- lm(PopBio ~ Time + as.character(Rep), data = subset(new_data, Citation == "Bernhardt, J.R., Sunday, J.M. and O’Connor, M.I., 2018. Metabolic theory and the temperature-size rule explain the temperature dependence of population carrying capacity. The American naturalist, 192(6), pp.687-697."))
summary(model_reps)

# No significant differences between replicates
print(c("P values for difference of replicate one to other replicates:",
              summary(model_reps)$coefficients[3:6,4]))

# Remove replicates 2 to 5 as no significant differences
new_data <- new_data[which(new_data$Rep == 1),]

# Standardize times
for (i in 1:length(unique(new_data$ID))) {
  rows <- which(new_data$ID == i)
  new_data$Time[rows] <- new_data$Time[rows] - min(new_data$Time[rows])
}

# Remove redundant data columns
new_data <- subset(new_data, select = c(ID, Time, PopBio, PopBio_units))

new_data$ln_PopBio <- log(new_data$PopBio)

# Deal with zero values by setting to lowest value of log
new_data$ln_PopBio[which(new_data$ln_PopBio == -Inf)] <- -12

##### Write newly wrangled data to new csv #######
write.csv(new_data, "WrangledDataSet.csv", row.names = FALSE)

