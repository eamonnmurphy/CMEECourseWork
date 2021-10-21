## Testing out the try function

doit <- function(x){
  # Function to calculate mean of sample pops
  temp_x <- sample(x, replace = TRUE)
  if(length(unique(temp_x)) > 30){
    print(paste("Mean of this sample was:", as.character(mean(temp_x))))
  }
  else{
    stop("Couldn't calculate mean: too few unique values!")
  }
}

# Generate histogram of pop
set.seed(1345)
popn <- rnorm(50)
hist(popn)

# Repeat sampling exercise
lapply(1:15, function(i) try(doit(popn), FALSE))

# Store results
result <- vector("list", 15) # Preallocate/Initialize
for(i in 1:15){
  result[[i]] <- try(doit(popn), FALSE)
}
