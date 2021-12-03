rm(list = ls())
library(ggplot2)

tally_table <- read.csv("../results/aicc_tallies.csv")

p <- ggplot(tally_table, aes(Model, Tally)) + geom_col()
p
png("../results/tally_bar.png")
print(p)
dev.off()
