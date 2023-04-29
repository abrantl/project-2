#This code changes pixels to yellow within a certain region of the picture

#Install the required packages. 
#install.packages("jpeg")

library(jpeg)

main_func <- function(name) {
  img <- readJPEG(name)
  new_name <- gsub("\\.jpg$", "_dist.jpg", name)
  
 prob <- 0.01
  num_pixels <- round(prob * length(img))
  
# Get image dimensions
img_width <- dim(img)[1]
img_height <- dim(img)[2]

# Define rectangle dimensions
rect_w <- img_width /4
rect_h <- img_height / 1
rect_x <- img_width / 2
rect_y <- 0

# Define dandelion yellow color
new_color <- c(240, 225, 48) # dandelion yellow color
new_color <- new_color / 255

# choose random num_pixels in the given rectangle
x <- sample(rect_x:(rect_x + rect_w), num_pixels, replace = TRUE)
y <- sample(rect_y:(rect_y + rect_h), num_pixels, replace = TRUE)

# Change color of random pixels
for (i in 1:num_pixels) {
  img[x[i], y[i], ] <- new_color
}

writeJPEG(img, new_name)
}

#set a working directory. Make sure the directory goes where the images you want to alter
setwd("C:/Users/annab/OneDrive/Documents/project-2/grass") 

main_func("th-51260682_flip.jpg") #Change the file of the picture you want altered

#used for duplicity
set.seed(123)


