rm(list = ls())
library(ggplot2)

# Load data
data <- read.csv("../data/WrangledDataSet.csv")

tally_table <- read.csv("../results/aicc_tallies.csv")
tally_table$Model <- factor(tally_table$Model, levels = tally_table$Model)

# Generate barplot of tallies
p <- ggplot(tally_table, aes(Model, Tally, fill = Model)) + geom_col() + 
  geom_text(aes(label = Percentage), nudge_y = 2) + 
  theme(panel.background = element_rect(fill = "transparent"),
        axis.text.x = element_blank(),
        axis.ticks.x = element_blank())
p
ggsave("../results/tally_bar.png", p, dpi = 1200, width = 5, height = 5)

# plot all the population subsets
for (i in unique(data$ID)) {
  q <- NULL
  q <- ggplot(data = subset(data, ID == i), aes(Time, ln_PopBio)) + geom_point(size = 3) +
    theme(panel.background = element_rect(fill = "transparent"),
          panel.grid.major = element_line("lightgrey"),
          axis.line = element_line("grey")) + labs(y = "Ln(Population size)") +
    xlim(0, max(Time))
  ggsave(paste("../results/scatterplots/", i, ".png", sep = ""), q, width = 5, height = 5)
}
