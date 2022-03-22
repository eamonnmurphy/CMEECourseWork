#### Section 2.4 of pdf, exercises for chap 2 ######
rm(list = ls())

library(raster)
r <- getData("worldclim", var = "bio", res = 10)
e <- extent(150,170,-60,-40)
data <- data.frame(na.omit(extract(r, e)))
names(data) <- c("temp.mean","temp.diurnal.range", "isothermality",
                 "temp.season","max.temp","min.temp","temp.ann.range","temp.wettest",
                 "temp.driest","temp.mean.warmest","temp.mean.coldest","precip",
                 "precip.wettest.month","precip.driest","precip.season",
                 "precip.wettest.quarter","precip.driest.quarter",
                 "precip.warmest","precip.coldest")

### Scaled PCA #####
pca <- prcomp(data, scale = T)
biplot(pca)
pca
summary(pca)
plot(pca)
screeplot(pca)

cor_matrix <- cor(data)
dist_cor <- dist(cor_matrix)
pcoa <- cmdscale(dist_cor, eig = T)
biplot(pcoa)

#### NMDS #####
library(vegan)
dist <- dist(data)
nmds <- metaMDS(dist)
plot(nmds)
stressplot(nmds)
orditorp(nmds, display = "sites")
ordisurf(nmds, data$temp.season)

######## Question 2 ##########
rm(list = ls())
data("BCI")

# PCoA Euclidean
dist <- dist(BCI)
pcoa <- cmdscale(dist, eig = T)
barplot(pcoa$eig)
plot(pcoa$points[,1:2], xlab = "PCoA1", ylab = "PCoA2")
#text(pcoa$points[,1:2] + .25, labels = pcoa$points)

# NMDS
nmds <- metaMDS(BCI)
plot(nmds)

# Bray-Curtis distance
bs_dist <- vegdist(BCI)
bs_pcoa <- cmdscale(bs_dist, eig = T)
plot(bs_pcoa$points[,1:2])

####### Question 3 #######
# Load in data
commm <- as.matrix(read.table("../data/hot-sites.txt"))
