NoPreallocFun <- function(x){
  a <- vector()
  for (i in 1:x){
    a <- c(a, i)
    #print(a)
    #print(object.size(a))
  }
}

print(system.time(NoPreallocFun(100000)))

PreallocFun <- function(x){
  a <- rep(NA, x)
  for (i in 1:x){
    a[i] <- i
    #print(a)
    #print(object.size(a))
  }
}

print(system.time(PreallocFun(100000)))
