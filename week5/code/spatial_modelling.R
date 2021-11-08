library(ncf)
library(raster)
library(sf)
library(SpatialPack)
library(spdep)
library(spatialreg)
library(nlme)
library(spgwr)
library(spmoran)

rich <- raster("../data/avian_richness.tif")
aet <- raster("../data/mean_aet.tif")
temp <- raster("../data/mean_temp.tif")
elev <- raster("../data/elev.tif")

print(rich)

par(mfrow = c(2,2))
plot(rich, main = "Avian species richness")
plot(aet, main = "Mean AET")
plot(temp, main = "Mean annual temperature")
plot(elev, main = "Elevation")

par(mfrow = c(2,2))
hist(rich, main = "Avian species richness")
hist(aet, main = "Mean AET")
hist(temp, main = "Mean annual temp")
hist(elev, main = "Elevation")

# Stack the data
data_stack <- stack(rich, aet, elev, temp)
print(data_stack)

data_spdf <- as(data_stack, "SpatialPixelsDataFrame")
summary(data_spdf)

data_sf <- st_as_sf(data_spdf)
print(data_sf)

# Get the cell resolution
cellsize <- res(rich)[[1]]
# Make the template polygon
template <- st_polygon(list(matrix(
  c(-1,-1,1,1,-1,-1,1,1,-1,-1), ncol = 2) * cellsize / 2))
# Add each of the data points to the template
polygon_data <- lapply(data_sf$geometry, function(pt) template + pt)
data_poly <- st_sf(avian_richness = data_sf$avian_richness,
                   geometry = polygon_data)
plot(data_poly["avian_richness"])


# Use the modified.ttest function from SpatialPack
temp_corr <- modified.ttest(x = data_sf$avian_richness,
                            y = data_sf$mean_temp,
                            coords = st_coordinates(data_sf))
print(temp_corr)
