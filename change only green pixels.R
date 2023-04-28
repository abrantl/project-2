#changes green pixels to other colors

# Load the required package

library(jpeg)
main_func <- function(name) {
  img <- readJPEG(name)
  
  new_name <- gsub("\\.jpg$", "_green.jpg", name)
  
  # Define the probability of changing a green pixel
  prob <- 0.01
  
  # Calculate the number of green pixels to change
  num_pixels <- round(prob * length(img))
  
  # Get the green channel of the image
  green_channel <- img[,,2]
  
  # Generate a vector of random pixel indices
  green_pixels_to_change <- sample.int(length(green_channel), num_pixels)
  
  # Generate a vector of random values to replace the green pixels
  new_green_values <- runif(num_pixels)
  
  # Replace the green pixels in the image with the new values
  green_channel[green_pixels_to_change] <- new_green_values
  
  # Replace the green channel in the image with the modified green channel
  img[,,2] <- green_channel
  
  writeJPEG(img, new_name)
}

#set a working directory. Make sure the directory goes where the images you want to alter
setwd("C:/Users/annab/OneDrive/Documents/project-2/dandelions") 

main_func("636597665741397587-dandelion-1097518082.jpg") #Change the file of the picture you want altered

#used for duplicity
set.seed(123)



