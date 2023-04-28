#This code changes random pixels with a set budget

#Install the required packages. 
#install.packages("jpeg")


library(jpeg)

main_func <- function(name) {
  img <- readJPEG(name)
  
  new_name <- gsub("\\.jpg$", "_modified.jpg", name)
  
  # Define the probability of changing a pixel - pixel budget
  prob <- 0.01
  
  # Calculate the number of pixels to change
  num_pixels <- round(prob * length(img))
  
  # Generate a vector of random pixel indices
  pixels_to_change <- sample.int(length(img), num_pixels)
  
  # Generate a vector of random values to replace the pixels
  new_values <- runif(num_pixels)
  
  # Replace the pixels in the image with the new values
  img[pixels_to_change] <- new_values
  
  writeJPEG(img, new_name)
}

#set a working directory. Make sure the directory goes where the images you want to alter
setwd("C:/Users/annab/OneDrive/Documents/project-2/grass") 

main_func("th-51260682.jpg") #Change the file of the picture you want altered

#used for duplicity
set.seed(123)

