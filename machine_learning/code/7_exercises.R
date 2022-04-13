# Section 7 on convolutional neural networks
rm(list = ls())
library(keras)

# Load the dataset
mnist <- dataset_mnist()
x_train <- mnist$train$x
y_train <- mnist$train$y
x_test <- mnist$test$x
y_test <- mnist$test$y

# Define the model
# Should be flat, two hidden layers
model <- keras_model_sequential()
model %>%
  layer_flatten(input_shape = c(28, 28)) %>%
  layer_dense(units = 128, activation = "relu") %>%
  layer_dropout(rate = 0.5) %>%
  layer_dense(units = 10, activation = "softmax")
model %>% compile(
  optimizer = "adam",
  loss = "sparse_categorical_crossentropy",
  metrics = c("accuracy")
)

# Fit the model
model %>% fit(x_train, y_train, epochs = 5)

# Validate model
model %>% evaluate(x_test, y_test)
predictions <- model %>% predict(x_test)
table(apply(predictions, 1, which.max) - 1, y_test)

# Convolutional model
                                                                                                                                                                                                                                                                                                                                    conv <- keras_model_sequential() %>%
  layer_conv_2d(filters = 1, kernel_size = c(3,3), activation = "relu",
                input_shape = c(28,28,1)) %>%
  layer_max_pooling_2d(pool_size = c(2,2)) %>%
  #layer_dropout(rate = 0.5) %>%
  layer_flatten() %>%
  layer_dense(units = 20, activation = "relu") %>%
  layer_dense(units = 10, activation = "softmax") %>%
  compile(
    optimizer = "adam",
    loss = "sparse_categorical_crossentropy",
    metrics = c("accuracy")
  )

array.x_train <- array(x_train, dim = c(dim(x_train), 1))
conv %>% fit(array.x_train, y_train, epochs = 5)

# Validate model
conv %>% evaluate(x_test, y_test)
predictions <- conv %>% predict(x_test)
table(apply(predictions, 1, which.max) - 1, y_test)
