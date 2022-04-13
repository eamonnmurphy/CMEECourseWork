# Class work for supervised methods
rm(list = ls())

##### Regression trees #######
# Build model of species diversity
data <- expand.grid(temperature = seq(0,40,4), humidity = seq(0,100,10),
                    carbon = seq(1,10,1),  herbivores=seq(0,20,2))
data$plants <- runif(nrow(data), 3, 5)
data$plants <- with(data, plants + temperature * .1)
data$plants[data$humidity > 50] <- with(data[data$humidity > 50,],
                                        plants + humidity * .05)
data$plants[data$carbon < 2] <- with(data[data$carbon < 2,], plants - carbon)
data$plants <- with(data, plants + herbivores * .1)
data$plants[data$herbivores > 5 & data$herbivores < 15] <-
  with(data[data$herbivores > 5 & data$herbivores < 15,], plants - herbivores * .2)

# Draw random data from Poisson
for(i in seq_len(nrow(data)))
{
  data$plants[i] <- rpois(1, data$plants[i])
}

# Regression tree
library(tree)

# Pick some training data and then fit a model to it
training <- sample(nrow(data), nrow(data) / 2)
model <- tree(plants ~ ., data = data[training,])

# Examine the model
plot(model)
text(model)

# Look at the statistics of the model
model
summary(model)

# Check performance outside training set
cor.test(predict(model, data[-training,]), data$plants[-training])

# Check cross-validaation of model
plot(cv.tree(model))

# Bagged regression trees
library(randomForest)
model <- randomForest(plants~., data = data[training,], mtry = ncol(data) - 1)
cor.test(predict(model, data[-training,]), data$plants[-training])

# Random forest
rf.model <- randomForest(plants~., data = data[training,], importance = T)
importance(rf.model)
cor.test(predict(rf.model, data[-training,]), data$plants[-training])

# Boosted regression trees
library(gbm)
model <- gbm(plants~., data = data[training,], distribution = "poisson")
summary(model)

faster.model <- gbm(plants~., data = data[training,], distribution = "poisson",
                    shrinkage = .1)
summary(faster.model)

####### Lasso / LAR #######
explanatory <- replicate(1000, rnorm(1000))
response <- explanatory[,123] * 1.5 -explanatory[,678] *.5

# Fit lasso regression
library(lars)
model <- lars(explanatory, response, type = "lasso")
plot(model)

# Grab coefficient estimates
signif.coefs <- function(model, threshold = .001)
{
  coefs <- coef(model)
  signif <- which(abs(coefs[nrow(coefs),]) > threshold)
  return(setNames(coefs[nrow(coefs), signif], signif))
}
signif.coefs(model)

# Least angle regression
model <- lars(explanatory, response, type = "lar")
plot(model)
signif.coefs(model)

# Turn off scaling
bad.model <- lars(explanatory, response, type = "lar", normalize = F)
signif.coefs(bad.model, threshold = 0)
signif.coefs(model, threshold = 0)

####### SVMs #####
data <- data.frame(replicate(2, rnorm(1000)))
data$y = (rowSums(data) > (median(rowSums(data)) - 1)) & 
  (rowSums(data) < (median(rowSums(data)) + 1))
with(data, plot(data[,1:2], pch = 20, col = ifelse(y, "red", "blacK")))

 # Fit the SVM using radial kernel
library(e1071)
training <- sample(nrow(data), nrow(data) / 2)
model <- svm(y~., data = data[training,], type = "C")
plot(model, data[training,])

table(predict(model, data[-training,]), data$y[-training])
