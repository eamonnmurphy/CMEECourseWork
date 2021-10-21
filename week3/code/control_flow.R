# basic if statement
a <- TRUE
if (a == TRUE){
    print('a is TRUE')
    } else {
    print('a is FALSE')
}

# if on one line
z <- runif(1)
if (z<=0.5) {print('Less than a half')}

# basic for loop
for (i in 1:10){
    j <- i * i
    print(paste(i, ' squared is ', j))
}

# loop over vector of strings
for(species in c('Helidoxa rubinoides',
                'Boissonneaua jardini',
                'Sula nebouxii')){
    print(paste('The species is', species))
}

# for loop using existing vector
v1 <- c('a', 'bc', 'def')
for (i in v1){
    print(i)
}

# basic while loop
i <- 0
while (i < 10){
    i <- i+1
    print(i^2)
}

