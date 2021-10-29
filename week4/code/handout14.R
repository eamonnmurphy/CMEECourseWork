# What is the observer repeatability of the house sparrow 
# ornament measurement?

require(dplyr)
require(lme4)

rm(list = ls())
dev.off()

# Load in the dataset
ornament <- read.table("../data/OrnamentAge.txt", header = TRUE)
head(ornament)
str(ornament)
class(ornament$Observer)
factor(ornament$Observer)

ornament$Observer <- as.factor(ornament$Observer)
str(ornament)

# Check for outliers
plot(ornament$Ornament ~ ornament$Observer)
plot(ornament$Ornament ~ ornament$Year)
plot(ornament)

# Homogeneity of variance
ornament %>% group_by(Observer) %>% summarise(variance = var(Ornament))
lm <- lm(Ornament ~ Ornament, data = ornament)
par(mfrow = c(2,2))
plot(lm)
dev.off()

# Normal distribution
hist(ornament$Ornament)

# Colinearity
plot(ornament)
dev.off()

# Relationship of interest
plot(Ornament ~ Observer, data = ornament)

# Create maximal model
lmm <- lmer(Ornament ~ Age + (1|Observer) + (1|Year) + (1|BirdID), data = ornament)

summary(lmm)
