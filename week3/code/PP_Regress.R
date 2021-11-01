###############
## Write a script to draw a figure and save to pdf
# Write accompanying regression results to csv
# Analysis must be subsetted by Predator.lifestage
# 
# Save pdf to results directory (use print to write to pdf)
# Calculate regression results corresponding to lines fitted in the
# figure and save to csv delimited table in results directory
# (Init new dataframe and then write.csv() or write.table())
# 
# Linear regression on subsets of the data corresponding to
# Feeding Type x Predator Life stage combination
# 
# Regression results should include: regression slope, regression
# intercept, R**2, F-statistic, p-value
# 
# Use dplyr and ggplot

require(dplyr)
require(tidyverse)
require(ggplot2)
require(broom)

# Read data and look at feeding interaction data
MyDF <- read.csv("../data/EcolArchives-E089-51-D1.csv")
altered_df <- MyDF %>% subset(select = 
                                c(Predator.mass, Prey.mass, 
                                  Type.of.feeding.interaction, 
                                  Predator.lifestage))
altered_df$Type.of.feeding.interaction <- factor(altered_df$Type.of.feeding.interaction)
altered_df$Predator.lifestage <- factor(altered_df$Predator.lifestage)

# First, seperate data by feeding interaction.
# Then, colour data points by predator lifestage

p <- ggplot(altered_df,
            aes(x = Prey.mass, y = Predator.mass, colour = Predator.lifestage)) + 
  geom_point(shape=3) + geom_smooth(method="lm", fullrange=TRUE) +
  facet_wrap( .~Type.of.feeding.interaction, ncol = 1, strip.position = "right") + 
  theme(legend.position = "bottom",
        panel.border = element_rect(colour = "grey", fill = NA, size = 1.5),
        panel.background = element_rect(fill = "transparent"),
        panel.grid.major = element_line(colour = "grey", size = 0.2),
        panel.grid.minor = element_line(colour = "grey", size = 0.1)) +
  labs(x="Prey Mass in grams", y="Predator Mass in grams") + 
  scale_y_continuous(trans = "log10") + scale_x_continuous(trans = "log10") +
  guides(colour = guide_legend(nrow = 1, byrow = TRUE))

# Save to pdf
pdf("../results/PP_Regress.pdf")
print(p)
dev.off()

# Calculate regression results
regr_df <- data.frame(matrix(ncol = 5, nrow = 0))
names <- c("slope", "intercept", "r_squared", "F_stat", "p_value")
colnames(regr_df) <- names

for (type in unique(altered_df$Type.of.feeding.interaction)) {
  browser()
  for (stage in unique(altered_df$Predator.lifestage)) {
      quick_df <- altered_df %>% filter(
        Predator.lifestage == stage, Type.of.feeding.interaction == type
      )
      if (all(is.na(quick_df$Predator.mass))) {
        next
      }
      else {
        name <- paste(type, stage, sep = ".")
        lm <- lm(Predator.mass ~ Prey.mass, data = quick_df)
        assign(name, tidy(lm))
        regr_df[nrow(regr_df)+1,] = c(
          name[2,2], name[1,2], name[x,x], name[x,x], name[x,5]
        )
      }
  }
}
