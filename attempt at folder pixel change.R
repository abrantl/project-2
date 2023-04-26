

library(imager)

setwd("C:/Users/annab/OneDrive/Documents/project-2")

# Load the image
f = list.files("./adversarial_examples/")
target_size = c(224, 224)

for (i in f){
  x <- image_load(paste("./adversarial_examples/",i,sep=""),
                  target_size = target_size)
  
  x <- image_to_array(x)
  x <- array_reshape(x, c(1, dim(x)))
  x <- x/255
  ## INSERT HERE WHAT YOU WANT TO ITERATE ON EACH OF THE IMAGES
  
  # Get the dimensions of the image
  width <- dim(x)[3]
  height <- dim(x)[2]
  print(width)
  print(height)
  
  # Set the number of pixels to change
  num_pixels_to_change <- (width*height)/100
  
  pixel_locations <- sample(1:(width*height), num_pixels_to_change, replace = FALSE)
  
  for (j in 1:num_pixels_to_change) {
    index <- arrayInd(pixel_locations[j], c(height, width))
    x[1, , index[1], index[2]] <- c(0, 0, 0)
  }
  
  # Convert back to an image and save the modified image
  x <- array_reshape(x, dim(x)[2:4])
  x <- array_to_image(x)
  save.image(x, paste("./pixel_budget/",i, "2.jpg"))
}



library(imager)

setwd("C:/Users/annab/OneDrive/Documents/project-2")

# Load the image
f = list.files("./adversarial_examples/")
target_size = c(224, 224)

for (i in f){
  x <- image_load(paste("./adversarial_examples/",i,sep=""),
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
    x[1, index[1], index[2], ] <- c(0, 0, 0)
  }
  
  # Save the modified image
  save.image(x, paste("./pixel_budget/",i, "2.jpg"))
}

