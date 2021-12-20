# CMEE 2021 HPC excercises R code main pro forma
# you don't HAVE to use this but it will be very helpful.  If you opt to write everything yourself from scratch please ensure you use EXACTLY the same function and parameter names and beware that you may loose marks if it doesn't work properly because of not using the proforma.

name <- "Eamonn Murphy"
preferred_name <- "Eamonn"
email <- "etm21@ic.ac.uk"
username <- "etm21"

# please remember *not* to clear the workspace here, or anywhere in this file. If you do, it'll wipe out your username information that you entered just above, and when you use this file as a 'toolbox' as intended it'll also wipe away everything you're doing outside of the toolbox.  For example, it would wipe away any automarking code that may be running and that would be annoying!

# Question 1
species_richness <- function(community){
  # Count unique species values
  richness <- length(unique(community))
  return(richness)
}

# Question 2
init_community_max <- function(size){
  # Create vector of values 1:size
  max <- seq(1, size)
  return(max)
}

# Question 3
init_community_min <- function(size){
  # Repeat 1 for vector of length size
  min <- rep.int(1, size)
  return(min)
}

# Question 4
choose_two <- function(max_value){
  # Sample from 1:max_value without replacement
  pair <- sample(max_value, 2)
  return(pair)
}

# Question 5
neutral_step <- function(community){
  # Pick indices of community vector using choose_two
  pair <- choose_two(length(community))
  # Replace species 1 with species 2
  community[pair[1]] <- community[pair[2]]
  return(community)
}

# Question 6
neutral_generation <- function(community){
  # Set steps at community size/2, adding random number to round randomly if odd
  steps <- round((length(community)/2) + runif(1,-0.1,0.1))
  
  # Perform replacements for the number of steps given above
  for (i in 1:steps) {
    community <- neutral_step(community)
  }
  return(community)
}

# Question 7
neutral_time_series <- function(community,duration)  {
  # Create vector with initial species richness
  time_series <- c(species_richness(community))
  
  # Simulate generation and append richness to time_series for duration given
  for (i in 1:duration) {
    community <- neutral_generation(community)
    richness <- species_richness(community)
    time_series <- append(time_series, richness)
  }
  return(time_series)
}

# Question 8
question_8 <- function() {
  # clear any existing graphs and plot your graph within the R window
  graphics.off()
  
  # Generate time series data
  time_series <- neutral_time_series(init_community_max(100), 200)
  
  # Create line plot of no. of species vs. generation
  plot(time_series, type = "l", xlab = "Generations", ylab = "Number of species",
       main = "Neutral model simulation for 200 generations", col = "navyblue",
       xlim = c(0,200), ylim = c(0,100))
  
  answer <- "The system will always converge to fixation with only one species.
  This is because species will be lost when, through random chance, all individuals
  in that species die, and there is no process to replace these lost species."
  return(answer)
}

# Question 9
neutral_step_speciation <- function(community,speciation_rate)  {
  # Generate number between 0 and 1
  chance <- runif(1)
  
  # Choose pair for replacement
  pair <- choose_two(length(community))
  
  if (chance > speciation_rate) { # Carry out replacement
    community[pair[1]] <- community[pair[2]]
  } else { # Generate new species
    new_species <- max(community) + 1
    community[pair[1]] <- new_species
  }
  return(community)
}

# Question 10
neutral_generation_speciation <- function(community,speciation_rate)  {
  # Set steps at community size/2, adding random number to round randomly if odd
  steps <- round((length(community)/2) + runif(1,-0.1,0.1))
  
  # Perform replacements/speciation for the number of steps given above
  for (i in 1:steps) {
    community <- neutral_step_speciation(community, speciation_rate)
  }
  return(community)
}

# Question 11
neutral_time_series_speciation <- function(community,speciation_rate,duration)  {
  # Init vector with initial species richness
  time_series <- c(species_richness(community))
  
  # Carry out neutral model with speciation for x generations
  for (i in 1:duration) {
    community <- neutral_generation_speciation(community,speciation_rate)
    richness <- species_richness(community)
    time_series <- append(time_series, richness)
  }
  return(time_series)
}

# Question 12
question_12 <- function()  {
  # clear any existing graphs and plot your graph within the R window
  graphics.off()
  
  # Create time series for minimally and maximally diverse starting communities
  max_series <- neutral_time_series_speciation(init_community_max(100), 0.1, 200)
  min_series <- neutral_time_series_speciation(init_community_min(100), 0.1, 200)
  
  # Create line plot of no. of species vs generations
  plot(max_series, type = "l", ylab = "Number of species", xlab = "Generations",
       main = "Neutral model simulation with speciation", col = "navyblue",
       xlim = c(0,200), ylim = c(0,100))
  lines(min_series, col = "red") # Add lines for min. diversity start
  legend("topright", legend = c("Maximum initial species richness",
                                "Minimum initial species richness"),
         lty = 1, col = c("navyblue","red"))
  
  answer <- "This plot shows that for any set of initial conditions, the species
  richness quickly reaches an equilibrium which is determined by the speciation rate.
  These particular results are a function of the speciation rate. At a different
  speciation rate, the equilibrium will reach a different point."
  return(answer)
}

# Question 13
species_abundance <- function(community)  {
  # Use table to count occurences of each species
  counts <- as.data.frame(table(community))[,2]
  # Put counts into descending order
  abundance <- sort(counts, decreasing = TRUE)
  return(abundance)
}

# Question 14
octaves <- function(abundance_vector) {
  # Initialise vector
  converted <- vector(length = length(abundance_vector))
  # Convert abundances to log value below them (+1 as log2(1) = 0 and we want 1)
  converted[] <- floor(log2(abundance_vector[])) + 1
  octed <- tabulate(converted) # Count number of times each value occurs
  return(octed)
}

# Question 15
sum_vect <- function(x, y) {
  # Add extra 0s to the shorter vector
  if (length(x) < length(y)) {
    x <- append(x, rep(0, length(y)-length(x)))
  } else if (length(y) < length(x)) {
    y <- append(y, rep(0, length(x)-length(y)))
  }
  sum <- x + y # add vectors, now of equal length
  return(sum)
}

# Question 16 
question_16 <- function()  {
  # clear any existing graphs and plot your graph within the R window
  graphics.off()
  
  # Init community and simulate generations under neutral mdoel
  comm <- init_community_max(100)
  for (i in 1:200) {
    comm <- neutral_generation_speciation(comm, 0.1)
  }
  x <- octaves(species_abundance(comm))
  
  # Record octaves for every 20th gen and sum them, and count the number recorded
  n <- 1
  for (j in 201:2000) {
    comm <- neutral_generation_speciation(comm,0.1)
    if (j %% 20 == 0) {
      y <- octaves(species_abundance(comm))
      x <- sum_vect(x,y)
      n <- n + 1
    }
  }
  
  mean <- x / n
  
  # Generate x axis labels for octave plots
  names <- c("1")
  for (i in 2:length(x)) {
    lower <- 2^(i-1)
    upper <- (2^i) - 1
    new_name <- paste(lower, upper, sep = "-")
    names <- append(names, new_name)
  }
  
  # Make barplot of mean counts in each octave
  barplot(mean, names.arg = names, ylim = c(0,12), space = 0,
          xlab = "Number of individuals per species", 
          ylab = "Average number of species", 
          main = "Octaves of species abundance distribution")
  
  answer <- "The initial condition of the system does not matter. As we showed
  above, the system reaches dynamic equilibrium with these conditions before 200
  generations. This means that all of the recorded species abundances are at dynamic
  equilibrium, which is unaffected by initial conditions."
  return("type your written answer here")
}

# Question 17
cluster_run <- function(speciation_rate, size, wall_time, interval_rich, 
                        interval_oct, burn_in_generations, output_file_name)  {
    comm <- init_community_min(size)
    limit <- wall_time * 60
    
    # Initiate variables and vectors for while loop
    j <- 1
    time_series <- c(1)
    octs <- list()
    
    # Run neutral model while time is less than wall_time
    while (proc.time()[3] < limit) {
      comm <- neutral_generation_speciation(comm, speciation_rate)
      # Record richness during burn in period
      if (j %% interval_rich == 0 & j < burn_in_generations) {
        time_series <- append(time_series, species_richness(comm))
      } 
      # Calculate octaves at given intervals
      if (j %% interval_oct == 0) {
        octs[[length(octs) + 1]] <- octaves(species_abundance(comm))
      }
      j <- j + 1
    }
    
    # Record total time and save outputs to .Rda
    tot_time <- proc.time()[3]
    save(time_series, octs, comm, tot_time, speciation_rate, size, wall_time,
         interval_rich, interval_oct, burn_in_generations, file = output_file_name)
}

# Questions 18 and 19 involve writing code elsewhere to run your simulations on the cluster

# Question 20 
process_cluster_results <- function()  {
  # Create empty vectors for averages
  size_500 <- c()
  size_1000 <- c()
  size_2500 <- c()
  size_5000 <- c()
  
  # Loop through each dataset
  for (i in 1:100){
    # browser()
    # Create each name iteratively and load
    filename <- paste("sim_results_", i, ".Rda", sep = "")
    load(filename)
    
    # Remove octaves measured during burn in period
    if (length(octs) < 80) { # To account for some runs that ran far fewer generations
      octs <- octs[-(1:(burn_in_generations/(2*interval_oct)))]
    } else {
    octs <- octs[-(1:(burn_in_generations/interval_oct))]
    }
    # Init vector to store and count of octaves
    x <- c()
    n <- 0
    
    for (j in 1:length(octs)) {
      try(y <- octs[[j]])
      x <- sum_vect(x,y)
      n <- n + 1
    }
    
    # Calculate the mean
    mean <- x / n
    
    # Add mean to correct vector
    if (size == 500) {
      size_500 <- sum_vect(size_500, mean)
    } else if (size == 1000) {
      size_1000 <- sum_vect(size_1000, mean)
    } else if (size == 2500) {
      size_2500 <- sum_vect(size_2500, mean)
    } else if (size == 5000) {
      size_5000 <- sum_vect(size_5000, mean)
    }
  }
  
  # Get final averages and add to list
  size_500 <- size_500 / 25
  size_1000 <- size_1000 / 25
  size_2500 <- size_2500 / 25
  size_5000 <- size_5000 / 25
  combined_results <- list(size_500, size_1000, size_2500, size_5000) 
  
  # save results to an .rda file
  save(combined_results, file = "summarised_cluster_data.Rda")
}

plot_cluster_results <- function()  {
    # clear any existing graphs and plot your graph within the R window
    # load combined_results from your rda file
    # plot the graphs
  graphics.off()
  load("summarised_cluster_data.Rda")
  
  titles <- c(500,1000, 2500, 5000)
  par(mfrow = c(2,2)) # Create 2x2 grid for plots
  
  # Loop through each vector and create plot
  for (j in 1:4){
    # Generate x axis labels for octave plots
    names <- c("1")
    for (i in 2:length(combined_results[[j]])) {
      lower <- 2^(i-1)
      upper <- (2^i) - 1
      new_name <- paste(lower, upper, sep = "-")
      names <- append(names, new_name)
    }
    
    main_title <- paste("Averages for community size ", titles[j], sep = "")
    y_max <- ceiling(max(combined_results[[j]]))
    
    # Create barplot of mean counts per octave
    barplot(combined_results[[j]], names.arg = names, space = 0,
            xlab = "Number of individuals per species", 
            ylab = "Average count of species per octave", las = 2, 
            main = main_title, ylim = c(0,y_max), cex.names = 0.8)
  }
    
  return(combined_results)
}

# Question 21
question_21 <- function()  {
  dimension <- log(8, 3)
  working <- "The size equals the width to the power of the dimension.
  In this case, to increase width by 3 requires 8 times the material, since
  each square contains 8 identical copies and an empty square in the centre.
  Thus, 3^Dim = 8, simplifying to dimension is log 8 to the base 3."
  answer <- list(dimension, working)
  return(answer)
}

# Question 22
question_22 <- function()  {
  dimension <- log(20,3)
  working <- "The size equals the width to the power of the dimension.
  In this case, to increase width by 3 requires 20 times the material, since
  each cube contains 3^3 = 27 smaller cubes, less the empty cube in each face
  (6) and in the centre (1), ie. 27 - 6 - 1 = 20. Thus, 3^Dim = 20, 
  simplifying to dimension is log of 20 to the base 3."
  answer <- list(dimension, working)
  return(answer)
}

# Question 23
chaos_game <- function()  {
  # clear any existing graphs and plot your graph within the R window
  graphics.off()
  
  # Initialise matrix with given coordinates and starting point vector
  coords <- matrix(nrow = 3, ncol = 2)
  coords[1,] <- c(0,0)
  coords[2,] <- c(3,4)
  coords[3,] <- c(4,1)
  
  X <- c(0,0)
  
  # Plot starting point
  plot(X[1],X[2], xlim = c(0,4), ylim = c(0,4), pch = 20, cex = 0.1,
       xlab = "X", ylab = "Y")
  
  # Move halfway towards random coord and plot 10000 times
  for (i in 1:10000){
    chosen <- coords[sample(1:3, 1),] # randomly sample a given coordinate
    X <- (X + chosen) / 2
    points(X[1],X[2], pch = 20, cex = 0.1)
  }
  
  return("Upon first plotting, I see that the points are distibuted within the
         triangle drawn by the points A, B and C. When the dimension is increased,
         it becomes clear that this creates a triangular fractal, with each shape
         made up of an empty triangle in the centre of the larger one.")
}

# Question 24
turtle <- function(start_position, direction, length)  {
  # New x is start x, plus change (given by length * cos(direction))
  x <- start_position[1] + (length * cos(direction))
  
  # New y as above, but using sin
  y <- start_position[2] + (length * sin(direction))
  
  # Record start and end point
  end_pos <- c(x,y)
  positions <- rbind(start_position, end_pos)
  
  lines(positions) # Draw line from start to end
  return(end_pos) # you should return your endpoint here.
}

# Question 25
elbow <- function(start_position, direction, length)  {
  new_start <- turtle(start_position, direction, length)
  
  turtle(new_start, direction - (pi/4), 0.95 * length)
}

# Question 26
spiral <- function(start_position, direction, length)  {
  if (length > 0.01) { # Set threshold to avoid infinite recursion
    new_start <- turtle(start_position, direction, length)
    
    spiral(new_start, direction - (pi/4), 0.95 * length) 
  }
  
  return("This function draws a spiral shape on the plot. However, it also returns
         an error that C stack usage is too close to the limit. This occurs
         because the function is recursive, ie. it calls itself. Eventually, 
         it will stop as there is a limit imposed by the computer to stop recursive
         functions from running forever (C stack usage error)")
}

# Question 27
draw_spiral <- function()  {
  # clear any existing graphs and plot your graph within the R window
  graphics.off()
  
  plot(1, type = "n", # Remove all elements of plot
       xlab = "x", ylab = "y",
       xlim = c(0, 3), ylim = c(0, 3))
  
  # Call spiral to draw lines
  spiral(c(0.5,0.5), pi / 2, 1)
}

# Question 28
tree <- function(start_position, direction, length)  {
  if (length > 0.005) { # thresh to avoid infinite recursion
    new_start <- turtle(start_position, direction, length)
    
    tree(new_start, direction - (pi/4), 0.65 * length) 
    tree(new_start, direction + (pi/4), 0.65 * length)
  }
}

draw_tree <- function()  {
  # clear any existing graphs and plot your graph within the R window
  graphics.off()
  
  plot(1, type = "n",     # Remove all elements of plot
       xlab = "x", ylab = "y",
       xlim = c(0, 3), ylim = c(0, 3))
  
  tree(c(1.5,0.5), pi / 2, 1) # Call tree to generate lines
}

# Question 29
fern <- function(start_position, direction, length)  {
  if (length > 0.005) { # thresh to avoid infinite recursion
    new_start <- turtle(start_position, direction, length)
    
    fern(new_start, direction, 0.87 * length)
    fern(new_start, direction + (pi/4), 0.38 * length)
  }
}

draw_fern <- function()  {
  # clear any existing graphs and plot your graph within the R window
  graphics.off()
  
  plot(1, type = "n",         # Remove all elements of plot
       xlab = "x", ylab = "y",
       xlim = c(0, 4.5), ylim = c(0, 9))
  
  fern(c(2,0.5), pi / 2, 1) # Call fern to draw lines
}

# Question 30
fern2 <- function(start_position, direction, length, dir)  {
  if (length > 0.005) { # Thresh to avoid infinite recursion
    new_start <- turtle(start_position, direction, length)
    
    fern2(new_start, direction, 0.87 * length, dir * -1) # Vary direction using *-1
    fern2(new_start, direction + dir * (pi/4), 0.38 * length, dir)
  }
}

draw_fern2 <- function()  {
  # clear any existing graphs and plot your graph within the R window
  graphics.off()
  
  plot(1, type = "n",          # Remove all elements of plot
       xlab = "x", ylab = "y",
       xlim = c(0, 9), ylim = c(0, 9))
  
  fern2(c(4.5,0.5), pi / 2, 1, 1) # Call fern2 to draw lines
}

# Challenge questions - these are optional, substantially harder, and a maximum of 16% is available for doing them.  

# Challenge question A
Challenge_A <- function() {
  # clear any existing graphs and plot your graph within the R window
  graphics.off()
  
  # Create time series for minimally and maximally diverse starting communities
  # for (i in 1:10) {
  #   max_matrix[i,] <- neutral_time_series_speciation(init_community_max(100), 0.1, 2000)
  #   min_matrix[i,] <- neutral_time_series_speciation(init_community_min(100), 0.1, 2000)
  # }
  reps <- 1000
  gens <- 200
  
  # Replicate the neutral time series 1000 times
  max_matrix <- replicate(reps, neutral_time_series_speciation(
    init_community_max(100), 0.1, gens), simplify = TRUE)
  min_matrix <- replicate(reps, neutral_time_series_speciation(
    init_community_min(100), 0.1, gens), simplify = TRUE)
  
  # Find the means for each generation
  max_means <- rowMeans(max_matrix)
  min_means <- rowMeans(min_matrix)
  
  # Init vectors for storing CIs
  upperbound_max <- c()
  lowerbound_max <- c()
  upperbound_min <- c()
  lowerbound_min <- c()
  burn_in <- gens
  
  # Find 97.2% CIs 1000 - (1000 * 97.2%) / 2 = 14 (two tailed CI)
  for (i in 1:gens+1){
    upperbound_max[i] <- sort(max_matrix[i,], decreasing = TRUE)[14]
    lowerbound_max[i] <- sort(max_matrix[i,])[14]
    upperbound_min[i] <- sort(min_matrix[i,], decreasing = TRUE)[14]
    lowerbound_min[i] <- sort(min_matrix[i,])[14]
  
  }
  
  # Estimate burn in time
  for (i in 1:gens+1){
    if (max_means[i] < min_means[i]) {
      burn_in <- i
      break
    }
  }
  
  # Create line plot of no. of species vs generations
  plot(x = 0:gens, y = max_means, type = "l", ylab = "Number of species", xlab = "Generations",
       main = "Neutral model simulation with speciation", col = rgb(0,0,1,1),
       xlim = c(0,gens), ylim = c(0,100))
  lines(x = 0:gens, y = min_means, col = rgb(1,0,0,1)) # Add lines for min. diversity start
  legend("topright", legend = c("Maximum initial species richness",
                                "Minimum initial species richness"),
         lty = 1, col = c(rgb(0,0,1,1),rgb(1,0,0,1)))
  
  # Plot confidence intervals
  polygon(c(0:gens, gens:0), c(upperbound_max, rev(lowerbound_max)), 
          col = rgb(0,0,1,0.2), density = 100)
  polygon(c(0:gens, gens:0), c(upperbound_min, rev(lowerbound_min)), 
          col = rgb(1,0,0,0.2), density = 100)
  
  # Add line for burn in time
  abline(v = burn_in)
  burn_in_label <- paste("Estimated generations until\n dynamic equilibrium:",
                         burn_in)
  text(x = burn_in + 50, y = 50, labels = burn_in_label)
}

# Challenge question B
Challenge_B <- function() {
  # clear any existing graphs and plot your graph within the R window

}

# Challenge question C
Challenge_C <- function() {
  # clear any existing graphs and plot your graph within the R window
  graphics.off()
  matrix_500 <- matrix(nrow = 100, ncol = 4000)
  matrix_1000 <- matrix(nrow = 100, ncol = 8000)
  matrix_2500 <- matrix(nrow = 100, ncol = 20000)
  matrix_5000 <- matrix(nrow = 100, ncol = 40000)
  
  for (i in 1:100){
    filename <- paste("sim_results_", i, ".Rda", sep = "")
    load(filename)
    
    if (size == 500) {
      matrix_500[i,] <- time_series
    } else if (size == 1000) {
      matrix_1000[i,] <- time_series
    } else if (size == 2500) {
      matrix_2500[i,] <- time_series
    } else if (size == 5000) {
      try(matrix_5000[i,] <- time_series)
    }
  }
  
  mean_500 <- colMeans(matrix_500, na.rm = T)
  mean_1000 <- colMeans(matrix_1000, na.rm = T)
  mean_2500 <- colMeans(matrix_2500, na.rm = T)
  mean_5000 <- colMeans(matrix_5000, na.rm = T)
  
  par(mfrow = c(2,2))
  # Create line plot of no. of species vs generations
  plot(mean_500, type = "l", ylab = "Number of species", xlab = "Generations",
       main = "500 members", col = rgb(0,0,1,1),
       xlim = c(0,4000))
  
  plot(mean_1000, type = "l", ylab = "Number of species", xlab = "Generations",
       main = "1000 members", col = rgb(0,0,1,1),
       xlim = c(0,8000))
  
  plot(mean_2500, type = "l", ylab = "Number of species", xlab = "Generations",
       main = "2500 members", col = rgb(0,0,1,1),
       xlim = c(0,20000))
  
  plot(mean_5000, type = "l", ylab = "Number of species", xlab = "Generations",
       main = "5000 members", col = rgb(0,0,1,1),
       xlim = c(0,40000))#, ylim = c(0,5000))
  # lines(x = 0:gens, y = min_means, col = rgb(1,0,0,1)) # Add lines for min. diversity start
  # legend("topright", legend = c("Maximum initial species richness",
  #                               "Minimum initial species richness"),
  #        lty = 1, col = c(rgb(0,0,1,1),rgb(1,0,0,1)))
}

# Challenge question D
Challenge_D <- function() {
  # clear any existing graphs and plot your graph within the R window
  J <- 5000
  v <- 0.004643 # Unique rate generated using student ID
  lineages <- rep(1, times = J)
  abundances <- c()
  N <- J
  theta <- v * (J-1) / (1-v)
  while (N > 1) {
    j <- sample(1:length(lineages), 1)
    randnum <- runif(1)
    if (randnum < theta / (theta + N -1)) {
      abundances <- append(abundances, lineages[j])
    } else {
      i <- sample(c(1:(j-1), (j+1):length(lineages)), 1)
      lineages[i] <- lineages[i] + lineages[j]
      lineages <- lineages[-j]
      N <- N - 1
    }
  abundances <- append(abundances, lineages)
  }
  
  octs <- octaves(abundances)
  
  # Generate x axis labels for octave plots
  names <- c("1")
  for (i in 2:length(octs)) {
    lower <- 2^(i-1)
    upper <- (2^i) - 1
    new_name <- paste(lower, upper, sep = "-")
    names <- append(names, new_name)
  }
  
  main_title <- paste("Averages for community size ", J, sep = "")
  y_max <- ceiling(max(octs))
  
  # Create barplot of mean counts per octave
  barplot(octs, names.arg = names, space = 0,
          xlab = "Number of individuals per species", 
          ylab = "Average count of species per octave", las = 2, 
          main = main_title, ylim = c(0,y_max), cex.names = 0.8)
  
  return("abundances")
}

# Challenge question E
Challenge_E <- function() {
  # clear any existing graphs and plot your graph within the R window
  graphics.off()
  
  par(mfrow = c(2,2))
  
  # Initialise matrix with coords of equilateral triangle
  coords <- matrix(nrow = 3, ncol = 2)
  coords[1,] <- c(1,0)
  coords[2,] <- c(5,0)
  coords[3,] <- c(3,2*sqrt(3))
  
  X <- c(0,0)
  
  # Plot starting point
  plot(X[1],X[2], xlim = c(0,6), ylim = c(0,5), 
       pch = 20, cex = 0.5, col = 1,
       xlab = "X", ylab = "Y")
  
  # Generate different starting values and plot in corresponding colours
  for (i in 1:5){
    X <- c(i,i)
    
    points(X[1],X[2], pch = 20, cex = 0.5, col = i)
    
    # Move halfway towards random coord and plot 10000 times
    for (i in 1:1000){
      chosen <- coords[sample(1:3, 1),] # randomly sample a given coordinate
      X <- (X + chosen) / 2
      points(X[1],X[2], pch = 20, cex = 0.5, col = i)
    }
  }
  
  # As above, but only moving 1/4 of the way each time
  # Plot starting point
  plot(X[1],X[2], xlim = c(0,6), ylim = c(0,5), 
       pch = 20, cex = 0.5, col = 1,
       xlab = "X", ylab = "Y")
  
  # Generate different starting values and plot in corresponding colours
  for (i in 1:5){
    X <- c(i,i)
    
    points(X[1],X[2], pch = 20, cex = 0.5, col = i)
    
    # Move halfway towards random coord and plot 10000 times
    for (i in 1:1000){
      chosen <- coords[sample(1:3, 1),] # randomly sample a given coordinate
      X <- (3 * X + chosen) / 4
      points(X[1],X[2], pch = 20, cex = 0.1, col = i)
    }
  }
  
  # With a four sided shape and moving halfway each time
  # Initialise matrix with coords of pentagon
  coords <- matrix(nrow = 5, ncol = 2)
  coords[1,] <- c(1,0)
  coords[2,] <- c(5,0)
  coords[3,] <- c(1,4)
  coords[4,] <- c(5,4)
  
  X <- c(0,0)
  
  # Plot starting point
  plot(X[1],X[2], xlim = c(0,6), ylim = c(0,5), 
       pch = 20, cex = 0.5, col = 1,
       xlab = "X", ylab = "Y")
  
  # Generate different starting values and plot in corresponding colours
  for (i in 1:5){
    X <- c(i,i)
    
    points(X[1],X[2], pch = 20, cex = 0.5, col = i)
    
    # Move halfway towards random coord and plot 10000 times
    for (i in 1:1000){
      chosen <- coords[sample(1:4, 1),] # randomly sample a given coordinate
      X <- (X + chosen) / 2
      points(X[1],X[2], pch = 20, cex = 0.1, col = i)
    }
  }
  
  # With a four sided shape and moving 1/3 each time
  # Initialise matrix with coords of pentagon
  coords <- matrix(nrow = 5, ncol = 2)
  coords[1,] <- c(1,0)
  coords[2,] <- c(5,0)
  coords[3,] <- c(1,4)
  coords[4,] <- c(5,4)
  
  X <- c(0,0)
  
  # Plot starting point
  plot(X[1],X[2], xlim = c(0,6), ylim = c(0,5), 
       pch = 20, cex = 0.5, col = 1,
       xlab = "X", ylab = "Y")
  
  # Generate different starting values and plot in corresponding colours
  for (i in 1:5){
    X <- c(i,i)
    
    points(X[1],X[2], pch = 20, cex = 0.5, col = i)
    
    # Move halfway towards random coord and plot 10000 times
    for (i in 1:1000){
      chosen <- coords[sample(1:4, 1),] # randomly sample a given coordinate
      X <- (2 * X + chosen) / 3
      points(X[1],X[2], pch = 20, cex = 0.1, col = i)
    }
  }
  return("The first points plotted gradually move towards the limits of the same
         fractal shape plotted in chaos_game, and once they reach this point,
         the fractal proceeds to generate as normal with points all contained within
         the same bounds as before.")
}

# Challenge question F
Challenge_F <- function() {
  # clear any existing graphs and plot your graph within the R window
  # clear any existing graphs and plot your graph within the R window
  graphics.off()
  
  par(mfcol = c(1,2))
  
  plot(1, type = "n",     # Remove all elements of plot
       axes = FALSE, main = "'Realistic' tree", xlab = "", ylab = "",
       xlim = c(0, 3), ylim = c(0, 3))
  
  tree_alt(c(1.5,0.5), pi / 2, 1, 20) # Call tree to generate lines
  
  plot(1, type = "n",          # Remove all elements of plot
       axes = FALSE, main = "'Realistic' fern", xlab = "", ylab = "",
       xlim = c(0, 9), ylim = c(0, 9))
  
  fern2real(c(4.5,0.5), pi / 2, 1, 1, 6) # Call fern2 to draw lines
  
  return("Assuming that line size threshold refers to the line length set to
         avoid infinite recursion, making this smaller will cause the program to
         take longer to run, and produce a 'denser' plot, with more small
         branches.")
}

tree_alt <- function(start_position, direction, length, width)  {
  if (length > 0.005) { # thresh to avoid infinite recursion
    new_start <- turtle_alt(start_position, direction, length, width)
    
    tree_alt(new_start, direction - (pi/4), 0.65 * length, 0.72 * width) 
    tree_alt(new_start, direction + (pi/4), 0.65 * length, 0.72 * width)
  }
}

turtle_alt <- function(start_position, direction, length, width)  {
  # New x is start x, plus change (given by length * cos(direction))
  x <- start_position[1] + (length * cos(direction))
  
  # New y as above, but using sin
  y <- start_position[2] + (length * sin(direction))
  
  # Record start and end point
  end_pos <- c(x,y)
  positions <- rbind(start_position, end_pos)
  
  if (length > 0.1) { # branches
    lines(positions, col = "burlywood4", lwd = width) # Draw line from start to end
  } else {
    lines(positions, col = "forestgreen", lwd = width)
  }
  return(end_pos) # you should return your endpoint here.
}

fern2real <- function(start_position, direction, length, dir, width)  {
  if (length > 0.005) { # Thresh to avoid infinite recursion
    new_start <- turtle_alt_fern(start_position, direction, length, width)
    
    fern2real(new_start, direction, 0.87 * length, dir * -1, 0.9*width) # Vary direction using *-1
    fern2real(new_start, direction + dir * (pi/4), 0.38 * length, dir, 0.8*width)
  }
}

turtle_alt_fern <- function(start_position, direction, length, width)  {
  # New x is start x, plus change (given by length * cos(direction))
  x <- start_position[1] + (length * cos(direction))
  
  # New y as above, but using sin
  y <- start_position[2] + (length * sin(direction))
  
  # Record start and end point
  end_pos <- c(x,y)
  positions <- rbind(start_position, end_pos)
  
  if (length > 0.1) { # branches
    lines(positions, col = "darkgreen", lwd = width) # Draw line from start to end
  } else {
    lines(positions, col = "forestgreen", lwd = width)
  }
  return(end_pos) # you should return your endpoint here.
}

# Challenge question G should be written in a separate file that has no dependencies on any functions here.


