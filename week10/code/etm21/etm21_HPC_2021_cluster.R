# CMEE 2021 HPC excercises R code HPC run code pro forma

rm(list=ls()) # good practice
graphics.off()
source("etm21_HPC_2021_main.R")

#iter <- as.numeric(Sys.getenv("PBS_ARRAY_INDEX"))
iter <- 1

set.seed(iter)

spec_rate <- 0.004643

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

cluster_run(speciation_rate = spec_rate, size = size, wall_time = 1,
            interval_rich = 1, interval_oct = size/10, burn_in_generations = 8 * size,
            output_file_name = filename)