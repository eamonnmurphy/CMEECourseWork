# Artificial neural networks
data <- read.csv("../data/winequality-red.csv", sep = ";")
data[,1:11] <- data.frame(scale(data[,1:11]))
training <- sample(nrow(data), nrow(data) / 2)

# Question 1
library(neuralnet)
model <- neuralnet(quality~fixed.acidity+volatile.acidity+citric.acid+residual.sugar+chlorides+free.sulfur.dioxide+total.sulfur.dioxide+density+pH+sulphates+alcohol,
                   data = data[training,], hidden = 5)

cor.test(compute(model, data[-training, 1:11])$net.result[,1],
         data$quality[-training])
plot(model)

# Most important factors
library(NeuralNetTools)
garson(model, bar_plot = F)
garson(model)
