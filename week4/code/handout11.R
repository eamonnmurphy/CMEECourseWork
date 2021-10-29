rm(list = ls())

daphnia <- read.delim("../data/daphnia.txt")
summary(daphnia)

summary(daphnia)
head(daphnia)
str(daphnia)

par(mfrow = c(1, 2))
plot(Growth.rate ~ as.factor(Detergent), data = daphnia)
plot(Growth.rate ~ as.factor(Daphnia), data = daphnia)

require(dplyr)
daphnia %>% group_by(Detergent) %>% 
  summarise(variance = var(Growth.rate))

daphnia %>% group_by(Daphnia) %>%
  summarise(variance = var(Growth.rate))

dev.off()
hist(daphnia$Growth.rate)

seFun <- function(x) {
  sqrt(var(x)/length(x))
}

detergentmean <- with(daphnia, tapply(Growth.rate, Detergent, mean))
detergentsem <- with(daphnia, tapply(Growth.rate, Detergent, seFun))
clonemean <- with(daphnia, tapply(Growth.rate, Daphnia, mean))                     
clonesem <- with(daphnia, tapply(Growth.rate, Daphnia, seFun))

par(mfrow = c(2,1), mar = c(4,4,1,1))
barMids <- barplot(detergentmean, xlab = "Detergent type",
                   ylab = "Population growth rate", ylim = c(0,5))
arrows(barMids, detergentmean - detergentsem, barMids,
       detergentmean + detergentsem, code=3, angle=90)

barMids <- barplot(clonemean, xlab = "Daphnia clone",
                   ylab = "Population growth rate", ylim = c(0,5))
arrows(barMids, clonemean - clonesem, barMids, clonemean + clonesem,
       code = 3, angle = 90)

daphniamod <- lm(Growth.rate ~ Detergent + Daphnia, data = daphnia)
summary(daphniamod)

daphniaanovamod <- aov(Growth.rate ~ Detergent + Daphnia, data = daphnia)
summary(daphniaanovamod)

daphniamodhsd <- TukeyHSD(daphniaanovamod)
daphniamodhsd

par(mfrow = c(1,2), mar = c(4,4,1,1))
plot(daphniamodhsd)

par(mfrow = c(2,2))
plot(daphniamod)

timber <- read.delim("../data/timber.txt")
summary(timber)

par(mfrow = c(2, 2))
boxplot(timber$volume)
boxplot(timber$girth)
boxplot(timber$height)

timber <- subset(timber, volume < 5)

var(timber$volume)

t2 <- as.data.frame(subset(timber, timber$volume!="NA"))
t2$z.girth <- scale(timber$girth)
t2$z.height <- scale(timber$height)
var(t2$z.girth)
var(t2$z.height)
plot(t2)

par(mfrow = c(2,2))
hist(t2$volume)
hist(t2$girth)
hist(t2$height)

pairs(timber)
cor(timber)

model <- summary(lm(girth ~ height, data = timber))
VIF <- 1/(1-model$r.squared)
VIF

timbermod <- lm(volume ~ girth + height, data = timber)
anova(timbermod)
summary(timbermod)
plot(timbermod)

plantgrowth <- read.delim("../data/ipomopsis.txt")
summary(plantgrowth)

par(mfrow = c(1,2))
boxplot(plantgrowth$Root)
boxplot(plantgrowth$Fruit)
plot(Fruit ~as.factor(Grazing), data = plantgrowth)

var(plantgrowth$Root)
var(plantgrowth$Fruit)
plantgrowth %>% group_by(Grazing) %>% summarise(
  variance = var(Fruit)
)

p2 <- as.data.frame(subset(plantgrowth, plantgrowth$Fruit!="NA"))
p2$z.root

par(mfrow = c(2,1))
hist(plantgrowth$Root)
hist(plantgrowth$Fruit)

dev.off()
plot(plantgrowth$Root, plantgrowth$Fruit)

summary(lm(Root ~ Fruit, data = plantgrowth))

plantgrowthmod <- lm(Fruit ~ Root * Grazing, data = plantgrowth)
anova(plantgrowthmod)

summary(plantgrowthmod)

plot(plantgrowthmod)

plot(plantgrowth$Root, plantgrowth$Fruit, col = as.factor(plantgrowth$Grazing))
abline(a=-125.173, b=23.240)
abline(a=(-125.173 + 30.806), b=23.240+0.756)
