# CMEE 2021 HPC excercises R code HPC run code pro forma

rm(list=ls()) # good practice
graphics.off()
source("etm21_HPC_2021_main.R")

# Read in job number and set as seed
iter <- as.numeric(Sys.getenv("PBS_ARRAY_INDEX"))
set.seed(iter)

spec_rate <- 0.004643 # Unique rate generated using student ID

if (iter %% 4 == 0) {
  size <- 500
} else if (iter %% 4 == 1) {
  size <- 1000
} else if (iter %% 4 == 2) {
  size <- 2500
} else if (iter %% 4 == 3) {
  size <- 5000
}

filename <- paste("sim_results_", iter, ".Rda", sep = "")

cluster_run(speciation_rate = spec_rate, size = size, wall_time = 11.5*60,
            interval_rich = 1, interval_oct = size/10, burn_in_generations = 8 * size,
            output_file_name = filename)