#INSTALL PACKAGES===============================================================
#install.packages("jpeg")
#install.packages("magick")
#install.packages("tidyverse")
#install.packages("keras")
#install.packages("tensorflow")
#install.packages("reticulate")
#install_tensorflow(extra_packages="pillow")
#install_keras()

#IMPORT LIBRARIES===============================================================
library(jpeg)
library(magick)
library(tidyverse)
library(keras)
library(tensorflow)
library(reticulate)
library(imager)

#ALGORITHM 5====================================================================
#Function Name: yellow_dist_func, Dispersed rectangle Pixel algorithm
#Function Description: This code changes pixels to yellow within a certain region of the picture
#Function Contributors: Anna Brantley, Daniel Castellanos, Mitch Coapstick, Lucy Han, Laramie Lilly
#Function Head Director: Laramie Lilly, Anna Brantley
#Function Head Commententor: Laramie Lilly
#citation(s): (Adam SOAdam SO9 et al., 1958) (Urbanek, 2022)
#Inputs: image name (file name). This must be a string ending with .jpg, and must be a valid file name, with a file of length > 0, null 
#------Expected type: string.jpg
#------Actual type: may recive string.png as well
#Outputs: A new .jpg image with a random one percent of the pixels, concentrated to rectangle changed to yellow.
#-------Expected type: string.jpg
#-------Actual type: string.jpg, null
# saves the new image as oldname_dist.jpg

yellow_dist_func <- function(name) {
  #sets img to jpg being processed
  img <- readJPEG(name) 
  
  #sets new_name to the original file name with the added new ending
  new_name <- gsub("\\.jpg$", "_dist.jpg", name)
  
  #Get image dimensions
  #img_width and img:height :: Expected: numeric + int Actual: numeric + int where width * height >= one percent of total pixels
  img_width <- dim(img)[1]
  img_height <- dim(img)[2]
 
  #Define the probability of changing a pixel - pixel budget
  #prob :: Expected: numeric double, Actual: numeric double, numeric int
  num_pixels <- round(img_width * img_height / 100)
  
  #Define rectangle dimensions
  #rect_letter and img:height :: Expected: numeric + int Actual: numeric + int
  rect_w <- img_width /4
  rect_h <- img_height / 1
  rect_x <- img_width / 2
  rect_y <- 0
  
  #Define dandelion yellow color
  new_color <- c(240, 225, 48) # dandelion yellow color
  new_color <- new_color / 255
  
  # choose random num_pixels in the given rectangle
  # without constraining the selection to the point of not having a large enough rectangle to change one percent of total pixels
  #x, y :: Expected: vector of one percent of total pixels with indices within the rectangle Actual: same 
  x <- sample(rect_x:(rect_x + rect_w), num_pixels, replace = TRUE)
  y <- sample(rect_y:(rect_y + rect_h), num_pixels, replace = TRUE)
  
  # Change color of random pixels
  for (i in 1:num_pixels) {
    img[x[i], y[i], ] <- new_color
  }
  
  #Saves modified image in the folder
  writeJPEG(img, new_name)
  
  return(new_name)
}

#ALGORITHM 4====================================================================
#Function Name: yellow_conc_func, Solid Rectangle Pixel algorithm
#Function Description: This code adds a yellow square to the middle of the image.
#Function Contributors: Anna Brantley, Daniel Castellanos, Mitch Coapstick, Lucy Han, Laramie Lilly
#Function Head Director: Laramie Lilly, Anna Brantley
#Function Head Commentator: Laramie Lilly
#citation(s): (Urbanek, 2022)
#Inputs: image name (file name). This must be a string ending with .jpg, and must be a valid file name, with a file of length > 0, null 
#------Expected type: string.jpg
#------Actual type: may recive string.png as well
#Outputs: A new .jpg image with a rectangle in the center of the image of area = one percent of pixels, changed to yellow.
#-------Expected type: string.jpg
#-------Actual type: string.jpg, null
# saves the new image as oldname_conc.jpg

yellow_conc_func <- function(name) {
  #sets img to jpg being processed
  img <- readJPEG(name)
  
  #sets new_name to the original file name with the added new ending
  new_name <- gsub("\\.jpg$", "_conc.jpg", name)

  #Get image dimensions
  #img_width and img:height :: Expected: numeric + int Actual: numeric + int where width * height >= one percent of total pixels
  img_width <- dim(img)[1]
  img_height <- dim(img)[2]
  
  #Define the probability of changing a pixel - pixel budget
  #prob :: Expected: numeric double, Actual: numeric double, numeric int
  prob <- 0.01
  num_pixels <- round(prob * length(img))
  
  # Define rectangle dimensions
  #rect_letter and img:height :: Expected: numeric + int Actual: numeric + int
  rect_width <- round(sqrt(num_pixels),0)
  rect_height <- round(num_pixels / rect_width, 0)
  rect_x <- (img_width - rect_width) /2
  rect_y <- (img_height - rect_height) /2
  
  # Set all pixel colors to yellow within the rectangle
  # img :: Expected: a final img vector with a dulled yellow rectangle
  img[rect_x:(rect_x + rect_width), rect_y:(rect_y + rect_height), 1] <- 0.9 # Set red channel to 0.9
  img[rect_x:(rect_x + rect_width), rect_y:(rect_y + rect_height), 2] <- 0.8 # Set green channel to 0.8
  img[rect_x:(rect_x + rect_width), rect_y:(rect_y + rect_height), 3] <- 0 # Set blue channel to 0
  
  #Saves modified image in the folder
  writeJPEG(img, new_name)
  
  return(new_name)
}

#ALGORITHM 1 ===================================================================
#Function Name:flip_func, Flipping algorithm
#Function Description: This code flips image horizontally.
#Function Contributors: Anna Brantley, Daniel Castellanos, Mitch Coapstick, Lucy Han, Laramie Lilly
#Function Head Director: Laramie Lilly, Anna Brantley
#Function Head Commententor: Laramie Lilly
#citation(s): (2022) (2023)
#Inputs: image name (file name). This must be a string ending with .jpg, and must be a valid file name, with a file of length > 0, null 
#------Expected type: string.jpg
#------Actual type: may recive string.png as well
#Outputs: A new .jpg image flipped horizontally
#-------Expected type: string.jpg
#-------Actual type: string.jpg, null
# saves the new image as oldname_flip.jpg

flip_func <- function(name) {
  #sets img_path to jpg being processed
  img_path <- name
  
  #sets new_name to the original file name with the added new ending
  new_name <- gsub("\\.jpg$", "_flip.jpg", name)# new name is the name the altered image will be saved under
  
  img <- image_read(img_path, density = NULL, depth = NULL, strip = FALSE)
  
  #image_flip from magick library
  #Possible Inputs: jpeg image variable processed by image_read 
  #Possible Outputs: Horizontally flipped version of the image variable
  flip_img <- image_flip(img)#sets flipped_image equal to a version of the image that is horizontally flipped
  
  image_write(flip_img, new_name)
  
  return(new_name)
}

#ALGORITHM 2====================================================================
#Function Name: modify_func, Black Pixel algorithm
#Function Description: Changes a random one percent of pixels in a given image to black
#Function Contributors: Anna Brantley, Daniel Castellanos, Mitch Coapstick, Lucy Han, Laramie Lilly
#Function Head Director: Anna Brantley
#Function Head Commententor: Laramie Lilly
#citation(s): (R lesson #8 - matrix manipulation and images)
#Inputs: image name (file name). This must be a string ending with .jpg, and must be a valid file name, with a file of length > 0, null 
#------Expected type: string.jpg
#------Actual type: may recive string.png as well
#Outputs: A new .jpg image with a random one percent of the pixels changed to black.
#-------Expected type: string.jpg
#-------Actual type: string.jpg, null
# saves the new image as oldname_modified.jpg

modify_func <- function(name) {
  #sets img to jpg being processed
  img <- readJPEG(name)
  
  #sets new_name to the original file name with the added new ending
  new_name <- gsub("\\.jpg$", "_modified.jpg", name)
  
  #Define the probability of changing a pixel - pixel budget
  #prob :: Expected: numeric double, Actual: numeric double, numeric int
  prob <- 0.01
  
  # Calculate the number of pixels to change
  # num_pixels :: Expected: numeric int, Actual: numeric int
  num_pixels <- round(prob * length(img))
  
  # Generate a vector of random pixel indices
  # pixels_to_change:: Expected: vector of length two percent of the total image, numeric Actual: same
  pixels_to_change <- sample.int(length(img), num_pixels)
  
  # Generate a vector of random values to replace the pixels
  new_values <- runif(num_pixels)
  
  # Replace the pixels in the image with the new values
  #img :: Expected: new image array with different pixel values Actual: same
  img[pixels_to_change] <- new_values
  
  writeJPEG(img, new_name)
  
  return(new_name)
}

#ALGORITHM 3====================================================================
#Function Name: green_func, green-to-rainbow
#Function Description: This code changes a random selection of green pixels. It changes one percent of the total pixels to any color. 
#Function Contributors: Anna Brantley, Daniel Castellanos, Mitch Coapstick, Lucy Han, Laramie Lilly
#Function Head Director: Anna Brantley
#Function Head Commententor: Laramie Lilly
#citation(s): (Walker, 2016)
#Inputs: image name (file name). This must be a string ending with .jpg, and must be a valid file name, with a file of length > 0, null 
#------Expected type: string.jpg
#------Actual type: may recive string.png as well
#Outputs: A new .jpg image with a semi-random one percent of the pixels changed. All pixels changed would start as green pixels. 
#-------Expected type: string.jpg
#-------Actual type: string.jpg, null
# saves the new image as oldname_green.jpg

green_func <- function(name) {
  #sets img to jpg being processed
  img <- readJPEG(name)
  
  #sets new_name to the original file name with the added new ending
  new_name <- gsub("\\.jpg$", "_green.jpg", name)

  #Define the probability of changing a pixel - pixel budget
  #prob :: Expected: numeric double, Actual: numeric double, numeric int
  prob <- 0.01
  
  #Calculate the number of green pixels to change
  #prob :: Expected: numeric double, Actual: numeric double, numeric int
  num_pixels <- round(prob * length(img))
  
  # Get the green channel of the image
  green_channel <- img[,,2]
  
  # Generate a vector of random pixel indices for only green pixels
  # Green_pixels_to_change:: Expected: vector of length two percent of the total image, numeric Actual: same
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
setwd("C:/Users/annab/OneDrive/Documents/project-2/black") 


#get prediction results from pre-trained model
#Load a pre-trained neural network
model<-load_model_tf("./../dandelion_model")
f=list.files(getwd())
edited <- c()

for(i in f){
  img <- i
  
  edited[1] <- img
  #pass all picture to flip algorithm first, 1st algorithm
  flipped <- flip_func(img) #Change the file of the picture you want altered
  edited[2] <- flipped
  
  #pass flipped image to algorithm to change randomly change set budget, 2nd algorithm
  edited[3] <- modify_func(flipped) #Change the file of the picture you want altered
  #pass flipped image to algorithm that change pixel yellow randomly, 3rd algorithm
  edited[4] <- yellow_dist_func(flipped) #Change the file of the picture you want altered
  #pass flipped image to algorithm that draw a yellow box of pixel yellow, 4th algorithm 
  edited[5] <- yellow_conc_func(flipped) #Change the file of the picture you want altered
  #pass flipped image to algorithm that change pixels green, 5th algorithm
  edited[6] <- green_func(flipped) #Change the file of the picture you want altered
  
  rates <- list()
  for (j in edited){
    test_image <- image_load(paste("./",j,sep=""), #Need to create folder named dandelions and add images of dandelions to it. 
                             target_size = c(224,224))
    x <- image_to_array(test_image) #turn to array
    x <- array_reshape(x, c(1, dim(x))) #reshape to 1 line
    x <- x/255 # resize
    
    pred <- model %>% predict(x)
    print(j)
    rates[[j]] <- list(pred)
  }
  
  img_unlist <- as.numeric(unlist(rates[img]))
  dandelion <- img_unlist[1] > img_unlist[2] #determine if the original image is predicted as dandelion or grass
  if(dandelion) {
    dandelion <- 1
  } else{
    dandelion <- 2
  }
  
  diff <- c()
  k <- 1
  for (j in edited) {
    temp_unlist <- as.numeric(unlist(rates[j]))
    diff[k] <- img_unlist[dandelion] - temp_unlist[dandelion]
    k = k+1
  }
  best_output_file <- edited[which(diff == max(diff))]
  accuracy <- rates[best_output_file]
  
  
  print("Original file prediction")
  print(rates[img])
  print("Modified file prediction")
  print(accuracy)
  
  #used for duplicity
  set.seed(123)
}

