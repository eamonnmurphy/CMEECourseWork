# Build a function to calculate ellipse
build_ellipse <- function(hradius, vradius) {
  npoints = 250
  a <- seq(0, 2*pi, length = npoints + 1)
  x <- hradius * cos(a)
  y <- vradius * sin(a)
  return(data.frame(x = x, y = y))
}

# Assign size of matrix 
N <- 250

# Build matrix
M <- matrix(rnorm(N*N), N, N)

# Find the eigenvalues
eigvals <- eigen(M)$values

# Build a dataframe
eigDF <- data.frame("Real" = Re(eigvals), "Imaginary" = 
                      Im(eigvals))

# The radius of the circle is sqrt(N)
my_radius <- sqrt(N)

# Dataframe to plot ellipse
ellDF <- build_ellipse(my_radius, my_radius)

# Rename columns
names(ellDF) <- c("Real", "Imaginary")

################# PLOTTING #################
# Plot the eigenvalues
p <- ggplot(eigDF, aes(x = Real, y = Imaginary)) + 
  geom_point(shape = I(3)) +
  theme(legend.position = "none") + 
  geom_hline(aes(yintercept = 0)) + 
  geom_vline(aes(xintercept = 0)) + 
  geom_polygon(data = ellDF,
               aes(x = Real, y = Imaginary,
                   alpha = 1/20, fill = "red"))

pdf("../results/Girko.pdf")
print(p)
dev.off()
