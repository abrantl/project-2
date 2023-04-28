library(imager)

setwd("C:/Users/annab/OneDrive/Documents/project-2")

# Load an image to modify
img_path <- "./5.jpg"
img <- load.image(img_path)

# Add Gaussian noise to the image
noise_img <- img + rnorm(mean = 0, sd = 0.05, dim(img))

# Save the modified image
save.image(noise_img, "./adversarial_examples/noise_image.jpg")




image_path <- "./5.jpg"
image <- load.image(image_path)

# Get the dimensions of the image
width <- dim(image)[1]
height <- dim(image)[2]

# Set the number of pixels to change
num_pixels_to_change <- (width*height)/10

# Randomly select pixel locations to change
pixel_locations <- sample(1:(width*height), num_pixels_to_change, replace = FALSE)

#for loop does not change probability
for (i in 1:num_pixels_to_change) {
  index <- arrayInd(pixel_locations[i], dim(image))
  image[index[1], index[2], ] <- c(0, 0, 0)
}

# Save the modified image
save.image(image, "./adversarial_examples/modified_image.jpg")

