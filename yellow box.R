#This code adds a yellow square to the middle of the image.

#Install the required packages. 
#install.packages("jpeg")

library(jpeg)

main_func <- function(name) {
  img <- readJPEG(name)
  
  new_name <- gsub("\\.jpg$", "_conc.jpg", name)
  
  # Get image dimensions
  img_width <- dim(img)[1]
  img_height <- dim(img)[2]
  
  prob <- 0.01
  num_pixels <- round(prob * length(img))
  
  # Define rectangle dimensions
  rect_width <- round(sqrt(num_pixels),0)
  rect_height <- round(num_pixels / rect_width, 0)
  rect_x <- (img_width - rect_width) /2
  rect_y <- (img_height - rect_height) /2
  
  # Set all pixel colors to yellow within the rectangle
  img[rect_x:(rect_x + rect_width), rect_y:(rect_y + rect_height), 1] <- 0.9 # Set red channel to 0.9
  img[rect_x:(rect_x + rect_width), rect_y:(rect_y + rect_height), 2] <- 0.8 # Set green channel to 0.8
  img[rect_x:(rect_x + rect_width), rect_y:(rect_y + rect_height), 3] <- 0 # Set blue channel to 0
  
  writeJPEG(img, new_name)
}

#set a working directory. Make sure the directory goes where the images you want to alter
setwd("C:/Users/annab/OneDrive/Documents/project-2/grass") 

main_func("th-51260682.jpg") #Change the file of the picture you want altered

#used for duplicity
set.seed(123)

