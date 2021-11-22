growth_data <- read.csv("../data/LogisticGrowthData.csv")
meta_data <- read.csv("../data/LogisticGrowthMetaData.csv")

str(growth_data)

print(unique(growth_data$Temp))
print(unique(growth_data$Time_units))
print(unique(growth_data$PopBio_units))
print(unique(growth_data$Medium))
print(unique(growth_data$Species))
print(unique(growth_data$Citation))
print(unique(growth_data$Rep))

plot(growth_data)

new_data <- read.csv("EditedDataSet.csv")
new_data$Rep <- character(new_data$Rep)

for (i in 1:9) {
  plot(new_data$Time[which(new_data$ID == i)], 
       new_data$PopBio[which(new_data$ID == i)], add = T)
}

plot(new_data$Time[which(new_data$ID == 10)], 
     new_data$PopBio[which(new_data$ID == 10)])

library(ggplot2)
qplot(Time, PopBio, data = subset(new_data, PopBio_units == "OD_595" & Temp == 5),
      colour = ID) + theme(legend.position = "none")

print(new_data$PopBio_units[which(new_data$ID == 89)])

lm(PopBio ~ Time, 
   data = subset(new_data, ID = "100"))

print(unique(new_data$ID[which(new_data$Citation == "Bernhardt, J.R., Sunday, J.M. and O’Connor, M.I., 2018. Metabolic theory and the temperature-size rule explain the temperature dependence of population carrying capacity. The American naturalist, 192(6), pp.687-697.")]))

qplot(Time, PopBio, data = subset(new_data, Citation == "Bernhardt, J.R., Sunday, J.M. and O’Connor, M.I., 2018. Metabolic theory and the temperature-size rule explain the temperature dependence of population carrying capacity. The American naturalist, 192(6), pp.687-697."),
      colour = as.character(Rep)) + theme(legend.position = "none") + geom_smooth(se = F)

for (i in 1:5) {
  model <- paste("model", i, sep = "")
  m <- lm(PopBio ~ Time, data = subset(new_data, Citation == "Bernhardt, J.R., Sunday, J.M. and O’Connor, M.I., 2018. Metabolic theory and the temperature-size rule explain the temperature dependence of population carrying capacity. The American naturalist, 192(6), pp.687-697."
                                  & Rep == i),
  )
  assign(model, )
}

model <- lm(PopBio ~ Time + as.character(Rep), data = subset(new_data, Citation == "Bernhardt, J.R., Sunday, J.M. and O’Connor, M.I., 2018. Metabolic theory and the temperature-size rule explain the temperature dependence of population carrying capacity. The American naturalist, 192(6), pp.687-697."))
