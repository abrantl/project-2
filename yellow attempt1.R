
# Load the required package
library(jpeg)

# Load an example image
img <- readJPEG("AdobeStock_206345546-426480574.jpg")


# Define the probability of changing a pixel
prob <- 0.25

# Define the RGB values for yellow
yellow <- c(254, 228, 4)

# Identify yellow pixels
is_yellow <- apply(img, 1:2, function(pixel) all(pixel == yellow))
# Get the RGB values of a yellow pixel
#yellow_pixel <- img[211, 264, ]
#yellow_pixel
# Check if any yellow pixels were found
if (!any(is_yellow)) {
  stop("No yellow pixels found in the image.")
}
# Get the RGB values of a yellow pixel
yellow_pixel <- img[x, y, ]
yellow_pixel

# Calculate the number of yellow pixels to change
num_yellow_pixels <- round(prob * sum(is_yellow))

# Generate a vector of random yellow pixel indices
yellow_pixels_to_change <- sample(which(is_yellow), num_yellow_pixels)

# Generate a vector of random values to replace the yellow pixels
new_values <- runif(num_yellow_pixels)

# Replace the yellow pixels in the image with the new values
img[yellow_pixels_to_change] <- new_values

# Save the modified image
writeJPEG(img, "modified_image2.jpg")
