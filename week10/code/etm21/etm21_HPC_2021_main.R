# CMEE 2021 HPC excercises R code main pro forma
# you don't HAVE to use this but it will be very helpful.  If you opt to write everything yourself from scratch please ensure you use EXACTLY the same function and parameter names and beware that you may loose marks if it doesn't work properly because of not using the proforma.

name <- "Eamonn Murphy"
preferred_name <- "Eamonn"
email <- "etm21@ic.ac.uk"
username <- "etm21"

# please remember *not* to clear the workspace here, or anywhere in this file. If you do, it'll wipe out your username information that you entered just above, and when you use this file as a 'toolbox' as intended it'll also wipe away everything you're doing outside of the toolbox.  For example, it would wipe away any automarking code that may be running and that would be annoying!

# Question 1
species_richness <- function(community){
  richness <- length(unique(community))
  return(richness)
}

# Question 2
init_community_max <- function(size){
  max <- seq(1, size)
  return(max)
}

# Question 3
init_community_min <- function(size){
  min <- rep.int(1, size)
  return(min)
}

# Question 4
choose_two <- function(max_value){
  pair <- sample(max_value, 2)
  return(pair)
}

# Question 5
neutral_step <- function(community){
  pair <- choose_two(length(community))
  community[pair[1]] <- community[pair[2]]
  return(community)
}

# Question 6
neutral_generation <- function(community){
  steps <- round((length(community)/2) + runif(1,-0.1,0.1))
  for (i in 1:steps) {
    community <- neutral_step(community)
  }
  return(community)
}

# Question 7
neutral_time_series <- function(community,duration)  {
  time_series <- c(species_richness(community))
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
  #dev.off()
  time_series <- neutral_time_series(init_community_max(100), 200)
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
  chance <- runif(1)
  pair <- choose_two(length(community))
  if (chance > speciation_rate) {
    community[pair[1]] <- community[pair[2]]
  } else {
    new_species <- max(community) + 1
    community[pair[1]] <- new_species
  }
  return(community)
}

# Question 10
neutral_generation_speciation <- function(community,speciation_rate)  {
  steps <- round((length(community)/2) + runif(1,-0.1,0.1))
  for (i in 1:steps) {
    community <- neutral_step_speciation(community, speciation_rate)
  }
  return(community)
}

# Question 11
neutral_time_series_speciation <- function(community,speciation_rate,duration)  {
  time_series <- c(species_richness(community))
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
  max_series <- neutral_time_series_speciation(init_community_max(100), 0.1, 200)
  min_series <- neutral_time_series_speciation(init_community_min(100), 0.1, 200)
  
  plot(max_series, type = "l", ylab = "Number of species", xlab = "Generations",
       main = "Neutral model simulation with speciation", col = "navyblue",
       xlim = c(0,200), ylim = c(0,100))
  lines(min_series, col = "red")
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
  counts <- as.data.frame(table(community))[,2]
  abundance <- sort(counts, decreasing = TRUE)
  return(abundance)
}

# Question 14
octaves <- function(abundance_vector) {
  converted <- vector(length = length(abundance_vector))
  converted[] <- floor(log2(abundance_vector[])) + 1
  octed <- tabulate(converted)
  return(octed)
}

# Question 15
sum_vect <- function(x, y) {
  #browser()
  if (length(x) < length(y)) {
    x <- append(x, rep(0, length(y)-length(x)))
  } else if (length(y) < length(x)) {
    y <- append(y, rep(0, length(x)-length(y)))
  }
  sum <- x + y
  return(sum)
}

# Question 16 
question_16 <- function()  {
  # clear any existing graphs and plot your graph within the R window
  comm <- init_community_max(100)
  for (i in 1:200) {
    comm <- neutral_generation_speciation(comm, 0.1)
  }
  x <- octaves(species_abundance(comm))
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
  names <- c("1")
  for (i in 2:length(x)) {
    lower <- 2^(i-1)
    upper <- (2^i) - 1
    new_name <- paste(lower, upper, sep = "-")
    names <- append(names, new_name)
  }
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
cluster_run <- function(speciation_rate, size, wall_time, interval_rich, interval_oct, burn_in_generations, output_file_name)  {
    comm <- init_community_min(size)
    limit <- wall_time * 60
    start_time <- as.numeric(Sys.time())
    j <- 1
    time_series <- c(1)
    octs <- list()
    
    while (as.numeric(Sys.time())-start_time < limit) {
      comm <- neutral_generation_speciation(comm, speciation_rate)
      if (j %% interval_rich == 0 & j < burn_in_generations) {
        time_series <- append(time_series, species_richness(comm))
      } 
      if (j %% interval_oct == 0) {
        octs[[length(octs) + 1]] <- octaves(species_abundance(comm))
      }
      j <- j + 1
    }
    tot_time <- as.numeric(Sys.time()) - start_time
    
    save(time_series, octs, comm, tot_time, speciation_rate, size, wall_time,
         interval_rich, interval_oct, burn_in_generations, file = output_file_name)
}

# Questions 18 and 19 involve writing code elsewhere to run your simulations on the cluster

# Question 20 
process_cluster_results <- function()  {
  combined_results <- list() #create your list output here to return
  # save results to an .rda file
  
}

plot_cluster_results <- function()  {
    # clear any existing graphs and plot your graph within the R window
    # load combined_results from your rda file
    # plot the graphs
    
    return(combined_results)
}

# Question 21
question_21 <- function()  {
    
  return("type your written answer here")
}

# Question 22
question_22 <- function()  {
    
  return("type your written answer here")
}

# Question 23
chaos_game <- function()  {
  # clear any existing graphs and plot your graph within the R window
  
  return("type your written answer here")
}

# Question 24
turtle <- function(start_position, direction, length)  {
    
  return() # you should return your endpoint here.
}

# Question 25
elbow <- function(start_position, direction, length)  {
  
}

# Question 26
spiral <- function(start_position, direction, length)  {
  
  return("type your written answer here")
}

# Question 27
draw_spiral <- function()  {
  # clear any existing graphs and plot your graph within the R window
  
}

# Question 28
tree <- function(start_position, direction, length)  {
  
}

draw_tree <- function()  {
  # clear any existing graphs and plot your graph within the R window

}

# Question 29
fern <- function(start_position, direction, length)  {
  
}

draw_fern <- function()  {
  # clear any existing graphs and plot your graph within the R window

}

# Question 30
fern2 <- function(start_position, direction, length, dir)  {
  
}
draw_fern2 <- function()  {
  # clear any existing graphs and plot your graph within the R window

}

# Challenge questions - these are optional, substantially harder, and a maximum of 16% is available for doing them.  

# Challenge question A
Challenge_A <- function() {
  # clear any existing graphs and plot your graph within the R window

}

# Challenge question B
Challenge_B <- function() {
  # clear any existing graphs and plot your graph within the R window

}

# Challenge question C
Challenge_C <- function() {
  # clear any existing graphs and plot your graph within the R window

}

# Challenge question D
Challenge_D <- function() {
  # clear any existing graphs and plot your graph within the R window
  
  return("type your written answer here")
}

# Challenge question E
Challenge_E <- function() {
  # clear any existing graphs and plot your graph within the R window
  
  return("type your written answer here")
}

# Challenge question F
Challenge_F <- function() {
  # clear any existing graphs and plot your graph within the R window
  
  return("type your written answer here")
}

# Challenge question G should be written in a separate file that has no dependencies on any functions here.


