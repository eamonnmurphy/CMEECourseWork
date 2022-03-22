rm(list = ls())

###### Question One #######
library(cluster)
votes <- na.omit(cluster::votes.repub)
logit <- function(x) log(x / (1-x))
transformed <- logit(votes / 100)

dist <- dist(transformed)
upgma <- hclust(dist, method = "average")
plot(upgma)
comp.link <- hclust(dist)
plot(comp.link)
par(mfrow = c(2,1))
plot(upgma)
plot(comp.link)

cut.by.groups <- cutree(upgma, 3)

# No. of clusters
library(splits)
gap.stat <- ddwtGap(transformed, genRndm = "uni")
summary(gap.stat)

######### Question 3 #######
rm(list = ls())
data(iris)
head(iris)

gap.stat <- ddwtGap(iris[,1:4])

k.means <- kmeans(iris[,-5], centers = 3, nstart = 1000)
table(k.means$cluster, iris$Species)

pca <- prcomp(iris[,-5], scale = T)
biplot(pca)

# Model based clustering 
library(mclust)
model <- Mclust(iris[,-5])
summary(model)
model
plot(model, what = "BIC")

###### Question 4 ######
rm(list = ls())
data <- read.csv("../data/glopnet-biomass.csv")
data <- data[,-1]

linear <- lm(biomass ~ log.LL + log.Nmass, data = data)
summary(linear)

pca <- prcomp(data[,-1], scale. = T)
plot(pca)
biplot(pca)

upgma <- hclust(data[,-1])
