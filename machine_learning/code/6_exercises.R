rm(list = ls())

###### Question 1 #######
data <- read.csv("../data/boardgames-continuous.csv", row.names = 1,
                 as.is = T)
with(data, plot(rating ~ year))
response <- data$rating
explanatory <- as.matrix(data[,-1])
ncol(explanatory)
explanatory <- scale(explanatory)

training <- sample(nrow(explanatory), nrow(explanatory) / 2)

# Training a deep learning network
library(keras)

model <- keras_model_sequential()
model %>%
  layer_dense(units = 15, activation = "linear", input_shape = 11) %>%
  layer_dense(units = 15, activation = "linear") %>%
  layer_dense(units = 1)

model %>% compile(
  loss = "mean_squared_error",
  optimizer = optimizer_rmsprop(),
  metrics = c("mean_squared_error")
)

model %>% fit(explanatory[training,], response[training], epoch = 500)

plot(predict(model, explanatory[-training,])[,1] ~ response[-training])
cor.test(predict(model, explanatory[-training,])[,1], response[-training])
abline(0, 1)
