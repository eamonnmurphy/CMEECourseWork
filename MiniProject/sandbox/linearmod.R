rm(list = ls())
library(ggplot2)
data <- read.csv("WrangledDataSet.csv")

# Exploratory plotting and analysis
OD_595_data <- data[which(data$PopBio_units == "OD_595"),]
plot(OD_595_data$Time, log(OD_595_data$PopBio))

OD_595_quad <- lm(PopBio ~ poly(Time, 2),
             data = OD_595_data[which(OD_595_data$ID == 1),])
summary(OD_595_quad)
par(mfcol = c(2,2))
plot(OD_595_quad)
dev.off()

# Plot the model
par(mfcol = c(2,1))

predicted_1 <- predict.lm(OD_595_quad, OD_595_data[which(OD_595_data$ID ==1),])
p <- ggplot(OD_595_data[which(OD_595_data$ID == 1),], aes(Time, log(PopBio))) + geom_point() +
  geom_line(aes(Time[which(ID == 1)], log(predicted_1)))
p

OD_595_cubic <- lm(PopBio ~ poly(Time, 3),
                   data = OD_595_data[which(OD_595_data$ID == 1),])
summary(OD_595_cubic)
predicted_2 <- predict.lm(OD_595_cubic, OD_595_data[which(OD_595_data$ID ==1),])
q <- ggplot(OD_595_data[which(OD_595_data$ID == 1),], aes(Time, log(PopBio))) + geom_point() +
  geom_line(aes(Time[which(ID == 1)], log(predicted_2)))
q
