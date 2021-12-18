# CMEE 2021 HPC excercises R code HPC run code proforma

rm(list=ls()) # good practice in this instance
source("jrosinde/jrosinde_HPC_2021_main.R")
# it should take a faction of a second to source your file
# if it takes longer you're using the main file to do actual simulations
# it should be used only for defining functions that will be useful for your cluster run and which will be marked automatically

# do what you like here to test your functions (this won't be marked)
# for example
species_richness(c(1,4,4,5,1,6,1))
# should return 4 when you've written the function correctly for question 1

init_community_max(7)
# should return a vector { 1 2 3 4 5 6 7 }

init_community_min(4)
# should return a vector { 1 1 1 1 }

choose_two(4)
# should return one of the following vectors with equal probability

neutral_step(c(10,5,13))
# should return one of the following six community states with equal probability

neutral_generation(init_community_max(10))
# should return a vector giving the state of the community

neutral_time_series (community = init_community_max(7) , duration = 20)
# return a vector containing firstly a time series vector of length 21 with the first value being 7

question_8()
# plain text answer and plotted time series graph

neutral_step_speciation(c(10,5,13),0.2)
# should either replace one with another or introduce new species

neutral_generation_speciation(init_community_max(10), 0.2)
# # should return a vector giving the state of the community

question_12()
# Plot two series on same axis and return plain text answer

species_abundance(c(1,5,3,6,5,6,1,1))
# should return 3 2 2 1 (in that order - decreasing)

octaves(c(100,64,63,5,4,3,2,2,1,1,1,1))
# should return 4 3 2 0 0 1 2 in that order

sum_vect(c(1,3),c(1,0,5,2))
# should return (2,3,5,2)

question_16()
# return bar chart of species abundance distros and plain text answer
# you may also like to use this file for playing around and debugging
# but please make sure it's all tidied up by the time it's made its way into the main.R file or other files.
