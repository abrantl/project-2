

#Install the required packages. 
#install.packages("jpeg")

library(jpeg)
library(magick)
library(tidyverse)
library(keras)
library(tensorflow)
library(reticulate)
library(imager)

yellow_func <- function(name) {
  #This code changes pixels to yellow within a certain region of the picture
  img <- readJPEG(name)
  new_name <- gsub("\\.jpg$", "_dist.jpg", name)
  
  # Get image dimensions
  img_width <- dim(img)[1]
  img_height <- dim(img)[2]
  num_pixels <- round(img_width * img_height / 100)
  
  # Define rectangle dimensions
  rect_w <- img_width /4
  rect_h <- img_height / 1
  rect_x <- 500
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
  
  return(new_name)
}

yellow_box_func <- function(name) {
  #This code adds a yellow square to the middle of the image.
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
  
  return(new_name)
}

flip_func <- function(name) {
  #code flips image horizontally
  img_path <- name
  
  new_name <- gsub("\\.jpg$", "_flip.jpg", name)
  
  img <- image_read(img_path, density = NULL, depth = NULL, strip = FALSE)
  
  flip_img <- image_flip(img)
  #print(flip_img)
  
  image_write(flip_img, new_name)
  
  return(new_name)
  
}

modify_func <- function(name) {
  #This code changes random pixels with a set budget
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
  
  return(new_name)
}

green_func <- function(name) {
  #changes green pixels to other colors
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
  
  return(new_name)
}



#set a working directory. Make sure the directory goes where the images you want to alter
setwd("C:/Users/oopsw/Desktop/project2/project-2/test") 
img <- "18-4196734595.jpg"

#pass all picture to flip algorithm first, 1st algorithm
flipped <- flip_func(img) #Change the file of the picture you want altered

#pass flipped image to algorithm to change randomly change set budget, 2nd algorithm
modify_func(flipped) #Change the file of the picture you want altered

#pass flipped image to algorithm that change pixel yellow randomly, 3rd algorithm
yellow_func(flipped) #Change the file of the picture you want altered

#pass flipped image to algorithm that draw a yellow box of pixel yellow, 4th algorithm 
yellow_box_func(flipped) #Change the file of the picture you want altered

#pass flipped image to algorithm that change pixels green, 5th algorithm
green_func(flipped) #Change the file of the picture you want altered

#get prediction results from pre-trained model
# Load a pre-trained neural network
model<-load_model_tf("./../dandelion_model")

res=c("","")
f=list.files(getwd())
rates <- list()
for (i in f){
  test_image <- image_load(paste("./",i,sep=""), #Need to create folder named dandelions and add images of dandelions to it. 
                           target_size = c(224,224))
  x <- image_to_array(test_image) #turn to array
  x <- array_reshape(x, c(1, dim(x))) #reshape to 1 line
  x <- x/255 # resize
  
  
  pred <- model %>% predict(x)
  rates[[i]] <- list(pred)
}

img_unlist <- as.numeric(unlist(rates[img]))
dandelion <- img_unlist[1] > img_unlist[2] #determine if the original image is predicted as dandelion or grass
if(dandelion) {
  dandelion <- 1
} else{
  dandelion <- 2
}

f=list.files(getwd())
diff <- c()
k <- 1
for (i in f) {
  temp_unlist <- as.numeric(unlist(rates[i]))
  diff[k] <- img_unlist[dandelion] - temp_unlist[dandelion]
  k = k+1
}
best_output_file <- f[which(diff == max(diff))]
accuracy <- rates[best_output_file]

print(best_output_file)
print("Original file prediction")
print(rates[img])
print("Modified file prediction")
print(accuracy)

#used for duplicity
set.seed(123)
