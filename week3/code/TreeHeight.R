# This function calculates heights of trees given distance of each tree
# from its base and angle to its top, using trigonometry
#
# height = distance * tan(radians)
# 
# ARGUMENTS
# degrees: The angle of elevation of tree
# distance: The distance from base of tree (e.g., meters)
# 
# OUTPUT
# The heights of the tree, same units as "distance"

# Load in tree data from csv
stringsAsFactors = FALSE
TreesData <- read.csv('../data/trees.csv', stringsAsFactors=FALSE)

# Function to measure tree height given angle and distance
TreeHeight <- function(degrees, distance){
    radians <- degrees * pi / 180
    height <- distance * tan(radians)
    #print(paste('Tree height is:', height))
    return(height)
}

# Example call
TreeHeight(37, 40)

# Create empty dataframe
TreeHts <- data.frame(Species=numeric(), Distance.m=numeric(),
                        Angle.degrees=numeric(),Tree.Height.m=numeric())

# Add each necessary row iteratively to the dataframe
for (row in 1:nrow(TreesData)){
    # Calculate height for this tree
    height <- TreeHeight(TreesData[[row,2]],TreesData[[row,3]])
    new_row <- c(TreesData[[row,1]],TreesData[[row,2]],TreesData[[row,3]],height)
    TreeHts[nrow(TreeHts) + 1,] = new_row
}

# Write dataframe to csv
write.csv(TreeHts, "../results/TreeHts.csv",row.names=FALSE)