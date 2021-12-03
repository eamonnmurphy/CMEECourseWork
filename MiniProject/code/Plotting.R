rm(list = ls())
library(ggplot2)

data <- read.csv("../data/WrangledDataSet.csv")

tally_table <- read.csv("../results/aicc_tallies.csv")
tally_table$Model <- factor(tally_table$Model, levels = tally_table$Model)

p <- ggplot(tally_table, aes(Model, Tally)) + geom_col() + 
  geom_text(aes(label = Percentage), nudge_y = 2)
p
ggsave("../results/tally_bar.png", p, dpi = 1200, width = 5, height = 5)

# plot subset 59
for (i in unique(data$ID)) {
  q <- NULL
  q <- ggplot(data = subset(data, ID == i), aes(Time, ln_PopBio)) + geom_point(size = 3) +
    theme(panel.background = element_rect(fill = "transparent"))
  ggsave(paste("../results/scatterplots/", i, ".png", sep = ""), q, width = 5, height = 5)
}

q <- ggplot(data = subset(data, ID == 1), aes(Time, ln_PopBio)) + geom_point(size = 3) +
  theme(panel.background = element_rect(fill = "transparent"))
q
