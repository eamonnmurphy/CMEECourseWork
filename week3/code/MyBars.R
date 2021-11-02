rm(list = ls())

# Read in table and look at it
a <- read.table("../data/Results.txt", header = TRUE)
head(a)

a$ymin <- rep(0, dim(a)[1]) # Column of zeros

# Print the first linerange
p <- ggplot(a)
p <- p + geom_linerange(data = a,
                        aes(x = x, ymin = ymin, ymax = y1,
                            size = (0.5)),
                        colour = "#E69F00", alpha = 1/2,
                        show.legend = FALSE)

# Print next linerange
p <- p + geom_linerange(data = a,
                        aes(x = x, ymin = ymin,
                            ymax = y2, size = (0.5)),
                        colour = "#56B4E9", alpha = 1/2,
                        show.legend = FALSE)

# print third linerange
p <- p + geom_linerange(data = a,
                        aes(x = x, ymin = ymin,
                            ymax = y3, size = (0.5)),
                        colour = "#D55E00", alpha = 1/2,
                        show.legend = FALSE)

# Annotate the plot with labels:
p <- p + geom_text(data = a, aes(x = x, y = -500, label = Label))

# set axis labels and remove legend
p <- p + scale_x_continuous("My x axis",
                            breaks = seq(3, 5, by = 0.05)) +
  scale_y_continuous("My y axis") + theme_bw() +
  theme(legend.position = "none")

pdf("../results/MyBars.pdf")
print(p)
dev.off()