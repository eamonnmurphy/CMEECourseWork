# load maps package
require(maps)

# load GPDD data
load("../data/GPDDFiltered.RData")

# Create a world map
map()

# Add co-ordinate points to the map
points(gpdd[,3], gpdd[,2], pch = 20, color = gpdd[,1])

# This dataset is quite clearly biased towards locations in North America
# and Europe. Therefore, any analysis done would be biased towards these
# regions. Particularly, the locations represented are quite northerly, 
# and likely only represent 