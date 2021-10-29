a <- read.table("../data/fly.txt", header = TRUE)
head(a)

require(lme4)

lmm1 <- lmer(Femur_length~1+(1|ID), data=a)
Repeatability <- 1.257/(1.257+0.0003)
Repeatability

rm(list = ls())

sparrow <- read.table("../data/sparrow.txt", header = TRUE)
head(sparrow)

lmm_tarsus <- lmer(Tarsus ~ 1+(1|BirdID), data = sparrow)
summary(lmm_tarsus)

rep_tarsus <- 0.65114/(0.65114 + 0.09573)

lmm_wing <- lmer(Wing ~ 1+(1|BirdID), data = sparrow)
summary(lmm_wing)

rep_wing <- 4.758/(4.758 + 1.636)

lmm_mass <- lmer(Mass ~ 1+(1|BirdID), data = sparrow)
summary(lmm_mass)

rep_mass <- 2.812/(2.812+1.944)

tarsus_to_mass <- lmer(Mass ~ Tarsus + (1|BirdID), 
                       data = sparrow)

sex_to_mass <- lmer(Mass ~ Sex + (1|BirdID), data = sparrow)

tarsus_sex <- lmer(Mass ~ Tarsus + Sex + (1|BirdID) + (1|Year), data = sparrow)
