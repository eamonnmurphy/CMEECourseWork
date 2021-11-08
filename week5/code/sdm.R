rm(list = ls())

library(rgdal)
library(raster)
library(sf)
library(sp)
library(dismo)

vignette("sdm")

tapir_IUCN <- st_read("../data/data/iucn_mountain_tapir/data_0.shp")

tapir_GBIF <- read.delim("../data/data/gbif_mountain_tapir.csv",
                         stringsAsFactors = FALSE)

tapir_GBIF <- subset(tapir_GBIF, ! is.na(decimalLatitude) | ! is.na(decimalLongitude))
tapir_GBIF <- st_as_sf(tapir_GBIF, coords =
                         c("decimalLongitude", "decimalLatitude"))
st_crs(tapir_GBIF) <- 4326
print(tapir_GBIF)

ne110 <- st_read("../data/data/ne_110m_admin_0_countries/ne_110m_admin_0_countries.shp")

model_extent <- extent(c(-85, -70, -5, 12))
plot(st_geometry(ne110), xlim = model_extent[1:2],
     ylim = model_extent[3:4], bg = "lightblue", col = "ivory")
plot(st_geometry(tapir_IUCN), add = TRUE, col = "green", border = NA)
plot(st_geometry(tapir_GBIF), add = TRUE, col = "red", pch = 4, cex = 0.6)
box()

bioclim_hist <- getData("worldclim", var = "bio", res = 10, path = "../data/data")
bioclim_2050 <- getData("CMPIP5", var = "bio", res = 10, rcp = 60, model = "HD", year = 50, path = "data/data/")

names(bioclim_2050) <- names(bioclim_hist)
print(bioclim_hist)
