library(imager)

setwd("C:/Users/annab/OneDrive/Documents/project-2")

# Load the image
f = list.files("./adversarial_examples/")
target_size = c(224, 224)

for (i in f){
  test_image <- image_load(paste("./adversarial_examples/",i,sep=""),
                           target_size = target_size)
  
  x <- image_to_array(test_image)
  x <- array_reshape(x, c(1, dim(x)))
  x <- x/255
  ## INSERT HERE WHAT YOU WANT TO ITERATE ON EACH OF THE IMAGES
  
  # Get the dimensions of the image
  width <- dim(x)[2]
  height <- dim(x)[1]
  print(width)
  print(height)
  # Set the number of pixels to change
  num_pixels_to_change <- (width*height)/100
  
  pixel_locations <- sample(1:(width*height), num_pixels_to_change, replace = FALSE)
  
  
  for (i in 1:num_pixels_to_change) {
    index <- arrayInd(pixel_locations[i], dim(x))
    x[index[1], index[2], ] <- c(0, 0, 0)
  }
  
  # Save the modified image
  save.image(image, paste("./adversarial_examples1/",i, "2.jpg"))
}
