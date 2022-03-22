rm(list = ls())
library(tree)
library(randomForest)
library(gbm)
library(lars)
library(e1071)

###### Question 1 #######
# Load in data
data <- read.table("../data/auto-mpg.txt")
data <- data[,-8]

# Fit regression tree
training <- sample(nrow(data), nrow(data) / 2)
model <- tree(mpg~., data = data[training,])

plot(model)
text(model)
model
summary(model)

# Validate regression tree
cor.test(predict(model, data[-training]), data$mpg[-training])
